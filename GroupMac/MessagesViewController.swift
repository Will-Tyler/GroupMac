//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 8/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class MessagesViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private let collectionView: NSCollectionView = {
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
	private let scrollView = NSScrollView()

	private var messages: [GMMessage]! {
		didSet {
			DispatchQueue.main.async {
				for cell in self.collectionView.visibleItems() {
					if let userCell = cell as? UserMessageCell {
						userCell.cancelRunningImageTasks()
					}
				}
				self.collectionView.reloadData()
			}
		}
	}

	override func loadView() {
		view = scrollView
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		scrollView.documentView = collectionView

		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(UserMessageCell.self, forItemWithIdentifier: UserMessageCell.cellIdentifier)
		collectionView.register(SystemMessageCell.self, forItemWithIdentifier: SystemMessageCell.cellIdentifier)
	}
	override func viewDidLayout() {
		super.viewDidLayout()

		collectionView.collectionViewLayout!.invalidateLayout()
	}

	private func scrollTranscriptToBottom() {
		let scrollPoint = NSPoint(x: 0, y: collectionView.bounds.height - scrollView.bounds.height)

		DispatchQueue.main.async {
			self.scrollView.contentView.scroll(to: scrollPoint)
			self.scrollView.reflectScrolledClipView(self.scrollView.contentView)
		}
	}

	@objc private func heartButtonAction(sender: HeartButton) {
		let messageCell = collectionView.item(at: sender.tag)! as! MessageCell

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

}
