//
//  ConvosViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class ConvosViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private let conversations: [GMConversation] = {
		var convos = GroupMe.groups as [GMConversation] + GroupMe.chats as [GMConversation]

		convos.sort(by: { return $0.updatedAt > $1.updatedAt })

		return convos
	}()
	private let convosCollectionView: NSCollectionView = {
		let collectionView = NSCollectionView()
		let flowLayout = NSCollectionViewFlowLayout()

		collectionView.collectionViewLayout = flowLayout
		collectionView.isSelectable = true

		return collectionView
	}()
	private let scrollView = NSScrollView()
	private var didNotifyViewDelegate = false

	var messagesDelegate: MessagesViewController?
	var viewDelegate: ViewController?

	override func loadView() {
		view = scrollView
	}
	override func viewDidLoad() {
		scrollView.documentView = convosCollectionView

		convosCollectionView.delegate = self
		convosCollectionView.dataSource = self
		convosCollectionView.register(ConversationCell.self, forItemWithIdentifier: ConversationCell.cellIdentifier)
	}

	//MARK: Collection view
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return conversations.count
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let cell = collectionView.makeItem(withIdentifier: ConversationCell.cellIdentifier, for: indexPath) as! ConversationCell

		cell.conversation = conversations[indexPath.item]
		if indexPath.item != 0 { cell.addSeparatorToTop() }

		return cell
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		return NSSize(width: collectionView.bounds.width, height: 59)
	}
	func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
		let indexPath = indexPaths.first!
		let conversation: GMConversation! = (collectionView.item(at: indexPath) as! ConversationCell).conversation

		if !didNotifyViewDelegate {
			viewDelegate?.hasSelectedConversation()
			didNotifyViewDelegate = true
		}

		messagesDelegate?.messages = conversation.blandMessages
	}

}

final fileprivate class ConversationCell: NSCollectionViewItem {
	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ConversationCell")
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regular

		return field
	}()
	private let previewLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regularSmall

		return field
	}()

	var conversation: GMConversation! {
		didSet {
			nameLabel.stringValue = conversation.name
			previewLabel.stringValue = conversation.firstMessage.text ?? ""
		}
	}

	func addSeparatorToTop() {
		let separator: NSView = {
			let view = NSView()

			view.wantsLayer = true
			let color: CGFloat = 230 / 255
			view.layer!.backgroundColor = CGColor(red: color, green: color, blue: color, alpha: 1)

			return view
		}()

		view.addSubview(separator)

		separator.translatesAutoresizingMaskIntoConstraints = false
		separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		separator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		separator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}

	private func setupInitialLayout() {
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		view.addSubview(previewLabel)

		previewLabel.translatesAutoresizingMaskIntoConstraints = false
		previewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		previewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		previewLabel.heightAnchor.constraint(equalToConstant: 2 * previewLabel.intrinsicContentSize.height).isActive = true
		previewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer!.backgroundColor = CGColor(red: 0xe5 / 255, green: 0xf1 / 255, blue: 0xf6 / 255, alpha: 1)

			return view
		}()
	}
	override func viewDidLoad() {
		setupInitialLayout()

		let options = NSTrackingArea.Options.mouseEnteredAndExited.union(.activeAlways)
		let trackingArea = NSTrackingArea(rect: view.frame, options: options, owner: self, userInfo: nil)

		view.addTrackingArea(trackingArea)
	}
	override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)
		print("Mouse entered...")
	}
}
















































