//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 8/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


final class MessagesViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private lazy var collectionView: NSCollectionView = {
		let layout = NSCollectionViewFlowLayout()

		layout.minimumLineSpacing = 0
		layout.scrollDirection = .vertical

		let collection = NSCollectionView()

		collection.delegate = self
		collection.dataSource = self
		collection.register(UserMessageCell.self, forItemWithIdentifier: UserMessageCell.cellID)
		collection.register(SystemMessageCell.self, forItemWithIdentifier: SystemMessageCell.cellID)

		collection.collectionViewLayout = layout
		collection.isSelectable = false

		collection.wantsLayer = true
		collection.layer!.borderWidth = 1
		collection.layer!.borderColor = Colors.border

		return collection
	}()
	private lazy var scrollView: NSScrollView = {
		let scroll = NSScrollView()

		scroll.documentView = collectionView

		return scroll
	}()

	override func loadView() {
		view = scrollView
	}
	override func viewDidLayout() {
		super.viewDidLayout()

		collectionView.collectionViewLayout!.invalidateLayout()
	}
	override func viewWillAppear() {
		super.viewWillAppear()

		scrollToBottom()
	}

	var messages: [GMMessage]! {
		didSet {
			DispatchQueue.main.async {
				for cell in self.collectionView.visibleItems() {
					if let userCell = cell as? UserMessageCell {
						userCell.cancelRunningImageTasks()
					}
				}

				self.collectionView.reloadData()
				self.scrollToBottom()
			}
		}
	}

	func scrollToBottom() {
		let scrollPoint = NSPoint(x: 0, y: collectionView.bounds.height - scrollView.bounds.height)

		DispatchQueue.main.async {
			self.scrollView.contentView.scroll(to: scrollPoint)
			self.scrollView.reflectScrolledClipView(self.scrollView.contentView)
		}
	}

	@objc
	private func heartButtonAction(sender: HeartButton) {
		let messageCell = collectionView.item(at: sender.tag)! as! MessageCell

		messageCell.toggleLike()
	}

	//MARK: Collection view
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages?.count ?? 0
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let count = messages!.count
		let message = messages![count-1 - indexPath.item]

		let cellID = message.isSystem ? SystemMessageCell.cellID : UserMessageCell.cellID
		let item = collectionView.makeItem(withIdentifier: cellID, for: indexPath) as! MessageCell

		item.message = message

		item.heartButton.tag = indexPath.item
		item.heartButton.target = self
		item.heartButton.action = #selector(heartButtonAction(sender:))

		let trackingOptions = NSTrackingArea.Options.mouseEnteredAndExited.union(.activeInActiveApp)
		let trackingArea = NSTrackingArea(rect: item.heartButton.bounds, options: trackingOptions, owner: item.heartButton, userInfo: nil)

		item.heartButton.addTrackingArea(trackingArea)

		return item
	}
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		let collectionViewWidth = collectionView.bounds.width
		let avatarImageWidth: CGFloat = 30
		let spacing: CGFloat = 4
		let likesViewWidth: CGFloat = 17
		let minimumHeight: CGFloat = avatarImageWidth + 2*spacing

		let count = messages!.count
		let message = messages![count-1 - indexPath.item]

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

		let desiredHeight = textHeight + attachmentHeight
		let resultHeight = desiredHeight > minimumHeight ? desiredHeight : minimumHeight

		return NSSize(width: collectionView.bounds.width, height: resultHeight)
	}

}
