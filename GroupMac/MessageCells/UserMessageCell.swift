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
	let heartButton: CustomCursorButton = {
		let button = CustomCursorButton()

		button.attributedTitle = NSAttributedString(string: "\u{e618}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartGrey])
		button.alignment = .center
		button.cursor = NSCursor.pointingHand
		button.isBordered = false

		return button
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
		likesView.addSubview(heartButton)

		heartButton.translatesAutoresizingMaskIntoConstraints = false
		heartButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
		heartButton.heightAnchor.constraint(equalTo: heartButton.widthAnchor).isActive = true
		heartButton.topAnchor.constraint(equalTo: likesView.topAnchor).isActive = true
		heartButton.leadingAnchor.constraint(equalTo: likesView.leadingAnchor).isActive = true

		likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
		likesCountLabel.topAnchor.constraint(equalTo: heartButton.bottomAnchor, constant: -10).isActive = true // top of text is 2 pixels from bottom of heart
		likesCountLabel.heightAnchor.constraint(equalToConstant: likesCountLabel.intrinsicContentSize.height).isActive = true
		likesCountLabel.leadingAnchor.constraint(equalTo: likesView.leadingAnchor).isActive = true
		likesCountLabel.trailingAnchor.constraint(equalTo: likesView.trailingAnchor).isActive = true
		likesCountLabel.centerXAnchor.constraint(equalTo: heartButton.centerXAnchor).isActive = true

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
		nameLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -4).isActive = true

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -4).isActive = true

		likesView.translatesAutoresizingMaskIntoConstraints = false
		likesView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true // constant 5 is best match for text
		likesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		likesView.bottomAnchor.constraint(equalTo: likesCountLabel.bottomAnchor).isActive = true
		likesView.widthAnchor.constraint(equalTo: heartButton.widthAnchor).isActive = true
	}

	func toggleLike() {
		let likes = message.favoritedBy
		let myID = MessagesViewController.me.id
		let isLiked = (heartButton.attributedTitle.attribute(.foregroundColor, at: 0, effectiveRange: nil) as! NSColor) == Colors.heartRed
		if isLiked {
			message.unlike {
				if self.message.favoritedBy.count > 1 {
					DispatchQueue.main.async {
						self.heartButton.attributedTitle = NSAttributedString(string: "\u{e60b}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartGrey]) // filled heart
						self.likesCountLabel.stringValue = "\(likes.contains(myID) ? likes.count-1 : likes.count)"
					}
				}
				else {
					DispatchQueue.main.async {
						self.heartButton.attributedTitle = NSAttributedString(string: "\u{e618}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartGrey])
						self.likesCountLabel.stringValue = ""
					}
				}
			}
		}
		else {
			message.like {
				DispatchQueue.main.async {
					self.heartButton.attributedTitle = NSAttributedString(string: "\u{e60b}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartRed])
					self.likesCountLabel.stringValue = "\(likes.contains(myID) ? likes.count : likes.count+1)"
				}
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
				if message.favoritedBy.contains(MessagesViewController.me.id) {
					heartButton.attributedTitle = NSAttributedString(string: "\u{e60b}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartRed])
				}
				else {
					heartButton.attributedTitle = NSAttributedString(string: "\u{e60b}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartGrey]) // filled heart
				}
			}
			else {
				likesCountLabel.stringValue = ""
				heartButton.attributedTitle = NSAttributedString(string: "\u{e618}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartGrey])
			}

			if MessagesViewController.me.id == message.senderID {
				view.backColor = Colors.personalBlue
			}
			else {
				view.backColor = Colors.background
			}

			avatarImageView.image = #imageLiteral(resourceName: "Person Default Image")
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

			view.backColor = Colors.background

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}

}
