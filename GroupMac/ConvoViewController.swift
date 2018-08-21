//
//  ConvoViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class ConvoViewController: NSViewController {

	private let welcomeLabel: NSTextField = {
		let firstName = AppDelegate.me.name.split(separator: " ").first!
		let welcome =
				"""
				You look great today, \(firstName).
				Pop open a chat to start the conversation.
				"""
		let field = NSTextField(wrappingLabelWithString: welcome)

		field.isEditable = false
		field.alignment = .center
		field.font = Fonts.regularLarge
		field.textColor = NSColor(red: 0x3b / 255, green: 0x3b / 255, blue: 0x3b / 255, alpha: 1)

		return field
	}()
	private let convoHeaderViewController = ConvoHeaderViewController()
	private let messagesViewController = MessagesViewController()
	private let messageComposerController = MessageComposerViewController()

	private func setupInitialLayout() {
		view.addSubview(welcomeLabel)

		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.heightAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.height).isActive = true
		welcomeLabel.widthAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.width).isActive = true
		welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
	private func setupDetailLayout() {
		welcomeLabel.removeFromSuperview()

		let headerView = convoHeaderViewController.view
		let messagesView = messagesViewController.view
		let composerView = messageComposerController.view

		view.addSubview(headerView)
		view.addSubview(messagesView)
		view.addSubview(composerView)

		headerView.translatesAutoresizingMaskIntoConstraints = false
		headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		headerView.heightAnchor.constraint(equalToConstant: 38).isActive = true

		messagesView.translatesAutoresizingMaskIntoConstraints = false
		messagesView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -1).isActive = true // overlap borders
		messagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		messagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		messagesView.bottomAnchor.constraint(equalTo: composerView.topAnchor, constant: 1).isActive = true // overlap borders

		composerView.translatesAutoresizingMaskIntoConstraints = false
		composerView.heightAnchor.constraint(equalToConstant: 38).isActive = true
		composerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		composerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		composerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		addChildViewController(convoHeaderViewController)
		addChildViewController(messagesViewController)
		addChildViewController(messageComposerController)

		setupInitialLayout()
	}

	private var hasSelectedConvo: Bool = false
	var conversation: GMConversation! {
		didSet {
			if !hasSelectedConvo {
				setupDetailLayout()
				hasSelectedConvo = true
			}

			messages = conversation.blandMessages
			convoHeaderViewController.conversation = conversation

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

}
