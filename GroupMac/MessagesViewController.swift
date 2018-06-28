//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class MessagesViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

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
		messagesCollectionView.register(MessageCell.self, forItemWithIdentifier: MessageCell.cellIdentifier)
	}

	//MARK: Collection view
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages?.count ?? 0
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: MessageCell.cellIdentifier, for: indexPath) as! MessageCell
		let count = messages!.count
		let message = messages![count-1 - indexPath.item]

		(item.name, item.text) = (message.name, message.text)

		return item
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		// Layout usually occurs before cell creation.
		// Create a cell to determine the correct height
		// Creating a cell doesn't work. Recreate labels to get estimated desired height

		let desiredHeight: CGFloat = {
			let createLabel: ()->NSTextField = {
				let field = NSTextField()

				field.isEditable = false

				return field
			}
			let nameLabel = createLabel()
			let textLabel = createLabel()
			guard let count = messages?.count, let message = messages?[count-1 - indexPath.item] else { return 10 }

			(nameLabel.stringValue, textLabel.stringValue) = (message.name, message.text ?? "")

			return nameLabel.intrinsicContentSize.height + textLabel.intrinsicContentSize.height + 12
		}()

		return NSSize(width: collectionView.bounds.width, height: desiredHeight)
	}

}

final fileprivate class MessageCell: NSCollectionViewItem {
	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false

		return field
	}()
	private let textLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false

		return field
	}()

	var name: String {
		get { return nameLabel.stringValue }
		set { nameLabel.stringValue = newValue }
	}
	var text: String? {
		get { return textLabel.stringValue }
		set {
			guard let value = newValue else { return }
			textLabel.stringValue = value
		}
	}

	private func setupInitialLayout() {
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height)
		nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true

		view.addSubview(textLabel)

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		textLabel.heightAnchor.constraint(equalToConstant: textLabel.intrinsicContentSize.height)
		textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer?.backgroundColor = NSColor.lightGray.cgColor

			return view
		}()
	}
	override func viewDidLoad() {
		setupInitialLayout()
	}
}






























