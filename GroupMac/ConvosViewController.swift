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

	var messagesDelegate: MessagesViewController?
	var viewDelegate: ViewController?

	override func loadView() {
		view = scrollView
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		scrollView.documentView = convosCollectionView

		convosCollectionView.delegate = self
		convosCollectionView.dataSource = self
		convosCollectionView.register(ConversationCell.self, forItemWithIdentifier: ConversationCell.cellIdentifier)
	}
	override func viewWillLayout() {
		super.viewWillLayout()

		(convosCollectionView.collectionViewLayout! as! CollectionLayout).invalidateLayout()
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

		messagesDelegate?.conversation = conversation
		if !hasNotifiedViewController {
			viewDelegate?.hasSelectedConversation()
			hasNotifiedViewController = true
		}
	}

}

final fileprivate class CollectionLayout: NSCollectionViewFlowLayout {
	override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
		return true
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
			previewLabel.stringValue = conversation.firstMessage.text ?? ""

			if let url = conversation.imageURL {
				URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
					guard error == nil, let data = data else { return }

					let image = NSImage(data: data) ?? #imageLiteral(resourceName: "Group Default Image")
					DispatchQueue.main.async {
						self.groupImageView.image = image
					}
				}.resume()
			}

			if conversation.conversationType == .chat {
				DispatchQueue.main.async {
					self.groupImageView.wantsLayer = true
					self.groupImageView.layer!.cornerRadius = (self.view.bounds.height - 8) / 2
					self.groupImageView.layer!.masksToBounds = true
				}
			}
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
		separator.leftAnchor.constraint(equalTo: groupImageView.leftAnchor).isActive = true
		separator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}

	private func setupInitialLayout() {
		view.addSubview(groupImageView)

		groupImageView.translatesAutoresizingMaskIntoConstraints = false
		groupImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		groupImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		groupImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
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

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer!.backgroundColor = CGColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)

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
















































