//
//  SystemMessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/4/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class SystemMessageCell: MessageCell {

	override var message: GMMessage! {
		didSet {
			avatarImageView.image = #imageLiteral(resourceName: "System Default Image")
			view.backColor = Colors.systemBackground
		}
	}

	override func loadView() {
		view = {
			let view = NSView()

			view.backColor = Colors.systemBackground

			return view
		}()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		avatarImageView.image = #imageLiteral(resourceName: "System Default Image")

		textLabel.font = Fonts.regularSmall
		textLabel.textColor = Colors.systemText
	}

	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "SystemMessageCell")
	
}
