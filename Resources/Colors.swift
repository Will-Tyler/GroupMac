//
//  Colors.swift
//  GroupMac
//
//  Created by Will Tyler on 7/3/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


struct Colors {
	static let border: CGColor = {
		let value: CGFloat = 212 / 255

		return CGColor(red: value, green: value, blue: value, alpha: 1)
	}()
	static let title: NSColor = {
		let value: CGFloat = 0x3b / 255

		return NSColor(red: value, green: value, blue: value, alpha: 1)
	}()
}
