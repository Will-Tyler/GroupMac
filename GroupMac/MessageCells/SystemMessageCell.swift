//
//  SystemMessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/4/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class SystemMessageCell: MessageCell {

	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "SystemMessageCell")

	private let systemImageView: NSImageView = {
		let view = NSImageView(image: #imageLiteral(resourceName: "System Default Image"))

		view.imageScaling = .scaleAxesIndependently

		return view
	}()
	private let textLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.backgroundColor = .clear
		field.font = Fonts.regularSmall
		field.textColor = Colors.systemText

		return field
	}()

	private func setupInitialLayout() {
		view.addSubview(systemImageView)
		view.addSubview(textLabel)

		systemImageView.translatesAutoresizingMaskIntoConstraints = false
		systemImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		systemImageView.heightAnchor.constraint(equalTo: systemImageView.widthAnchor).isActive = true
		systemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		systemImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.heightAnchor.constraint(equalToConstant: textLabel.intrinsicContentSize.height).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: systemImageView.trailingAnchor, constant: 4).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

	var message: GMMessage! {
		didSet {
			if let text = message.text {
				textLabel.stringValue = text
			}
		}
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.backColor = Colors.systemBackground

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}
	
}
