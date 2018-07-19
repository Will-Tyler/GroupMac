//
//  NSScreen.swift
//  GroupMac
//
//  Created by Will Tyler on 7/19/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


extension NSScreen {
	var size: NSSize {
		get {
			return NSSize(width: frame.width, height: frame.height)
		}
	}
}
