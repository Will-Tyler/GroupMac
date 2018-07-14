//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class MessagesViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private let containerView: NSView = {
		let view = NSView()

		view.wantsLayer = true // leave on to prevent glitching when collection view is smaller than container

		return view
	}()
	private let titleView: NSView = {
		let view = NSView()

		view.wantsLayer = true
		view.layer!.backgroundColor = .white
		view.layer!.borderWidth = 1
		view.layer!.borderColor = Colors.border

		return view
	}()
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
	private let messagesCollectionView: NSCollectionView = {
		let collectionView = NSCollectionView()
		let flowLayout: NSCollectionViewFlowLayout = {
			let flow = NSCollectionViewFlowLayout()

			flow.minimumLineSpacing = 0
			flow.scrollDirection = .vertical

			return flow
		}()

		collectionView.collectionViewLayout = flowLayout
		collectionView.isSelectable = false

		collectionView.wantsLayer = true
		collectionView.layer!.borderWidth = 1
		collectionView.layer!.borderColor = Colors.border

		return collectionView
	}()
	private let scrollView: NSScrollView = {
		let scroll = NSScrollView()

		return scroll
	}()
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
		let inputView: NSView = {
			let view = NSView()

			view.backColor = .white
			view.wantsLayer = true
			view.layer!.borderWidth = 1
			view.layer!.borderColor = Colors.border

			return view
		}()

		inputView.addSubview(inputTextField)
		inputView.addSubview(sendButton)

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
		inputTextField.leadingAnchor.constraint(equalTo: inputView.leadingAnchor, constant: 4).isActive = true
		inputTextField.centerYAnchor.constraint(equalTo: inputView.centerYAnchor).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true

		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor).isActive = true
		sendButton.widthAnchor.constraint(equalToConstant: sendButton.intrinsicContentSize.width).isActive = true
		sendButton.trailingAnchor.constraint(equalTo: inputView.trailingAnchor, constant: -4).isActive = true
		sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true

		titleView.addSubview(groupImageView)
		titleView.addSubview(titleLabel)

		containerView.addSubview(scrollView)
		containerView.addSubview(titleView)
		containerView.addSubview(inputView)

		groupImageView.translatesAutoresizingMaskIntoConstraints = false
		groupImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		groupImageView.heightAnchor.constraint(equalTo: groupImageView.widthAnchor).isActive = true
		groupImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
		groupImageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 4).isActive = true
		groupImageView.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 4).isActive = true
		groupImageView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -4).isActive = true

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 4).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -4).isActive = true
		titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

		titleView.translatesAutoresizingMaskIntoConstraints = false
		titleView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		titleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		titleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		titleView.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height + 8).isActive = true

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -1).isActive = true // overlap borders to maintain 1 px
		scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: inputView.topAnchor, constant: 1).isActive = true

		inputView.translatesAutoresizingMaskIntoConstraints = false
		inputView.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
		inputView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		inputView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		inputView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
	}

	@objc private func sendButtonAction(sender: NSButton) {
		if conversation.convoType == .group {
			let group = conversation as! GroupMe.Group

			group.sendMessage(text: inputTextField.stringValue) {
				DispatchQueue.main.async {
					self.inputTextField.stringValue = ""
					self.messages = self.conversation.blandMessages
				}
			}
		}
		else {
			let chat = conversation as! GroupMe.Chat

			chat.sendMessage(text: inputTextField.stringValue) {
				DispatchQueue.main.async {
					self.inputTextField.stringValue = ""
					self.messages = self.conversation.blandMessages
				}
			}
		}
	}

	var conversation: GMConversation! {
		didSet {
			messages = conversation.blandMessages
			titleLabel.stringValue = conversation.name

			if let url = conversation.imageURL {
				HTTP.handleImage(at: url, with: { (image: NSImage) in
					DispatchQueue.main.async {
						self.groupImageView.image = image
					}
				})
			}
			else {
				groupImageView.image = #imageLiteral(resourceName: "Group Default Image")
			}

			if self.conversation.convoType == .chat {
				self.groupImageView.wantsLayer = true
				self.groupImageView.layer!.cornerRadius = self.groupImageView.bounds.width / 2
				self.groupImageView.layer!.masksToBounds = true
			}
			else {
				groupImageView.wantsLayer = true
				groupImageView.layer!.cornerRadius = 0
			}
		}
	}
	private var messages: [GMMessage]? {
		didSet {
			messagesCollectionView.visibleItems().forEach { (cell) in
				if let userCell = cell as? UserMessageCell {
					userCell.cancelRunningImageTasks()
				}
			}
			DispatchQueue.main.async {
				self.messagesCollectionView.reloadData()
				self.scrollToBottom()
			}
		}
	}

	override func loadView() {
		view = containerView
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		scrollView.documentView = messagesCollectionView
		
		messagesCollectionView.delegate = self
		messagesCollectionView.dataSource = self
		messagesCollectionView.register(UserMessageCell.self, forItemWithIdentifier: UserMessageCell.cellIdentifier)
		messagesCollectionView.register(SystemMessageCell.self, forItemWithIdentifier: SystemMessageCell.cellIdentifier)

		setupInitialLayout()
	}
	override func viewDidLayout() {
		super.viewDidLayout()

		messagesCollectionView.collectionViewLayout!.invalidateLayout()
	}
	override func viewDidAppear() {
		super.viewDidAppear()

		scrollToBottom()
	}

	private func scrollToBottom() {
		let scrollPoint = NSPoint(x: 0, y: messagesCollectionView.bounds.height - scrollView.bounds.height)
		scrollView.contentView.scroll(to: scrollPoint)
		scrollView.reflectScrolledClipView(scrollView.contentView)
	}

	@objc private func heartButtonAction(sender: CursorButton) {
		let messageCell = messagesCollectionView.item(at: sender.tag)! as! UserMessageCell
		messageCell.toggleLike()
	}

	//MARK: Collection view
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages?.count ?? 0
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let message: GMMessage = {
			let count = messages!.count

			return messages![count-1 - indexPath.item]
		}()
		
		if message.isSystem {
			let item = collectionView.makeItem(withIdentifier: SystemMessageCell.cellIdentifier, for: indexPath) as! SystemMessageCell

			item.message = message

			return item
		}
		else {
			let item = collectionView.makeItem(withIdentifier: UserMessageCell.cellIdentifier, for: indexPath) as! UserMessageCell

			item.message = message

			item.heartButton.tag = indexPath.item
			item.heartButton.target = self
			item.heartButton.action = #selector(heartButtonAction(sender:))
			item.heartButton.addTrackingArea({
				let options = NSTrackingArea.Options.mouseEnteredAndExited.union(.activeInActiveApp)
				
				return NSTrackingArea(rect: item.heartButton.bounds, options: options, owner: item.heartButton, userInfo: nil)
			}())

			return item
		}
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		// Layout usually occurs before cell creation.
		// Create a cell to determine the correct height
		// Creating a cell doesn't work. Recreate labels to get estimated desired height

		let desiredHeight: CGFloat = {
			let message: GMMessage = {
				let count = messages!.count

				return messages![count-1 - indexPath.item]
			}()

			if message.isSystem {
				return 42
			}
			else {
				let labels = (name: message.name as NSString, text: message.text as NSString?)
				let operatingWidth = collectionView.bounds.width - (16+30+22)
				let restrictedSize = CGSize(width: operatingWidth, height: .greatestFiniteMagnitude)
				let drawingOptions = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

				let nameEstimate: CGRect = labels.name.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: Fonts.boldSmall])
				let textEstimate: CGRect? = labels.text?.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: Fonts.regular])

				let textHeight = nameEstimate.height + (textEstimate?.height ?? 0)

				var attachmentHeight: CGFloat = 0
				message.attachments.forEach({ (attachment) in
					if attachment.contentType == .image, let attachedImage = attachment as? GroupMe.Attachment.Image {
						let imageURL = attachedImage.url
						let size = GroupMe.imageSize(from: imageURL)
						let containerWidth = size.width + 8

						guard operatingWidth < containerWidth else {
							attachmentHeight += size.height + 8

							return
						}

						let containerHeight = (operatingWidth * (size.height / size.width)) + 8

						attachmentHeight += containerHeight
					}
				})

				return textHeight + attachmentHeight
			}
		}()

		return NSSize(width: collectionView.bounds.width-2, height: desiredHeight)
	}
}






























