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

		item.name = message.name
		item.text = message.text

		return item
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		return NSSize(width: collectionView.bounds.width, height: 40)
	}

}

final fileprivate class MessageCell: NSCollectionViewItem {
	var name: String!
	var text: String?

	override func loadView() {
		view = NSView()

		view.wantsLayer = true
		view.layer!.backgroundColor = NSColor.blue.cgColor
	}
}
