//
//  ConvoViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class ConvoViewController: NSViewController {

	private let containerView: NSView = {
		let view = NSView()

		view.wantsLayer = true // leave on to prevent glitching when collection view is smaller than container

		return view
	}()
	private let titleView: NSView = {
		let view = NSView()

		view.wantsLayer = true
		view.layer!.backgroundColor = .white
		view.layer!.borderWidth = 1
		view.layer!.borderColor = Colors.border

		return view
	}()
	private let titleLabel: NSTextField = {
		let field = NSTextField(wrappingLabelWithString: "")

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.boldLarge
		field.textColor = Colors.title
		field.backgroundColor = .clear

		return field
	}()
	private let groupImageView: NSImageView = {
		let image = NSImageView()

		image.imageScaling = NSImageScaling.scaleAxesIndependently
		image.image = #imageLiteral(resourceName: "Group Default Image")

		return image
	}()
	private let messagesViewController = MessagesViewController()
	private let inputTextField: NSTextField = {
		let field = NSTextField()

		field.font = Fonts.regular
		field.placeholderString = "Send Message..."
		field.isBezeled = false
		field.backgroundColor = .clear
		field.focusRingType = NSFocusRingType.none

		return field
	}()
	private let sendButton: CursorButton = {
		let button = CursorButton(title: "", target: self, action: #selector(sendButtonAction(sender:)))

		button.attributedTitle = NSAttributedString(string: "Send", attributes: [.font: Fonts.bold, .foregroundColor: Colors.systemText])
		button.font = Fonts.bold
		button.isBordered = false
		button.cursor = NSCursor.pointingHand

		return button
	}()

	private func setupInitialLayout() {
		let inputView: NSView = {
			let view = NSView()

			view.backColor = .white
			view.wantsLayer = true
			view.layer!.borderWidth = 1
			view.layer!.borderColor = Colors.border

			return view
		}()

		inputView.addSubview(inputTextField)
		inputView.addSubview(sendButton)

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
		inputTextField.leadingAnchor.constraint(equalTo: inputView.leadingAnchor, constant: 4).isActive = true
		inputTextField.centerYAnchor.constraint(equalTo: inputView.centerYAnchor).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true

		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor).isActive = true
		sendButton.widthAnchor.constraint(equalToConstant: sendButton.intrinsicContentSize.width).isActive = true
		sendButton.trailingAnchor.constraint(equalTo: inputView.trailingAnchor, constant: -4).isActive = true
		sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true

		titleView.addSubview(groupImageView)
		titleView.addSubview(titleLabel)

		let messagesView = messagesViewController.view

		containerView.addSubview(titleView)
		containerView.addSubview(inputView)
		containerView.addSubview(messagesView)

		groupImageView.translatesAutoresizingMaskIntoConstraints = false
		groupImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		groupImageView.heightAnchor.constraint(equalTo: groupImageView.widthAnchor).isActive = true
		groupImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
		groupImageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 4).isActive = true
		groupImageView.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 4).isActive = true
		groupImageView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -4).isActive = true

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 4).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -4).isActive = true
		titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

		titleView.translatesAutoresizingMaskIntoConstraints = false
		titleView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		titleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		titleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		titleView.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height + 8).isActive = true

		messagesView.translatesAutoresizingMaskIntoConstraints = false
		messagesView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -1).isActive = true // overlap borders
		messagesView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		messagesView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		messagesView.bottomAnchor.constraint(equalTo: inputView.topAnchor, constant: 1).isActive = true // overlap borders

		inputView.translatesAutoresizingMaskIntoConstraints = false
		inputView.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
		inputView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		inputView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		inputView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
	}

	@objc private func sendButtonAction(sender: NSButton) {
		if conversation.convoType == .group {
			let group = conversation as! GroupMe.Group

			group.sendMessage(text: inputTextField.stringValue) {
				DispatchQueue.main.async {
					self.inputTextField.stringValue = ""
					self.messages = self.conversation.blandMessages
				}
			}
		}
		else {
			let chat = conversation as! GroupMe.Chat

			chat.sendMessage(text: inputTextField.stringValue) {
				DispatchQueue.main.async {
					self.inputTextField.stringValue = ""
					self.messages = self.conversation.blandMessages
				}
			}
		}
	}

	var conversation: GMConversation! {
		didSet {
			messages = conversation.blandMessages
			titleLabel.stringValue = conversation.name

			groupImageView.image = #imageLiteral(resourceName: "Group Default Image")
			if let url = conversation.imageURL {
				HTTP.handleImage(at: url, with: { (image: NSImage) in
					DispatchQueue.main.async {
						self.groupImageView.image = image
					}
				})
			}

			if self.conversation.convoType == .chat {
				self.groupImageView.wantsLayer = true
				self.groupImageView.layer!.cornerRadius = self.groupImageView.bounds.width / 2
				self.groupImageView.layer!.masksToBounds = true
			}
			else {
				groupImageView.wantsLayer = true
				groupImageView.layer!.cornerRadius = 0
				groupImageView.layer!.masksToBounds = false
			}

			messagesViewController.scrollTranscriptToBottom()
		}
	}
	private var messages: [GMMessage]? {
		get {
			return messagesViewController.messages
		}
		set {
			messagesViewController.messages = newValue
		}
	}

	override func loadView() {
		view = containerView
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}

}
