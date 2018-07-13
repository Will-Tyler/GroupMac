//
//  Hearts.swift
//  GroupMac
//
//  Created by Will Tyler on 7/13/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


struct Hearts {
	static let hover = NSAttributedString(string: "\u{e60b}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.systemText])
	static let grey = NSAttributedString(string: "\u{e60b}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartGrey]) // filled heart
	static let outline = NSAttributedString(string: "\u{e618}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartGrey])
	static let red = NSAttributedString(string: "\u{e60b}", attributes: [.font: Fonts.groupMeSymbols, .foregroundColor: Colors.heartRed])
}
