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
	private let messageComposerController = MessageComposerViewController()

	private func setupInitialLayout() {
		titleView.addSubview(groupImageView)
		titleView.addSubview(titleLabel)

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

		let messagesView = messagesViewController.view
		let composerView = messageComposerController.view

		containerView.addSubview(titleView)
		containerView.addSubview(messagesView)
		containerView.addSubview(composerView)

		titleView.translatesAutoresizingMaskIntoConstraints = false
		titleView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		titleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		titleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		titleView.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height + 8).isActive = true

		messagesView.translatesAutoresizingMaskIntoConstraints = false
		messagesView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -1).isActive = true // overlap borders
		messagesView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		messagesView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		messagesView.bottomAnchor.constraint(equalTo: composerView.topAnchor, constant: 1).isActive = true // overlap borders

		composerView.translatesAutoresizingMaskIntoConstraints = false
		composerView.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
		composerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		composerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		composerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
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
