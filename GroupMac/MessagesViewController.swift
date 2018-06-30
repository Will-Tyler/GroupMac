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

	var messages: [GMMessage]? {
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
		super.viewDidLoad()

		scrollView.documentView = messagesCollectionView
		
		messagesCollectionView.delegate = self
		messagesCollectionView.dataSource = self
		messagesCollectionView.register(MessageCell.self, forItemWithIdentifier: MessageCell.cellIdentifier)
	}
	override func viewWillLayout() {
		super.viewWillLayout()
		
		messagesCollectionView.collectionViewLayout!.invalidateLayout()
	}

	//MARK: Collection view
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages?.count ?? 0
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: MessageCell.cellIdentifier, for: indexPath) as! MessageCell
		let count = messages!.count
		let message = messages![count-1 - indexPath.item]

		item.message = message

		return item
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		// Layout usually occurs before cell creation.
		// Create a cell to determine the correct height
		// Creating a cell doesn't work. Recreate labels to get estimated desired height

		let desiredHeight: CGFloat = {
			let restrictedSize = CGSize(width: collectionView.bounds.width-8, height: .greatestFiniteMagnitude)
			let drawingOptions = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
			let labels: (name: NSString, text: NSString?) = {
				let count = messages!.count
				let message = messages![count-1 - indexPath.item]

				return (name: message.name as NSString, text: message.text as NSString?)
			}()

			let nameEstimate: CGRect = labels.name.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [NSAttributedStringKey.font: NSTextField().font!])
			let textEstimate: CGRect? = labels.text?.boundingRect(with: restrictedSize, options: drawingOptions, attributes: nil)

			return nameEstimate.height + (textEstimate?.height ?? 0) + 24
		}()

		return NSSize(width: collectionView.bounds.width, height: desiredHeight)
	}

}

final fileprivate class MessageCell: NSCollectionViewItem {
	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.boldSmall
		field.textColor = NSColor(red: 0x62 / 255, green: 0x6f / 255, blue: 0x82 / 255, alpha: 1)

		return field
	}()
	private let textLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regular

		return field
	}()

	var message: GMMessage! {
		didSet {
			nameLabel.stringValue = message.name
			if let text = message.text {
				textLabel.stringValue = text
			}
		}
	}

	private func setupInitialLayout() {
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		view.addSubview(textLabel)

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer?.backgroundColor = CGColor(red: 0xe5 / 255, green: 0xf1 / 255, blue: 0xf6 / 255, alpha: 1)

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}
}






























