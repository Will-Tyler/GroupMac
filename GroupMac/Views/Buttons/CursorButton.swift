//
//  CursorButton.swift
//  GroupMac
//
//  Created by Will Tyler on 7/11/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class CursorButton: NSButton {

	var cursor: NSCursor?

	override func resetCursorRects() {
		if let cursor = cursor {
			discardCursorRects()
			addCursorRect(bounds, cursor: cursor)
		}
		else {
			super.resetCursorRects()
		}
	}
    
}
