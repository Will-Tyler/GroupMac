//
//  ConvosViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class ConvosViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private let conversations: [Conversation] = {
		var convos = GroupMe.groups as [Conversation] + GroupMe.chats as [Conversation]

		convos.sort(by: { return $0.updatedAt > $1.updatedAt })

		return convos
	}()
	private let convosCollectionView: NSCollectionView = {
		let collectionView = NSCollectionView()
		let flowLayout: NSCollectionViewFlowLayout = {
			let flow = NSCollectionViewFlowLayout()

			return flow
		}()

		collectionView.collectionViewLayout = flowLayout
		collectionView.isSelectable = true

		return collectionView
	}()
	private let scrollView = NSScrollView()

	var messagesDelegate: MessagesViewController?

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

		return cell
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		return NSSize(width: collectionView.bounds.width, height: 40)
	}
	func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
		let indexPath = indexPaths.first!
		let conversation: Conversation! = (collectionView.item(at: indexPath) as! ConversationCell).conversation

		messagesDelegate?.messages = conversation.blandMessages
	}

}

final fileprivate class ConversationCell: NSCollectionViewItem {
	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ConversationCell")
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.font = NSFont(name: "Segoe UI", size: NSFont.systemFontSize(for: .regular))

		return field
	}()
	private let previewLabel = NSTextField()

	var conversation: Conversation! {
		didSet {
			nameLabel.stringValue = conversation.name
		}
	}

	private func setupInitialLayout() {
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
	}

	override func loadView() {
		view = NSView()
	}
	override func viewDidLoad() {
		setupInitialLayout()
	}
}
















































