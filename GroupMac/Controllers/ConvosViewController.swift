//
//  ConvosViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


final class ConvosViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private lazy var collectionView: NSCollectionView = {
		let layout = CollectionLayout()

		layout.minimumLineSpacing = 0

		let collectionView = NSCollectionView()

		collectionView.collectionViewLayout = layout
		collectionView.isSelectable = true

		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(ConversationCell.self, forItemWithIdentifier: ConversationCell.cellID)

		return collectionView
	}()
	private lazy var scrollView: NSScrollView = {
		let scroll = NSScrollView()

		scroll.documentView = collectionView

		return scroll
	}()

	private func setupInitialLayout() {
		view.removeSubviews()

		view.addSubview(scrollView)

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 1).isActive = true
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1).isActive = true
	}

	override func loadView() {
		view = NSView()

		view.wantsLayer = true
		view.layer!.borderWidth = 1
		view.layer!.borderColor = Colors.border
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
		loadConversations()
	}
	override func viewDidLayout() {
		super.viewDidLayout()

		collectionView.collectionViewLayout!.invalidateLayout()
	}

	var convoViewController: ConvoViewController!
	private var conversations = [GMConversation]()

	private func loadConversations() {
		let group = DispatchGroup()
		var convos = [GMConversation]()

		group.enter()
		GroupMe.handleGroups(with: { groups in
			let newConvos = groups as [GMConversation]

			convos.append(contentsOf: newConvos)
			group.leave()
		})

		group.enter()
		GroupMe.handleChats(with: { chats in
			convos.append(contentsOf: chats as [GMConversation])
			group.leave()
		})

		group.notify(queue: .main, execute: {
			convos.sort(by: { $0.updatedAt > $1.updatedAt })
			
			self.conversations = convos
			self.collectionView.reloadData()
		})
	}

	// MARK: Collection view
	func numberOfSections(in collectionView: NSCollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return conversations.count
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let cell = collectionView.makeItem(withIdentifier: ConversationCell.cellID, for: indexPath) as! ConversationCell

		cell.conversation = conversations[indexPath.item]

		if indexPath.item != 0 {
			cell.addSeparatorToTop()
		}

		let options = NSTrackingArea.Options.mouseEnteredAndExited.union(.activeInActiveApp)
		let trackingArea = NSTrackingArea(rect: cell.view.bounds, options: options, owner: cell.view, userInfo: nil)

		cell.view.addTrackingArea(trackingArea)

		return cell
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		// It is likely more efficient to hard code height than calculate it.
		return NSSize(width: collectionView.bounds.width, height: 65)
	}
	func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
		let indexPath = indexPaths.first!
		let cell = collectionView.item(at: indexPath) as! ConversationCell
		let conversation: GMConversation! = cell.conversation

		convoViewController.conversation = conversation
	}

}
