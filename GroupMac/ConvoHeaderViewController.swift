//
// Created by Will Tyler on 8/20/18.
// Copyright (c) 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class ConvoHeaderViewController: NSViewController {

	private let titleLabel: NSTextField = {
		let field = NSTextField(wrappingLabelWithString: "")

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.boldLarge
		field.textColor = Colors.title
		field.backgroundColor = .clear

		return field
	}()
	private let groupImageView: NSImageView = {
		let image = NSImageView()

		image.imageScaling = NSImageScaling.scaleAxesIndependently
		image.image = #imageLiteral(resourceName: "Group Default Image")

		return image
	}()

	private func setupInitialLayout() {
		view.addSubview(groupImageView)
		view.addSubview(titleLabel)

		groupImageView.translatesAutoresizingMaskIntoConstraints = false
		groupImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		groupImageView.heightAnchor.constraint(equalTo: groupImageView.widthAnchor).isActive = true
		groupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		groupImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		groupImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		groupImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 4).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer!.backgroundColor = .white
			view.layer!.borderWidth = 1
			view.layer!.borderColor = Colors.border

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

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
