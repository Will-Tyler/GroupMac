//
//  ConvosViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


class ConvosViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private lazy var conversations: [GMConversation] = {
		var convos = GroupMe.groups as [GMConversation] + GroupMe.chats as [GMConversation]

		convos.sort(by: { $0.updatedAt > $1.updatedAt })

		return convos
	}()
	private lazy var borderView: NSView = {
		let view = NSView()

		view.wantsLayer = true
		view.layer!.borderWidth = 1
		view.layer!.borderColor = Colors.border

		return view
	}()
	private lazy var convosCollectionView: NSCollectionView = {
		let collectionView = NSCollectionView()
		let flowLayout: CollectionLayout = {
			let layout = CollectionLayout()

			layout.minimumLineSpacing = 0

			return layout
		}()

		collectionView.collectionViewLayout = flowLayout
		collectionView.isSelectable = true

		return collectionView
	}()
	private lazy var scrollView = NSScrollView()

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
		view = borderView
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		scrollView.documentView = convosCollectionView

		convosCollectionView.delegate = self
		convosCollectionView.dataSource = self
		convosCollectionView.register(ConversationCell.self, forItemWithIdentifier: ConversationCell.cellID)

		setupInitialLayout()
	}
	override func viewDidLayout() {
		super.viewDidLayout()

		convosCollectionView.collectionViewLayout!.invalidateLayout()
	}

	var convoViewController: ConvoViewController!

	//MARK: Collection view
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return conversations.count
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let cell = collectionView.makeItem(withIdentifier: ConversationCell.cellID, for: indexPath) as! ConversationCell

		cell.conversation = conversations[indexPath.item]
		if indexPath.item != 0 { cell.addSeparatorToTop() }

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
