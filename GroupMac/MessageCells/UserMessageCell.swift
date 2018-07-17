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
	let heartButton: HeartButton = {
		let button = HeartButton()

		button.heart = Hearts.outline
		button.alignment = .center
		button.cursor = NSCursor.pointingHand
		button.isBordered = false

		return button
	}()
	private let likesCountLabel: NSTextField = {
		let field = NSTextField()

		field.isEditable = false
		field.isBezeled = false
		field.alignment = .center
		field.backgroundColor = .clear
		field.font = Fonts.likesCount
		field.textColor = Colors.systemText

		return field
	}()
	private let attachmentView: NSView = {
		let view = NSView()

		view.backColor = .white
		view.wantsLayer = true
		view.layer!.borderColor = Colors.border
		view.layer!.borderWidth = 1
		view.layer!.cornerRadius = 3
		view.layer!.masksToBounds = true

		return view
	}()

	private func setupInitialLayout() {
		let likesView = NSView()

		likesView.addSubview(likesCountLabel)
		likesView.addSubview(heartButton)

		heartButton.translatesAutoresizingMaskIntoConstraints = false
		heartButton.widthAnchor.constraint(equalToConstant: heartButton.intrinsicContentSize.width).isActive = true
		heartButton.heightAnchor.constraint(equalTo: heartButton.widthAnchor).isActive = true
		heartButton.topAnchor.constraint(equalTo: likesView.topAnchor).isActive = true
		heartButton.centerXAnchor.constraint(equalTo: likesView.centerXAnchor).isActive = true

		likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
		likesCountLabel.topAnchor.constraint(equalTo: heartButton.bottomAnchor, constant: -5).isActive = true // top of text is 2 pixels from bottom of heart button
		likesCountLabel.heightAnchor.constraint(equalToConstant: likesCountLabel.intrinsicContentSize.height).isActive = true
		likesCountLabel.leadingAnchor.constraint(equalTo: likesView.leadingAnchor).isActive = true
		likesCountLabel.trailingAnchor.constraint(equalTo: likesView.trailingAnchor).isActive = true
		likesCountLabel.centerXAnchor.constraint(equalTo: heartButton.centerXAnchor).isActive = true

		view.addSubview(avatarImageView)
		view.addSubview(nameLabel)
		view.addSubview(textLabel)
		view.addSubview(likesView)

		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		avatarImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		avatarImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -4).isActive = true

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -4).isActive = true

		likesView.translatesAutoresizingMaskIntoConstraints = false
		likesView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true // constant 5 is best match for text
		likesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		likesView.bottomAnchor.constraint(equalTo: likesCountLabel.bottomAnchor).isActive = true
		likesView.widthAnchor.constraint(equalTo: heartButton.widthAnchor).isActive = true
	}

	func toggleLike() {
		let myID = ViewController.me.id
		let isLiked = likes.contains(myID)
		if isLiked {
			message.unlike {
				self.likes = self.likes.filter({ $0 != ViewController.me.id })
				if self.message.favoritedBy.count > 1 {
					DispatchQueue.main.async {
						self.heartButton.heart = Hearts.grey
						self.likesCountLabel.stringValue = "\(self.likes.count)"
					}
				}
				else {
					DispatchQueue.main.async {
						self.heartButton.heart = Hearts.outline
						self.likesCountLabel.stringValue = ""
					}
				}
			}
		}
		else {
			message.like {
				self.likes.append(ViewController.me.id)
				DispatchQueue.main.async {
					self.heartButton.heart = Hearts.red
					self.likesCountLabel.stringValue = "\(self.likes.count)"
				}
			}
		}
	}
	func cancelRunningImageTasks() {
		runningImageTasks.forEach({ $0.cancel() })
	}
	private func addImage(from url: URL) {
		let imageSize = GroupMe.imageSize(from: url)

		print(url)

		view.addSubview(attachmentView)

		attachmentView.translatesAutoresizingMaskIntoConstraints = false
		attachmentView.topAnchor.constraint(equalTo: textLabel.stringValue.isEmpty ? nameLabel.bottomAnchor : textLabel.bottomAnchor).isActive = true
		attachmentView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
		attachmentView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true
		attachmentView.widthAnchor.constraint(lessThanOrEqualToConstant: imageSize.width).isActive = true
		let aspectRatio = imageSize.height / imageSize.width
		attachmentView.heightAnchor.constraint(equalTo: attachmentView.widthAnchor, multiplier: aspectRatio).isActive = true

		let task = HTTP.handleImage(at: url) { (image) in
			DispatchQueue.main.async {
				let imageView: NSImageView = {
					let imageView = NSImageView()

					imageView.imageScaling = .scaleProportionallyUpOrDown
					imageView.image = image

					return imageView
				}()

				self.attachmentView.addSubview(imageView)

				imageView.translatesAutoresizingMaskIntoConstraints = false
				imageView.topAnchor.constraint(equalTo: self.attachmentView.topAnchor, constant: 4).isActive = true
				imageView.leadingAnchor.constraint(equalTo: self.attachmentView.leadingAnchor, constant: 4).isActive = true
				imageView.bottomAnchor.constraint(equalTo: self.attachmentView.bottomAnchor, constant: -4).isActive = true
				imageView.trailingAnchor.constraint(equalTo: self.attachmentView.trailingAnchor, constant: -4).isActive = true
			}
		}
		runningImageTasks.insert(task)
	}

	private var likes: [String]!
	private var runningImageTasks = Set<URLSessionDataTask>()
	var message: GMMessage! {
		didSet {
			nameLabel.stringValue = message.name

			likes = message.favoritedBy

			textLabel.stringValue = message.text ?? ""

			// Reset attachment view
			if view.subviews.contains(attachmentView) {
				attachmentView.removeSubviews()
				attachmentView.removeFromSuperview()
			}

			if message.favoritedBy.count > 0 {
				likesCountLabel.stringValue = "\(message.favoritedBy.count)"
				if message.favoritedBy.contains(ViewController.me.id) {
					heartButton.heart = Hearts.red
				}
				else {
					heartButton.heart = Hearts.grey
				}
			}
			else {
				likesCountLabel.stringValue = ""
				heartButton.heart = Hearts.outline
			}

			if ViewController.me.id == message.senderID {
				view.backColor = Colors.personalBlue
			}
			else {
				view.backColor = Colors.background
			}

			avatarImageView.image = #imageLiteral(resourceName: "Person Default Image")
			if let url = message.avatarURL {
				let runningTask = HTTP.handleImage(at: url, with: { (image: NSImage) in
					DispatchQueue.main.async {
						self.avatarImageView.image = image
					}
				})
				runningImageTasks.insert(runningTask)
			}

			message.attachments.forEach({ (attachment) in
				if attachment.contentType == .image {
					let image = attachment.content! as! GroupMe.Attachment.Image
					addImage(from: image.url)
				}
			})
		}
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































































