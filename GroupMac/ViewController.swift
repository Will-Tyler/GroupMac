//
//  ViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource {

	let groups = GroupMe.Group.groups
	let groupsTableView: NSTableView = {
		let tableView = NSTableView()
		tableView.headerView = nil

		let column = NSTableColumn(/*identifier: NSUserInterfaceItemIdentifier("column")*/)

		tableView.addTableColumn(column)

		return tableView
	}()
	let scrollView = NSScrollView()
	let inputTextField: NSTextField = {
		let textField = NSTextField(string: "Enter your message.")

		return textField
	}()

	private func setupInitialLayout() {
		view.addSubview(scrollView)

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true

		view.addSubview(inputTextField)

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
		inputTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
	}

	override func loadView() {
		self.view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		groupsTableView.dataSource = self
		scrollView.documentView = groupsTableView

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

