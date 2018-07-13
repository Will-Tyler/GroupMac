//
//  ConversationCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class ConversationCell: NSCollectionViewItem {

	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ConversationCell")

	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regular
		field.backgroundColor = .clear
		field.isSelectable = false

		return field
	}()
	private let previewLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regularSmall
		field.backgroundColor = .clear
		field.isSelectable = false

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
			switch conversation.convoType {
			case .chat:
				let chat = conversation as! GroupMe.Chat

				chat.handlePreviewText(with: { (previewText) in
					DispatchQueue.main.async {
						self.previewLabel.stringValue = previewText
					}
				})
				DispatchQueue.main.async { // doesn't do anything without this - weird
					self.groupImageView.wantsLayer = true
					self.groupImageView.layer!.cornerRadius = self.groupImageView.bounds.width / 2
					self.groupImageView.layer!.masksToBounds = true
				}

			case .group:
				let group = conversation as! GroupMe.Group

				previewLabel.stringValue = group.messagesInfo.preview.text ?? ""
			}

			if let url = conversation.imageURL {
				HTTP.handleImage(at: url, with: { (image: NSImage) in
					DispatchQueue.main.async {
						self.groupImageView.image = image
					}
				})
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

	func addSeparatorToTop() {
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

			view.backColor = Colors.background

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}
	override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)

		NSCursor.pointingHand.push()

		if !isSelected {
			view.backColor = Colors.semiWhite
		}
	}
	override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)

		NSCursor.pop()

		if !isSelected {
			view.backColor = Colors.background
		}
	}
}













































