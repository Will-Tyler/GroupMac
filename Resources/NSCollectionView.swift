//
//  NSCollectionView.swift
//  GroupMac
//
//  Created by Will Tyler on 1/27/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import AppKit


extension NSCollectionView {
	
	func scrollToBottom() {
		let sections = self.numberOfSections

		if sections > 0 {
			let rows = self.numberOfItems(inSection: sections - 1)
			let last = IndexPath(item: rows - 1, section: sections - 1)

			DispatchQueue.main.async {
				self.scrollToItems(at: [last], scrollPosition: .bottom)
			}
		}
	}

}
