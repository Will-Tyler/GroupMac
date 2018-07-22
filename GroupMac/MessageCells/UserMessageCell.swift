//
//  UserMessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/4/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class UserMessageCell: MessageCell {

	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")
	
	private let nameLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.font = Fonts.boldSmall
		field.textColor = Colors.systemText
		field.backgroundColor = .clear

		return field
	}()
	private let attachmentView: NSView = {
		let view = NSView()

		view.backColor = .white
		view.wantsLayer = true
		view.layer!.borderColor = Colors.border
		view.layer!.borderWidth = 1
//		view.layer!.cornerRadius = 3
		view.layer!.masksToBounds = true

		return view
	}()

	private func setupInitialLayout() {
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false

		textLabelTopAnchorConstraint.isActive = false
		textLabel.removeConstraint(textLabelTopAnchorConstraint)
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true

		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
	}

	private var runningImageTasks = Set<URLSessionDataTask>()
	override var message: GMMessage! {
		didSet {
			nameLabel.stringValue = message.name

			if AppDelegate.me.id == message.senderID {
				view.backColor = Colors.personalBlue
			}
			else {
				view.backColor = Colors.background
			}

			if let url = message.avatarURL {
				let runningTask = HTTP.handleImage(at: url, with: { (image: NSImage) in
					DispatchQueue.main.async {
						self.avatarImageView.image = image
					}
				})
				runningImageTasks.insert(runningTask)
			}

			// Reset attachment view
			attachmentView.removeSubviews()
			attachmentView.isHidden = true
//			if let attachment = message.attachments.first { // only one attachment is supported at this moment
//				switch attachment.contentType {
//				case .image:
//					let image = attachment.content! as! GroupMe.Attachment.Image
//
//					addImage(from: image.url)
//
//				default: addUnsupportedAttachmentMessage(contentType: attachment.contentType)
//				}
//			}
		}
	}

	func cancelRunningImageTasks() {
		runningImageTasks.forEach({ $0.cancel() })
	}
	private func addImage(from url: URL) {
		print(url)

		let task = HTTP.handleImage(at: url) { (image) in
			DispatchQueue.main.async {
				let imageView: NSImageView = {
					let imageView = NSImageView()

					imageView.imageScaling = .scaleProportionallyUpOrDown
					imageView.image = image

					return imageView
				}()
				let imageSize = image.size

				self.attachmentView.addSubview(imageView)

				imageView.translatesAutoresizingMaskIntoConstraints = false
				imageView.topAnchor.constraint(equalTo: self.attachmentView.topAnchor, constant: 4).isActive = true
				imageView.leadingAnchor.constraint(equalTo: self.attachmentView.leadingAnchor, constant: 4).isActive = true
				imageView.bottomAnchor.constraint(equalTo: self.attachmentView.bottomAnchor, constant: -4).isActive = true
				imageView.trailingAnchor.constraint(equalTo: self.attachmentView.trailingAnchor, constant: -4).isActive = true

				self.attachmentView.translatesAutoresizingMaskIntoConstraints = false
				self.attachmentView.topAnchor.constraint(equalTo: self.textLabel.stringValue.isEmpty ? self.nameLabel.bottomAnchor : self.textLabel.bottomAnchor).isActive = true
				self.attachmentView.leadingAnchor.constraint(equalTo: self.textLabel.leadingAnchor).isActive = true
				self.attachmentView.trailingAnchor.constraint(lessThanOrEqualTo: self.textLabel.trailingAnchor).isActive = true
				let aspectRatio = imageSize.height / imageSize.width
				self.attachmentView.heightAnchor.constraint(equalTo: self.attachmentView.widthAnchor, multiplier: aspectRatio).isActive = true

				self.attachmentView.isHidden = false
			}
		}
		runningImageTasks.insert(task)
	}
	private func addUnsupportedAttachmentMessage(contentType: GroupMe.Attachment.ContentType) {
//		let unsupportedLabel: NSTextField = {
//			let field = NSTextField()
//
//			field.stringValue = "Attachments of type '\(contentType.rawValue)' are currently not supported."
//			field.isEditable = false
//			field.isBezeled = false
//			field.font = Fonts.regularLarge
//
//			return field
//		}()
//
//		attachmentView.addSubview(unsupportedLabel)
//
//		unsupportedLabel.translatesAutoresizingMaskIntoConstraints = false
//
//		unsupportedLabel.heightAnchor.constraint(equalToConstant: unsupportedLabel.intrinsicContentSize.height).isActive = true
//
//		unsupportedLabel.topAnchor.constraint(equalTo: attachmentView.topAnchor, constant: 4).isActive = true
//		unsupportedLabel.leadingAnchor.constraint(equalTo: attachmentView.leadingAnchor, constant: 4).isActive = true
//		unsupportedLabel.bottomAnchor.constraint(equalTo: attachmentView.bottomAnchor, constant: -4).isActive = true
//		unsupportedLabel.trailingAnchor.constraint(equalTo: attachmentView.trailingAnchor, constant: -4).isActive = true
//
//		attachmentView.topAnchor.constraint(equalTo: textLabel.stringValue.isEmpty ? nameLabel.bottomAnchor : textLabel.bottomAnchor).isActive = true
//		attachmentView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
//		attachmentView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
//
//		attachmentView.isHidden = false
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.backColor = Colors.background

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()
	}

}































































