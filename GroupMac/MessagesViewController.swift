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
		field.font = NSFont(name: "Segoe UI", size: NSFont.smallSystemFontSize)
		field.textColor = NSColor(white: 0.5, alpha: 1)

		return field
	}()
	private let textLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.font = NSFont(name: "Segoe UI", size: NSFont.systemFontSize(for: NSControl.ControlSize.regular))

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
			view.layer?.backgroundColor = NSColor.lightGray.cgColor

			return view
		}()
	}
	override func viewDidLoad() {
		setupInitialLayout()
	}
}






























