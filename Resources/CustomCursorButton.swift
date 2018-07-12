//
//  CustomCursorButton.swift
//  GroupMac
//
//  Created by Will Tyler on 7/11/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class CustomCursorButton: NSButton {

	var cursor: NSCursor?
	var previousTitle: NSAttributedString?

	override func resetCursorRects() {
		if let cursor = cursor {
			discardCursorRects()
			addCursorRect(bounds, cursor: cursor)
		}
		else {
			super.resetCursorRects()
		}
	}
	override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)

		previousTitle = attributedTitle

		attributedTitle = NSAttributedString(string: "\u{e60b}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.systemText])
	}
	override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)

		attributedTitle = previousTitle!
	}
    
}
