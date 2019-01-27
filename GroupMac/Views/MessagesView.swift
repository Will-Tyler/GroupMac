//
//  MessagesView.swift
//  GroupMac
//
//  Created by Will Tyler on 1/25/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import AppKit


class MessagesView: NSScrollView, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	convenience init(delegate: MessagesViewDelegate) {
		self.init()
		self.delegate = delegate
	}
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)

		documentView = collectionView
		contentView.postsBoundsChangedNotifications = true

		NotificationCenter.default.addObserver(self, selector: #selector(didScroll), name: NSView.boundsDidChangeNotification, object: contentView)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private lazy var collectionView: NSCollectionView = {
		let layout = NSCollectionViewFlowLayout()

		layout.minimumLineSpacing = 0
		layout.scrollDirection = .vertical

		let collection = NSCollectionView()

		collection.collectionViewLayout = layout
		collection.isSelectable = false

		collection.delegate = self
		collection.dataSource = self
		collection.register(MessageCell.self, forItemWithIdentifier: MessageCell.cellID)

		collection.wantsLayer = true
		collection.layer!.borderWidth = 1
		collection.layer!.borderColor = Colors.border

		return collection
	}()

	override func layout() {
		super.layout()

		collectionView.collectionViewLayout?.invalidateLayout()
	}

	var delegate: MessagesViewDelegate?
	var messages = [GMMessage]() {
		didSet {
			DispatchQueue.main.async {
				self.shouldAllowLoadMoreMessages = false
				self.collectionView.reloadData()

				if !self.hasSetMessages {
					self.collectionView.scrollToBottom()
				}

				self.shouldAllowLoadMoreMessages = true
				self.hasSetMessages = true
			}
		}
	}

	private var hasSetMessages = false
	private var shouldAllowLoadMoreMessages = false

	@objc
	private func didScroll() {
		let y = documentVisibleRect.origin.y

		if y < 16, shouldAllowLoadMoreMessages {
			shouldAllowLoadMoreMessages = false
			delegate?.shouldInsertMoreMessages()
		}
	}

	// Collection view
	func numberOfSections(in collectionView: NSCollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: MessageCell.cellID, for: indexPath) as! MessageCell
		let count = messages.count
		let message = messages[count-1 - indexPath.item]

		item.message = message

		return item
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		let collectionViewWidth = collectionView.bounds.width
		let avatarImageWidth: CGFloat = 30
		let spacing: CGFloat = 4
		let likesViewWidth: CGFloat = 17
		let minimumHeight: CGFloat = avatarImageWidth + 2*spacing

		let count = messages.count
		let message = messages[count-1 - indexPath.item]

		let operatingWidth = collectionViewWidth - (avatarImageWidth + likesViewWidth + (4*spacing))
		let name = message.name as NSString
		let text = message.text as NSString?
		let textFont = message.isSystem ? Fonts.regularSmall : Fonts.regular
		let restrictedSize = CGSize(width: operatingWidth, height: .greatestFiniteMagnitude)
		let drawingOptions: NSString.DrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]

		let nameEstimate: CGRect = name.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: Fonts.boldSmall])
		let textEstimate: CGRect? = text?.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: textFont])

		let textHeight = (message.isSystem ? 0 : nameEstimate.height) + (textEstimate?.height ?? 0)

//		var attachmentHeight: CGFloat = 0
//		if let attachment = message.attachments.first {
//			switch attachment.contentType {
//			case .image:
//				let maxImageSize = NSSize(width: 500, height: 500)
//				let maxContainerWidth = maxImageSize.width + 8
//
//				if operatingWidth > maxContainerWidth {
//					attachmentHeight += maxImageSize.height + 8
//				}
//				else {
//					let aspectRatio = maxImageSize.height / maxImageSize.width
//					let containerHeight = (operatingWidth * aspectRatio) + 8
//
//					attachmentHeight += containerHeight
//				}
//
//			default:
//				let attachment = message.attachments.first!
//
//				switch attachment.contentType {
//				case .mentions:
//					let mutableString = NSMutableAttributedString(string: message.text!)
//					let mentions = attachment.content as! GroupMe.Attachment.Mentions
//
//					for location in mentions.loci {
//						let range = NSRange(location: location.first!, length: location.last!)
//
//						mutableString.addAttribute(.font, value: Fonts.bold, range: range)
//					}
//
//					let boundingBox = mutableString.boundingRect(with: restrictedSize, options: drawingOptions)
//
//					attachmentHeight += boundingBox.height - textEstimate!.height
//
//				default:
//					let unsupportedMessage = UserMessageCell.unsupportedAttachmentMessage(for: attachment.contentType) as NSString
//					let size = NSSize(width: operatingWidth - (2*spacing), height: .greatestFiniteMagnitude)
//					let textEstimate: CGRect = unsupportedMessage.boundingRect(with: size, options: drawingOptions, attributes: [.font: Fonts.regularLarge])
//
//					attachmentHeight += textEstimate.height + 8
//				}
//			}
//		}
//
//		let desiredHeight = textHeight + attachmentHeight
		let desiredHeight = textHeight
		let resultHeight = desiredHeight > minimumHeight ? desiredHeight : minimumHeight

		return NSSize(width: collectionView.bounds.width, height: resultHeight)
	}

}


protocol MessagesViewDelegate {

	func shouldInsertMoreMessages()

}
