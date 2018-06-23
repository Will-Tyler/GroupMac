//
//  GroupsViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class GroupsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

	private let groups = GroupMe.Group.groups
	private let groupsTableView: NSTableView = {
		let tableView = NSTableView()

		tableView.headerView = nil
		tableView.refusesFirstResponder = true

		let column = NSTableColumn(/*identifier: NSUserInterfaceItemIdentifier("column")*/)

		tableView.addTableColumn(column)

		return tableView
	}()
	private let scrollView = NSScrollView()

	var messagesDelegate: MessagesViewController?

	override func loadView() {
		view = scrollView
	}
	override func viewDidLoad() {
		scrollView.documentView = groupsTableView

		groupsTableView.delegate = self
		groupsTableView.dataSource = self
	}

	//MARK: Table view
	func numberOfRows(in tableView: NSTableView) -> Int {
		return groups.count
	}
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		let cell = NSCell(textCell: groups[row].name)

		return cell
	}
	func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		return
	}
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		messagesDelegate?.messages = groups[row].messages

		return true
	}
	func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
		return false
	}

}
