//
//  ConvoViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class ConvoViewController: NSViewController {

	private let convoHeaderViewController = ConvoHeaderViewController()
	private let messagesViewController = MessagesViewController()
	private let messageComposerController = MessageComposerViewController()

	private func setupInitialLayout() {
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
		headerView.heightAnchor.constraint(equalToConstant: 30 + 8).isActive = true

		messagesView.translatesAutoresizingMaskIntoConstraints = false
		messagesView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -1).isActive = true // overlap borders
		messagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		messagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		messagesView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 1).isActive = true // overlap borders

		composerView.translatesAutoresizingMaskIntoConstraints = false
		composerView.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
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

	var conversation: GMConversation! {
		didSet {
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
