//
//  ConvoHeaderView.swift
//  GroupMac
//
//  Created by Will Tyler on 11/24/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


final class ConvoHeaderView: NSView {

	private lazy var groupImageView: NSImageView = {
		let image = NSImageView()

		image.imageScaling = NSImageScaling.scaleAxesIndependently
		image.image = #imageLiteral(resourceName: "Group Default Image")

		return image
	}()
	private lazy var titleLabel: NSTextField = {
		let field = NSTextField(wrappingLabelWithString: "")

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.boldLarge
		field.backgroundColor = .clear

		return field
	}()

	private func setupInitialLayout() {
		removeSubviews()

		addSubview(groupImageView)
		addSubview(titleLabel)

		groupImageView.translatesAutoresizingMaskIntoConstraints = false
		groupImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		groupImageView.widthAnchor.constraint(equalTo: groupImageView.heightAnchor).isActive = true
		groupImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		groupImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 4).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
		titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}

	override func layout() {
		super.layout()

		setupInitialLayout()
	}

	var conversation: GMConversation! {
		didSet {
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
		}
	}

}
