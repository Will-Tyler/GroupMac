//
//  ViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa

class GroupsViewController: NSViewController, NSTableViewDataSource {

	let groups = GroupMe.Group.groups
	let groupsTableView: NSTableView = {
		let tableView = NSTableView()

		let column = NSTableColumn(/*identifier: NSUserInterfaceItemIdentifier("column")*/)
		tableView.addTableColumn(column)

		return tableView
	}()
	let scrollView = NSScrollView()

	private func setupInitialLayout() {
		scrollView.documentView = groupsTableView
		view.addSubview(scrollView)

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true

		for group in groups {
			print(group.name)
		}
	}

	override func loadView() {
		self.view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		groupsTableView.dataSource = self

		setupInitialLayout()
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
}

