//
//  SystemMessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/4/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


final class SystemMessageCell: MessageCell {

	static let cellID = NSUserInterfaceItemIdentifier(rawValue: "SystemMessageCell")

	override var message: GMMessage! {
		didSet {
			avatarImageView.image = NSImage(named: "System Default Image")
			view.backColor = Colors.systemBackground
		}
	}

	override func loadView() {
		view = NSView()

		view.backColor = Colors.systemBackground
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		avatarImageView.image = #imageLiteral(resourceName: "System Default Image")

		textLabel.font = Fonts.regularSmall
		textLabel.textColor = Colors.systemText
	}
	
}
