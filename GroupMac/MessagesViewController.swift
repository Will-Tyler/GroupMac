//
//  MessagesViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class MessagesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

	private let messagesTableView: NSTableView = {
		let tableView = NSTableView()

		tableView.headerView = nil
		tableView.refusesFirstResponder = true

		let column = NSTableColumn(/*identifier: NSUserInterfaceItemIdentifier("column")*/)
		tableView.addTableColumn(column)

		return tableView
	}()
	private let scrollView = NSScrollView()

	var messages: [GroupMe.GroupMessage]? {
		didSet {
			DispatchQueue.main.async {
				self.messagesTableView.reloadData()
			}
		}
	}

	override func loadView() {
		view = scrollView
	}
	override func viewDidLoad() {
		scrollView.documentView = messagesTableView
		
		messagesTableView.delegate = self
		messagesTableView.dataSource = self
	}

	//MARK: Tableview
	func numberOfRows(in tableView: NSTableView) -> Int {
		return messages?.count ?? 0
	}
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		if let count = messages?.count, let text = messages?[count-1 - row].text {
			let cell = NSCell(textCell: text)

			return cell
		}
		else {
			return nil
		}
	}
	func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		return
	}
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return false
	}

}
