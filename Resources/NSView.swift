//
//  NSView.swift
//  GroupMac
//
//  Created by Will Tyler on 7/11/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


extension NSView {
	
	var backColor: CGColor? {
		get {
			if wantsLayer {
				return layer?.backgroundColor
			}
			else { return nil }
		}
		set {
			guard let newColor = newValue else { return }

			wantsLayer = true
			layer!.backgroundColor = newColor
		}
	}

	func removeSubviews() {
		subviews.forEach({ $0.removeFromSuperview() })
	}

}
