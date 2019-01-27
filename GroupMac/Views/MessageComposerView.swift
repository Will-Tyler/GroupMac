//
//  MessageComposerView.swift
//  GroupMac
//
//  Created by Will Tyler on 11/24/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


final class MessageComposerView: NSView {

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)

		setupInitialLayout()
	}
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private lazy var inputTextField: NSTextField = {
		let field = NSTextField()

		field.font = Fonts.regular
		field.placeholderString = "Send Message..."
		field.isBezeled = false
		field.backgroundColor = .clear
		field.focusRingType = NSFocusRingType.none

		return field
	}()
	private lazy var sendButton: CursorButton = {
		let button = CursorButton(title: "", target: self, action: #selector(sendButtonAction(sender:)))

		button.attributedTitle = NSAttributedString(string: "Send", attributes: [.font: Fonts.bold, .foregroundColor: Colors.systemText])
		button.font = Fonts.bold
		button.isBordered = false
		button.cursor = NSCursor.pointingHand

		return button
	}()

	private func setupInitialLayout() {
		removeSubviews()
		
		addSubview(inputTextField)
		addSubview(sendButton)

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
		inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
		inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true

		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor).isActive = true
		sendButton.widthAnchor.constraint(equalToConstant: sendButton.intrinsicContentSize.width).isActive = true
		sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
		sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
	}

	var conversation: GMConversation!

	@objc
	private func sendButtonAction(sender: NSButton) {
		conversation.sendMessage(text: inputTextField.stringValue, successHandler: {
			DispatchQueue.main.async {
				self.inputTextField.stringValue = ""
			}
		})
	}

}
