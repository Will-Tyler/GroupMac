//
//  ViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

	private let detailView = NSView()
	private let welcomeLabel: NSTextField = {
		let welcome =
		"""
		You look great today.
		Pop open a chat to start the conversation.
		"""
		let field = NSTextField(wrappingLabelWithString: welcome)

		field.isEditable = false
		field.alignment = .center
		field.font = Fonts.regularLarge
		field.textColor = NSColor(red: 0x3b / 255, green: 0x3b / 255, blue: 0x3b / 255, alpha: 1)

		return field
	}()
	private let convosViewController = ConvosViewController()
	private let messagesViewController = MessagesViewController()

	private func setupInitialLayout() {
		addChildViewController(convosViewController)
		
		let convosView = convosViewController.view

		view.addSubview(convosView)
		detailView.addSubview(welcomeLabel)
		view.addSubview(detailView)

		convosView.translatesAutoresizingMaskIntoConstraints = false
		convosView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		convosView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		convosView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		convosView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true

		detailView.translatesAutoresizingMaskIntoConstraints = false
		detailView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		detailView.leadingAnchor.constraint(equalTo: convosView.trailingAnchor, constant: 4).isActive = true
		detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true

		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.heightAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.height).isActive = true
		welcomeLabel.widthAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.width).isActive = true
		welcomeLabel.centerXAnchor.constraint(equalTo: detailView.centerXAnchor).isActive = true
		welcomeLabel.centerYAnchor.constraint(equalTo: detailView.centerYAnchor).isActive = true
	}

	override func loadView() {
		self.view = NSView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		convosViewController.messagesDelegate = messagesViewController
		convosViewController.viewDelegate = self

		setupInitialLayout()
	}

	func hasSelectedConversation() {
		addChildViewController(messagesViewController)

		let conversationView = messagesViewController.view

		detailView.addSubview(conversationView)

		conversationView.translatesAutoresizingMaskIntoConstraints = false
		conversationView.topAnchor.constraint(equalTo: detailView.topAnchor).isActive = true
		conversationView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
		conversationView.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
		conversationView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
	}
	
}

