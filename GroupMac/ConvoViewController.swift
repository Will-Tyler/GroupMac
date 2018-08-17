//
//  ConvoViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class ConvoViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

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

			scrollTranscriptToBottom()
		}
	}
	private var messages: [GMMessage]? {
		didSet {
			DispatchQueue.main.async {
				self.messagesCollectionView.visibleItems().forEach { (cell) in
					if let userCell = cell as? UserMessageCell {
						userCell.cancelRunningImageTasks()
					}
				}
				self.messagesCollectionView.reloadData()
			}
		}
	}

	override func loadView() {
		view = containerView
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		scrollView.documentView = messagesCollectionView
//		NotificationCenter.default.addObserver(self, selector: #selector(scrollViewDidScroll(notification:)), name: NSView.boundsDidChangeNotification, object: scrollView.contentView)

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
	override func viewWillAppear() {
		super.viewWillAppear()

		scrollTranscriptToBottom()
	}

	private func scrollTranscriptToBottom() {
		DispatchQueue.main.async {
			let scrollPoint = NSPoint(x: 0, y: self.messagesCollectionView.bounds.height - self.scrollView.bounds.height)

			self.scrollView.contentView.scroll(to: scrollPoint)
			self.scrollView.reflectScrolledClipView(self.scrollView.contentView)
		}
	}

	@objc private func heartButtonAction(sender: HeartButton) {
		let messageCell = messagesCollectionView.item(at: sender.tag)! as! MessageCell

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

		let cellID = message.isSystem ? SystemMessageCell.cellIdentifier : UserMessageCell.cellIdentifier
		let item = collectionView.makeItem(withIdentifier: cellID, for: indexPath) as! MessageCell

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
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		// Layout usually occurs before cell creation.
		// Create a cell to determine the correct height
		// Creating a cell doesn't work. Recreate labels to get estimated desired height
		let collectionViewWidth = collectionView.bounds.width
		let avatarImageWidth: CGFloat = 30
		let spacing: CGFloat = 4
		let likesViewWidth: CGFloat = 17
		let minimumHeight: CGFloat = avatarImageWidth + (2*spacing)
		let desiredHeight: CGFloat = {
			let message: GMMessage = {
				let count = messages!.count

				return messages![count-1 - indexPath.item]
			}()

			let operatingWidth = collectionViewWidth - (avatarImageWidth + likesViewWidth + (4*spacing))
			let labels = (name: message.name as NSString, text: message.text as NSString?)
			let restrictedSize = CGSize(width: operatingWidth, height: .greatestFiniteMagnitude)
			let drawingOptions = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

			let nameEstimate: CGRect = labels.name.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: Fonts.boldSmall])
			let textFont = message.isSystem ? Fonts.regularSmall : Fonts.regular
			let textEstimate: CGRect? = labels.text?.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: textFont])

			let textHeight = (message.isSystem ? 0 : nameEstimate.height) + (textEstimate?.height ?? 0)

			var attachmentHeight: CGFloat = 0
			if let attachment = message.attachments.first {
				switch attachment.contentType {
				case .image:
					let maxImageSize = NSSize(width: 500, height: 500)
					let maxContainerWidth = maxImageSize.width + 8

					if operatingWidth > maxContainerWidth {
						attachmentHeight += maxImageSize.height + 8
					}
					else {
						let aspectRatio = maxImageSize.height / maxImageSize.width
						let containerHeight = (operatingWidth * aspectRatio) + 8

						attachmentHeight += containerHeight
					}

				default:
					let attachment = message.attachments.first!

					switch attachment.contentType {
					case .mentions:
						let mutableString = NSMutableAttributedString(string: message.text!)
						let mentions = attachment.content as! GroupMe.Attachment.Mentions

						for location in mentions.loci {
							let range = NSRange(location: location.first!, length: location.last!)

							mutableString.addAttribute(.font, value: Fonts.bold, range: range)
						}

						let boundingBox = mutableString.boundingRect(with: restrictedSize, options: drawingOptions)

						attachmentHeight += boundingBox.height - textEstimate!.height
						
					default:
						let unsupportedMessage = UserMessageCell.unsupportedAttachmentMessage(for: attachment.contentType) as NSString
						let size = NSSize(width: operatingWidth - (2*spacing), height: .greatestFiniteMagnitude)
						let textEstimate: CGRect = unsupportedMessage.boundingRect(with: size, options: drawingOptions, attributes: [.font: Fonts.regularLarge])

						attachmentHeight += textEstimate.height + 8
					}
				}
			}

			return textHeight + attachmentHeight
		}()
		let resultHeight = desiredHeight > minimumHeight ? desiredHeight : minimumHeight

		return NSSize(width: collectionView.bounds.width, height: resultHeight)
	}

	// MARK: Scroll view
	private var runningTask: URLSessionDataTask?
	@objc private func scrollViewDidScroll(notification: NSNotification) {
		let percentScrolled = Int(scrollView.verticalScroller!.floatValue * 100)

		if percentScrolled < 10, (runningTask == nil || runningTask?.state != .running) {
			let task = conversation.handleMessages(with: { (newMessages) in
				self.messages!.append(contentsOf: newMessages)
			}, beforeID: messages!.last!.id)

			runningTask = task
		}
	}
}
