//
//  HeartButton.swift
//  GroupMac
//
//  Created by Will Tyler on 7/13/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa

class HeartButton: CursorButton {

	typealias Heart = NSAttributedString

	private var previousTitle: NSAttributedString?
	private var isLiked: Bool {
		get { return attributedTitle == Hearts.red }
	}
	var heart: Heart {
		get { return attributedTitle }
		set { attributedTitle = newValue }
	}

	override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)

		if isLiked {
			previousTitle = nil
		}
		else {
			previousTitle = attributedTitle
			attributedTitle = Hearts.hover
		}
	}
	override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)

		guard !isLiked else { return }
		if let title = previousTitle {
			attributedTitle = title
		}
	}
    
}
