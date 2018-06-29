//
//  ViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

	let inputTextField: NSTextField = {
		let textField = NSTextField()

		textField.placeholderString = "Send Message..."

		return textField
	}()
	let convosViewController = ConvosViewController()
	let messagesViewController = MessagesViewController()

	private func setupInitialLayout() {
		let convosView = convosViewController.view

		view.addSubview(convosView)

		convosView.translatesAutoresizingMaskIntoConstraints = false
		convosView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		convosView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		convosView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		convosView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true

		view.addSubview(inputTextField)

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.leadingAnchor.constraint(equalTo: convosView.trailingAnchor, constant: 4).isActive = true
		inputTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true

		let messageView = messagesViewController.view

		view.addSubview(messageView)

		messageView.translatesAutoresizingMaskIntoConstraints = false
		messageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		messageView.leadingAnchor.constraint(equalTo: convosView.trailingAnchor, constant: 4).isActive = true
		messageView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -4).isActive = true
		messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
	}

	override func loadView() {
		self.view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		convosViewController.messagesDelegate = messagesViewController

		setupInitialLayout()
	}
	
}

