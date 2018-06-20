//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class MessagesViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {

	private let collectionView: NSCollectionView = {
		let collectionView = NSCollectionView()

//		let flowLayout = NSCollectionViewFlowLayout()
//		flowLayout.scrollDirection = .vertical
//		flowLayout.itemSize = NSSize(width: 40, height: 40)
//		flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
//		flowLayout.minimumInteritemSpacing = 20.0
//		flowLayout.minimumLineSpacing = 20.0
//
//		collectionView.collectionViewLayout = flowLayout

		return collectionView
	}()

	var messages: [GroupMe.Message]? {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
			print(messages!.first?.text ?? "")
		}
	}

	override func loadView() {
		view = collectionView
	}
	override func viewDidLoad() {
		collectionView.delegate = self
		collectionView.dataSource = self
	}

	//MARK: Collection View
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages?.count ?? 0
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let cell = NSCollectionViewItem()

		cell.textField = NSTextField(string: (messages?[indexPath.item].text)!)
		cell.view.wantsLayer = true
		cell.view.layer?.backgroundColor = CGColor.black

		return cell
	}

}
