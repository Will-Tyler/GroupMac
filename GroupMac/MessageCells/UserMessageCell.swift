//
//  UserMessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/4/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class UserMessageCell: NSCollectionViewItem {

	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")

	private let avatarImageView: NSImageView = {
		let view = NSImageView()

		view.image = #imageLiteral(resourceName: "Person Default Image")
		view.imageScaling = NSImageScaling.scaleAxesIndependently
		view.wantsLayer = true
		view.layer!.cornerRadius = 15
		view.layer!.masksToBounds = true

		return view
	}()
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.boldSmall
		field.textColor = Colors.systemText
		field.backgroundColor = .clear

		return field
	}()
	private let textLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.regular
		field.backgroundColor = .clear

		return field
	}()

	private func setupInitialLayout() {
		view.addSubview(avatarImageView)

		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		avatarImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		avatarImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true

		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		view.addSubview(textLabel)

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	var message: GMMessage! {
		didSet {
			nameLabel.stringValue = message.name
			if let text = message.text {
				textLabel.stringValue = text
			}

			HTTP.handleImage(at: message.avatarURL, with: { (image: NSImage) in
				DispatchQueue.main.async {
					self.avatarImageView.image = image
				}
			})
		}
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer!.backgroundColor = Colors.background

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}

}
