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

	var conversation: GMConversation! {
		didSet {
			messages = conversation.blandMessages
		}
	}
	private var messages: [GMMessage]? {
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
			let restrictedSize = CGSize(width: collectionView.bounds.width - (12+24), height: .greatestFiniteMagnitude)
			let drawingOptions = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
			let labels: (name: NSString, text: NSString?) = {
				let count = messages!.count
				let message = messages![count-1 - indexPath.item]

				return (name: message.name as NSString, text: message.text as NSString?)
			}()

			let nameEstimate: CGRect = labels.name.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: Fonts.boldSmall])
			let textEstimate: CGRect? = labels.text?.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: Fonts.regular])

			return nameEstimate.height + (textEstimate?.height ?? 0) + 1
		}()

		return NSSize(width: collectionView.bounds.width, height: desiredHeight)
	}

}

final fileprivate class MessageCell: NSCollectionViewItem {
	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")
	private let avatarImageView: NSImageView = {
		let view = NSImageView()

		view.image = #imageLiteral(resourceName: "Person Default Image")
		view.imageScaling = NSImageScaling.scaleAxesIndependently
		view.wantsLayer = true
		view.layer!.cornerRadius = 12
		view.layer!.masksToBounds = true

		return view
	}()
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.boldSmall
		field.textColor = NSColor(red: 0x62 / 255, green: 0x6f / 255, blue: 0x82 / 255, alpha: 1)
		field.backgroundColor = .clear

		return field
	}()
	private let textLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regular
		field.backgroundColor = NSColor.clear

		return field
	}()

	var message: GMMessage! {
		didSet {
			nameLabel.stringValue = message.name
			if let text = message.text {
				textLabel.stringValue = text
			}

			if let url = message.avatarURL {
				URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
					guard error == nil, let data = data else { return }

					let image = NSImage(data: data) ?? #imageLiteral(resourceName: "Person Default Image")
					DispatchQueue.main.async {
						self.avatarImageView.image = image
					}
				}.resume()
			}
		}
	}

	private func setupInitialLayout() {
		view.addSubview(avatarImageView)

		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		avatarImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		avatarImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
		avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true

		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		view.addSubview(textLabel)

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer!.backgroundColor = {
				let value: CGFloat = 247 / 255

				return CGColor(red: value, green: value, blue: value, alpha: 1)
			}()

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}
}






























