//
//  SystemMessageCell.swift
//  GroupMac
//
//  Created by Will Tyler on 7/4/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class SystemMessageCell: NSCollectionViewItem {

	static let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "SystemMessageCell")
	override func loadView() {
		view = {
			let view = NSView()

			view.wantsLayer = true
			view.layer!.backgroundColor = NSColor.systemPink.cgColor

			return view
		}()
	}
	
}
