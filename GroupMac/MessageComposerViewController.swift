//
// Created by Will Tyler on 8/18/18.
// Copyright (c) 2018 Will Tyler. All rights reserved.
//

import AppKit


final class MessageComposerViewController: NSViewController {

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
		view.removeSubviews()

		view.addSubview(inputTextField)
		view.addSubview(sendButton)

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
		inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		inputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true

		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor).isActive = true
		sendButton.widthAnchor.constraint(equalToConstant: sendButton.intrinsicContentSize.width).isActive = true
		sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.backColor = .white
			view.wantsLayer = true
			view.layer!.borderWidth = 1
			view.layer!.borderColor = Colors.border

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}

	var conversation: GMConversation!

	@objc private func sendButtonAction(sender: NSButton) {
		conversation.sendMessage(text: inputTextField.stringValue, successHandler: {
			DispatchQueue.main.async {
				self.inputTextField.stringValue = ""
			}
		})
	}

}
