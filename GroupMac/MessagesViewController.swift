//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class MessagesViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private let messageCellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")
	private let messagesCollectionView: NSCollectionView = {
		let collectionView = NSCollectionView()
		let flowLayout: NSCollectionViewFlowLayout = {
			let flow = NSCollectionViewFlowLayout()

			flow.minimumLineSpacing = 4

			return flow
		}()

		collectionView.collectionViewLayout = flowLayout
		collectionView.isSelectable = false

		return collectionView
	}()
	private let scrollView = NSScrollView()

	var messages: [GroupMeMessage]? {
		didSet {
			DispatchQueue.main.async {
				self.messagesCollectionView.reloadData()
			}
		}
	}

	override func loadView() {
		view = scrollView
	}
	override func viewDidLoad() {
		scrollView.documentView = messagesCollectionView
		
		messagesCollectionView.delegate = self
		messagesCollectionView.dataSource = self
		messagesCollectionView.register(MessageCell.self, forItemWithIdentifier: messageCellIdentifier)
	}

	//MARK: Collection view
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages?.count ?? 0
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: messageCellIdentifier, for: indexPath) as! MessageCell
		let message = messages![indexPath.item]

		item.nameLabel.stringValue = message.name

		return item
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		return NSSize(width: collectionView.bounds.width, height: 40)
	}

}

final fileprivate class MessageCell: NSCollectionViewItem {
	let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false

		return field
	}()
	let textLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false

		return field
	}()

	private func setupInitialLayout() {
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
	}

	override func loadView() {
		view = NSView()
	}
	override func viewDidLoad() {
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor.lightGray.cgColor

		setupInitialLayout()
	}
}






























