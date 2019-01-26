//
//  MessagesView.swift
//  GroupMac
//
//  Created by Will Tyler on 1/25/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import AppKit


class MessagesView: NSScrollView, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private lazy var collectionView: NSCollectionView = {
		let layout = NSCollectionViewFlowLayout()

		layout.minimumLineSpacing = 0
		layout.scrollDirection = .vertical

		let collection = NSCollectionView()

		collection.collectionViewLayout = layout
		collection.isSelectable = false

		collection.delegate = self
		collection.dataSource = self
		collection.register(UserMessageCell.self, forItemWithIdentifier: UserMessageCell.cellID)
		collection.register(SystemMessageCell.self, forItemWithIdentifier: SystemMessageCell.cellID)

		collection.wantsLayer = true
		collection.layer!.borderWidth = 1
		collection.layer!.borderColor = Colors.border

		return collection
	}()

	override func layout() {
		super.layout()

		documentView = collectionView
	}

	var messages = [GMMessage]() {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}

//	@objc
//	private func heartButtonAction(sender: HeartButton) {
//		let messageCell = collectionView.item(at: sender.tag)! as! MessageCell
//
//		messageCell.toggleLike()
//	}

	// Collection view
	func numberOfSections(in collectionView: NSCollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
//		let count = messages.count
//		let message = messages[count-1 - indexPath.item]
//
//		let cellID = message.isSystem ? SystemMessageCell.cellID : UserMessageCell.cellID
//		let item = collectionView.makeItem(withIdentifier: cellID, for: indexPath) as! MessageCell
//
//		item.message = message
//
//		item.heartButton.tag = indexPath.item
//		item.heartButton.target = self
//		item.heartButton.action = #selector(heartButtonAction(sender:))
//
//		let trackingOptions = NSTrackingArea.Options.mouseEnteredAndExited.union(.activeInActiveApp)
//		let trackingArea = NSTrackingArea(rect: item.heartButton.bounds, options: trackingOptions, owner: item.heartButton, userInfo: nil)
//
//		item.heartButton.addTrackingArea(trackingArea)
//
//		return item
		return collectionView.makeItem(withIdentifier: UserMessageCell.cellID, for: indexPath)
	}

}
