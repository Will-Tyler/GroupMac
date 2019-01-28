//
//  MessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/19/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


class MessageCell: NSCollectionViewItem {

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
		field.backgroundColor = .clear
		field.font = Fonts.regular

		return field
	}()
	private let heartButton: HeartButton = {
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

		return view
	}()

	private func setupInitialLayout() {
		view.removeSubviews()

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
		likesCountLabel.centerXAnchor.constraint(equalTo: likesView.centerXAnchor).isActive = true

		view.addSubview(avatarImageView)
		view.addSubview(likesView)
		view.addSubview(nameLabel)
		view.addSubview(textLabel)

		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		avatarImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
		nameLabelHeightContraint = nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height)
		nameLabelHeightContraint.isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor).isActive = true

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4).isActive = true
		textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -4).isActive = true

		likesView.translatesAutoresizingMaskIntoConstraints = false
		likesView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true // constant 5 is best match for text
		likesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		likesView.widthAnchor.constraint(equalTo: heartButton.widthAnchor).isActive = true
		likesView.bottomAnchor.constraint(equalTo: likesCountLabel.bottomAnchor).isActive = true
	}

	override func loadView() {
		view = NSView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		setupInitialLayout()

		heartButton.target = self
		heartButton.action = #selector(toggleLike)
	}

	static let cellID = NSUserInterfaceItemIdentifier(rawValue: "MessageCell")

	private let systemDefaultImage = NSImage(named: "System Default Image")
	private let personDefaultImage = NSImage(named: "Person Default Image")
	private var runningImageTasks: Set<URLSessionDataTask> = []

	private func cancelRunningImageTasks() {
		runningImageTasks.forEach({ $0.cancel() })
		runningImageTasks.removeAll()
	}

	private var nameLabelHeightContraint: NSLayoutConstraint!
	private var likes: Set<String>!
	var message: GMMessage! {
		didSet {
			cancelRunningImageTasks()

			if message.isSystem {
				nameLabelHeightContraint.constant = 0

				avatarImageView.image = systemDefaultImage

				textLabel.font = Fonts.regularSmall
				textLabel.textColor = Colors.systemText

				view.backColor = Colors.systemBackground
			}
			else {
				avatarImageView.image = personDefaultImage

				view.backColor = .clear

				if let url = message.avatarURL {
					let imageTask = HTTP.handleImage(at: url, with: { (image: NSImage) in
						DispatchQueue.main.async {
							self.avatarImageView.image = image
						}
					})

					runningImageTasks.insert(imageTask)
				}
//
//				// Reset attachment view
//				attachmentView.removeSubviews()
//				attachmentView.isHidden = true
//				if let attachment = message.attachments.first { // only one attachment is supported at this moment
//					attachmentView.isHidden = false
//					switch attachment.contentType {
//					case .image:
//						let image = attachment.content! as! GroupMe.Attachment.Image
//
//						addImage(from: image.url)
//
//					case .mentions:
//						attachmentView.isHidden = true
//
//						let mutableString = NSMutableAttributedString(string: message.text!)
//						let mentions = attachment.content as! GroupMe.Attachment.Mentions
//
//						for location in mentions.loci {
//							let range = NSRange.init(location: location.first!, length: location.last!)
//
//							mutableString.addAttribute(.font, value: Fonts.bold, range: range)
//						}
//
//						textLabel.stringValue = ""
//						textLabel.attributedStringValue = mutableString
//
//					default:
//						addUnsupportedAttachmentMessage(contentType: attachment.contentType)
//					}
//				}
			}

			likes = Set<String>(message.favoritedBy)
			textLabel.stringValue = message.text ?? ""
			nameLabel.stringValue = message.name

			if message.favoritedBy.count > 0 {
				likesCountLabel.stringValue = "\(message.favoritedBy.count)"

				if message.favoritedBy.contains(GroupMe.me.id) {
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
		}
	}

	@objc
	private func toggleLike() {
		let myID = GroupMe.me.id
		let isLikedByMe = likes.contains(myID)

		if isLikedByMe {
			message.unlike {
				self.likes = self.likes.filter({ $0 != GroupMe.me.id })

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
				self.likes.insert(GroupMe.me.id)

				DispatchQueue.main.async {
					self.heartButton.heart = Hearts.red
					self.likesCountLabel.stringValue = "\(self.likes.count)"
				}
			}
		}
	}
	//	func cancelRunningImageTasks() {
	//		runningImageTasks.forEach({ $0.cancel() })
	//	}
	//	private func addImage(from url: URL) {
	//		print(url)
	//
	//		let task = HTTP.handleImage(at: url) { (image) in
	//			DispatchQueue.main.async {
	//				let imageView: NSImageView = {
	//					let imageView = NSImageView()
	//
	//					imageView.imageScaling = .scaleProportionallyUpOrDown
	//					imageView.image = image
	//
	//					return imageView
	//				}()
	////				let imageSize = image.size
	//
	//				self.attachmentView.addSubview(imageView)
	//
	//				imageView.translatesAutoresizingMaskIntoConstraints = false
	//				imageView.topAnchor.constraint(equalTo: self.attachmentView.topAnchor, constant: 4).isActive = true
	//				imageView.leadingAnchor.constraint(equalTo: self.attachmentView.leadingAnchor, constant: 4).isActive = true
	//				imageView.bottomAnchor.constraint(equalTo: self.attachmentView.bottomAnchor, constant: -4).isActive = true
	//				imageView.trailingAnchor.constraint(equalTo: self.attachmentView.trailingAnchor, constant: -4).isActive = true
	//
	////				self.attachmentView.translatesAutoresizingMaskIntoConstraints = false
	////				self.attachmentView.topAnchor.constraint(equalTo: self.textLabel.stringValue.isEmpty ? self.nameLabel.bottomAnchor : self.textLabel.bottomAnchor).isActive = true
	////				self.attachmentView.leadingAnchor.constraint(equalTo: self.textLabel.leadingAnchor).isActive = true
	////				self.attachmentView.trailingAnchor.constraint(lessThanOrEqualTo: self.textLabel.trailingAnchor).isActive = true
	////				let aspectRatio = imageSize.height / imageSize.width
	////				self.attachmentView.heightAnchor.constraint(equalTo: self.attachmentView.widthAnchor, multiplier: aspectRatio).isActive = true
	//
	//				self.attachmentView.isHidden = false
	//			}
	//		}
	//		runningImageTasks.insert(task)
	//	}
	//	private func addUnsupportedAttachmentMessage(contentType: GroupMe.Attachment.ContentType) {
	//		let unsupportedLabel: NSTextField = {
	//			let field = NSTextField()
	//
	//			field.stringValue = UserMessageCell.unsupportedAttachmentMessage(for: contentType)
	//			field.isEditable = false
	//			field.isSelectable = false
	//			field.isBezeled = false
	//			field.font = Fonts.regularLarge
	//
	//			return field
	//		}()
	//
	//		attachmentView.addSubview(unsupportedLabel)
	//
	//		unsupportedLabel.translatesAutoresizingMaskIntoConstraints = false
	//		unsupportedLabel.topAnchor.constraint(equalTo: attachmentView.topAnchor, constant: 4).isActive = true
	//		unsupportedLabel.leadingAnchor.constraint(equalTo: attachmentView.leadingAnchor, constant: 4).isActive = true
	//		unsupportedLabel.bottomAnchor.constraint(equalTo: attachmentView.bottomAnchor, constant: -4).isActive = true
	//		unsupportedLabel.trailingAnchor.constraint(equalTo: attachmentView.trailingAnchor, constant: -4).isActive = true
	//
	//		attachmentView.isHidden = false
	//	}
	//	static func unsupportedAttachmentMessage(for contentType: GroupMe.Attachment.ContentType) -> String {
	//		return "Attachments of type '\(contentType.rawValue)' are currently not supported."
	//	}
}
