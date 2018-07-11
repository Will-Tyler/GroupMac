//
//  UserMessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/4/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class UserMessageCell: NSCollectionViewItem {

	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")

	private let avatarImageView: NSImageView = {
		let view = NSImageView()

		view.image = #imageLiteral(resourceName: "Person Default Image")
		view.imageScaling = NSImageScaling.scaleAxesIndependently
		view.wantsLayer = true
		view.layer!.cornerRadius = 15
		view.layer!.masksToBounds = true

		return view
	}()
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.boldSmall
		field.textColor = Colors.systemText
		field.backgroundColor = .clear

		return field
	}()
	private let textLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regular
		field.backgroundColor = .clear

		return field
	}()
	private let heartLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.backgroundColor = .clear
		field.alignment = .center
		field.font = Fonts.groupMeSymbols
		field.stringValue = "\u{e618}"
		field.textColor = Colors.heart

		return field
	}()
	private let likesCountLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.alignment = .center
		field.backgroundColor = .clear
		field.font = Fonts.likesCount
		field.textColor = Colors.systemText

		return field
	}()

	private func setupInitialLayout() {
		let likesView = NSView()

		likesView.addSubview(likesCountLabel)
		likesView.addSubview(heartLabel)

		heartLabel.translatesAutoresizingMaskIntoConstraints = false
		heartLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
		heartLabel.heightAnchor.constraint(equalTo: heartLabel.widthAnchor).isActive = true
		heartLabel.topAnchor.constraint(equalTo: likesView.topAnchor).isActive = true
		heartLabel.leadingAnchor.constraint(equalTo: likesView.leadingAnchor).isActive = true

		likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
		likesCountLabel.topAnchor.constraint(equalTo: heartLabel.bottomAnchor, constant: -10).isActive = true // top of text is 2 pixels from bottom of heart
		likesCountLabel.heightAnchor.constraint(equalToConstant: likesCountLabel.intrinsicContentSize.height).isActive = true
		likesCountLabel.leadingAnchor.constraint(equalTo: likesView.leadingAnchor).isActive = true
		likesCountLabel.trailingAnchor.constraint(equalTo: likesView.trailingAnchor).isActive = true
		likesCountLabel.centerXAnchor.constraint(equalTo: heartLabel.centerXAnchor).isActive = true

		view.addSubview(avatarImageView)
		view.addSubview(nameLabel)
		view.addSubview(textLabel)
		view.addSubview(likesView)

		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		avatarImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		avatarImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: heartLabel.leadingAnchor, constant: -4).isActive = true

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: heartLabel.leadingAnchor, constant: -4).isActive = true

		likesView.translatesAutoresizingMaskIntoConstraints = false
		likesView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true // constant 5 is best match for text
		likesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		likesView.bottomAnchor.constraint(equalTo: likesCountLabel.bottomAnchor).isActive = true
		likesView.widthAnchor.constraint(equalTo: heartLabel.widthAnchor).isActive = true
	}

	var me: GroupMe.Me! {
		didSet {
			if me.id == message.senderID {
				view.wantsLayer = true
				view.layer!.backgroundColor = Colors.personalBlue
			}
		}
	}
	var message: GMMessage! {
		didSet {
			nameLabel.stringValue = message.name
			if let text = message.text {
				textLabel.stringValue = text
			}
			if message.favoritedBy.count > 0 {
				likesCountLabel.stringValue = "\(message.favoritedBy.count)"
				heartLabel.stringValue = "\u{e60b}"
			}

			HTTP.handleImage(at: message.avatarURL, with: { (image: NSImage) in
				DispatchQueue.main.async {
					self.avatarImageView.image = image
				}
			})
		}
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
	}

}
