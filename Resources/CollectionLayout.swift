//
//  CollectionLayout.swift
//  GroupMac
//
//  Created by Will Tyler on 7/4/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class CollectionLayout: NSCollectionViewFlowLayout {

	override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
		return true
	}

}
