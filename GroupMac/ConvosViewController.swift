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
	private let borderView: NSView = {
		let view = NSView()

		view.wantsLayer = true
		view.layer!.borderWidth = 1
		view.layer!.borderColor = Colors.border

		return view
	}()
	private let convosCollectionView: NSCollectionView = {
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
	private let scrollView = NSScrollView()
	private var hasNotifiedViewController = false

	private func setupInitialLayout() {
		view.addSubview(scrollView)

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 1).isActive = true
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1).isActive = true
	}

	var messagesDelegate: MessagesViewController!
	var viewDelegate: ViewController!

	override func loadView() {
		view = borderView
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		scrollView.documentView = convosCollectionView

		convosCollectionView.delegate = self
		convosCollectionView.dataSource = self
		convosCollectionView.register(ConversationCell.self, forItemWithIdentifier: ConversationCell.cellIdentifier)

		setupInitialLayout()
	}
	override func viewDidLayout() {
		super.viewDidLayout()

		convosCollectionView.collectionViewLayout!.invalidateLayout()
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
		// It is likely more efficient to hard code height than calculate it.
		return NSSize(width: collectionView.bounds.width, height: 65)
	}
	func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
		let indexPath = indexPaths.first!
		let conversation: GMConversation! = (collectionView.item(at: indexPath) as! ConversationCell).conversation

		messagesDelegate.conversation = conversation
		if !hasNotifiedViewController {
			viewDelegate.hasSelectedConversation()
			hasNotifiedViewController = true
		}
	}

}

final fileprivate class ConversationCell: NSCollectionViewItem {
	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ConversationCell")
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regular
		field.backgroundColor = .clear

		return field
	}()
	private let previewLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regularSmall
		field.backgroundColor = .clear

		return field
	}()
	private let groupImageView: NSImageView = {
		let view = NSImageView()

		view.image = #imageLiteral(resourceName: "Group Default Image")
		view.imageScaling = NSImageScaling.scaleAxesIndependently

		return view
	}()

	var conversation: GMConversation! {
		didSet {
			nameLabel.stringValue = conversation.name
			previewLabel.stringValue = conversation.previewText ?? ""

			HTTP.handleImage(at: conversation.imageURL, with: { (image: NSImage) in
				DispatchQueue.main.async {
					self.groupImageView.image = image
				}
			})

			if conversation.conversationType == .chat {
				DispatchQueue.main.async {
					self.groupImageView.wantsLayer = true
					self.groupImageView.layer!.cornerRadius = (self.view.bounds.height - 8) / 2
					self.groupImageView.layer!.masksToBounds = true
				}
			}
		}
	}

	private func setupInitialLayout() {
		view.addSubview(groupImageView)

		groupImageView.translatesAutoresizingMaskIntoConstraints = false
		groupImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		groupImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
		groupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		groupImageView.widthAnchor.constraint(equalTo: groupImageView.heightAnchor).isActive = true

		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 4).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		view.addSubview(previewLabel)

		previewLabel.translatesAutoresizingMaskIntoConstraints = false
		previewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		previewLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 4).isActive = true
		previewLabel.heightAnchor.constraint(equalToConstant: 2 * previewLabel.intrinsicContentSize.height).isActive = true
		previewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	fileprivate func addSeparatorToTop() {
		let separator: NSView = {
			let view = NSView()

			view.wantsLayer = true
			view.layer!.backgroundColor = Colors.separator

			return view
		}()

		view.addSubview(separator)

		separator.translatesAutoresizingMaskIntoConstraints = false
		separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		separator.leftAnchor.constraint(equalTo: groupImageView.leftAnchor).isActive = true
		separator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer!.backgroundColor = Colors.background

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()

//		let options = NSTrackingArea.Options.mouseEnteredAndExited.union(.activeAlways)
//		let trackingArea = NSTrackingArea(rect: view.frame, options: options, owner: self, userInfo: nil)
//
//		view.addTrackingArea(trackingArea)
	}
//	override func mouseEntered(with event: NSEvent) {
//		super.mouseEntered(with: event)
//		print("Mouse entered...")
//	}
}
















































