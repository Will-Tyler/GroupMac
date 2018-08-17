//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 8/17/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


final class MessagesViewController: NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {

	private let messagesCollectionView: NSCollectionView = {
		let collectionView = NSCollectionView()
		let flowLayout: NSCollectionViewFlowLayout = {
			let flow = NSCollectionViewFlowLayout()

			flow.minimumLineSpacing = 0
			flow.scrollDirection = .vertical

			return flow
		}()

		collectionView.collectionViewLayout = flowLayout
		collectionView.isSelectable = false

		collectionView.wantsLayer = true
		collectionView.layer!.borderWidth = 1
		collectionView.layer!.borderColor = Colors.border

		return collectionView
	}()
	private let scrollView = NSScrollView()

	private var messages: [GMMessage]!

}
