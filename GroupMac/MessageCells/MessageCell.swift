//
//  MessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/19/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class MessageCell: NSCollectionViewItem {
	
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

		view.addSubview(likesView)

		likesView.translatesAutoresizingMaskIntoConstraints = false
		likesView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true // constant 5 is best match for text
		likesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		likesView.bottomAnchor.constraint(equalTo: likesCountLabel.bottomAnchor).isActive = true
		likesView.widthAnchor.constraint(equalTo: heartButton.widthAnchor).isActive = true
	}

	private var likes: Set<String>!
	var message: GMMessage! {
		didSet {
			likes = Set<String>(message.favoritedBy)

			if message.favoritedBy.count > 0 {
				likesCountLabel.stringValue = "\(message.favoritedBy.count)"
				if message.favoritedBy.contains(AppDelegate.me.id) {
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

    override func viewDidLoad() {
        super.viewDidLoad()

		setupInitialLayout()
    }

	func toggleLike() {
		let myID = AppDelegate.me.id
		let isLiked = likes.contains(myID)
		if isLiked {
			message.unlike {
				self.likes = self.likes.filter({ $0 != AppDelegate.me.id })
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
				self.likes.insert(AppDelegate.me.id)
				DispatchQueue.main.async {
					self.heartButton.heart = Hearts.red
					self.likesCountLabel.stringValue = "\(self.likes.count)"
				}
			}
		}
	}
    
}









































