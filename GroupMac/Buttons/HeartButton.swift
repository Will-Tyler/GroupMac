//
//  HeartButton.swift
//  GroupMac
//
//  Created by Will Tyler on 7/13/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa

class HeartButton: CursorButton {
	
	var previousTitle: NSAttributedString?

	override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)

		if attributedTitle == Hearts.red {
			previousTitle = nil
		}
		else {
			previousTitle = attributedTitle
			attributedTitle = Hearts.hover
		}
	}
	override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)

		if let title = previousTitle {
			attributedTitle = title
		}
	}
    
}
