//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class MessagesViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private let containerView = NSView()
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
	private let inputTextField: NSTextField = {
		let field = NSTextField()

		field.font = Fonts.regular
		field.placeholderString = "Send Message..."
		field.isBezeled = false

		field.wantsLayer = true
		field.layer!.borderWidth = 1
		field.layer!.borderColor = Colors.border

		return field
	}()

	private func setupInitialLayout() {
		titleView.addSubview(groupImageView)
		titleView.addSubview(titleLabel)

		containerView.addSubview(scrollView)
		containerView.addSubview(titleView)
		containerView.addSubview(inputTextField)

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
		scrollView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -1).isActive = true // overlap borders
		scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor).isActive = true

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
		inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
	}

	var conversation: GMConversation! {
		didSet {
			messages = conversation.blandMessages
			titleLabel.stringValue = conversation.name

			HTTP.handleImage(at: conversation.imageURL, with: { (image: NSImage) in
				DispatchQueue.main.async {
					self.groupImageView.image = image
				}

				if self.conversation.conversationType == .chat {
					DispatchQueue.main.async {
						self.groupImageView.wantsLayer = true
						self.groupImageView.layer!.cornerRadius = self.groupImageView.bounds.width / 2
						self.groupImageView.layer!.masksToBounds = true
					}
				}
			})
		}
	}
	private var messages: [GMMessage]? {
		didSet {
			DispatchQueue.main.async {
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
				let restrictedSize = CGSize(width: collectionView.bounds.width - (12+24), height: .greatestFiniteMagnitude)
				let drawingOptions = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

				let nameEstimate: CGRect = labels.name.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: Fonts.boldSmall])
				let textEstimate: CGRect? = labels.text?.boundingRect(with: restrictedSize, options: drawingOptions, attributes: [.font: Fonts.regular])

				return nameEstimate.height + (textEstimate?.height ?? 0)
			}
		}()

		return NSSize(width: collectionView.bounds.width-2, height: desiredHeight)
	}
}






























