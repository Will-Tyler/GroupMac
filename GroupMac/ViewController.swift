//
//  ViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

	private let mainView = NSView()
	private let welcomeLabel: NSTextField = {
		let welcome =
		"""
		You look great today.
		Pop open a chat to start the conversation.
		"""
		let field = NSTextField(wrappingLabelWithString: welcome)

		field.isEditable = false
		field.alignment = .center
		field.font = Fonts.large
		field.textColor = NSColor(red: 0x3b / 255, green: 0x3b / 255, blue: 0x3b / 255, alpha: 1)

		return field
	}()
	private let inputTextField: NSTextField = {
		let field = NSTextField()

		field.font = NSFont(name: "Segoe UI", size: NSFont.systemFontSize(for: .regular))
		field.placeholderString = "Send Message..."

		return field
	}()
	private let convosViewController = ConvosViewController()
	private let messagesViewController = MessagesViewController()

	private func setupInitialLayout() {
		let convosView = convosViewController.view

		view.addSubview(convosView)

		convosView.translatesAutoresizingMaskIntoConstraints = false
		convosView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		convosView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		convosView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		convosView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true

		view.addSubview(mainView)

		mainView.translatesAutoresizingMaskIntoConstraints = false
		mainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		mainView.leadingAnchor.constraint(equalTo: convosView.trailingAnchor).isActive = true
		mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		mainView.addSubview(welcomeLabel)

		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.heightAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.height).isActive = true
		welcomeLabel.widthAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.width).isActive = true
		welcomeLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
		welcomeLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
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
		mainView.subviews.forEach({ $0.removeFromSuperview() })

		mainView.addSubview(inputTextField)

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 4).isActive = true
		inputTextField.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -4).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -4).isActive = true
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true

		let messageView = messagesViewController.view

		mainView.addSubview(messageView)

		messageView.translatesAutoresizingMaskIntoConstraints = false
		messageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 4).isActive = true
		messageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 4).isActive = true
		messageView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -4).isActive = true
		messageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -4).isActive = true
	}
	
}

