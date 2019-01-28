//
//  FlippedClipView.swift
//  GroupMac
//
//  Created by Will Tyler on 1/27/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import AppKit


class FlippedClipView: NSClipView {

	override var isFlipped: Bool {
		get {
			return true
		}
	}

}