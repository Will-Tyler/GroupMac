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
	static let background: CGColor = CGColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
	static let systemBackground: CGColor = {
		let value: CGFloat = 240 / 255

		return CGColor(gray: value, alpha: 1)
	}()
	static let separator: CGColor = {
		let value: CGFloat = 230 / 255

		return CGColor(red: value, green: value, blue: value, alpha: 1)
	}()
	static let systemText = NSColor(red: 0x62 / 255, green: 0x6f / 255, blue: 0x82 / 255, alpha: 1)
}
