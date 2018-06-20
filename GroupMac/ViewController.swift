//
//  ViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

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
		let textField = NSTextField()
		textField.placeholderString = "Enter your message."

		return textField
	}()
	let messagesViewController = MessagesViewController()

	private func setupInitialLayout() {
		view.addSubview(scrollView)

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true

		view.addSubview(inputTextField)

		inputTextField.translatesAutoresizingMaskIntoConstraints = false
		inputTextField.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 4).isActive = true
		inputTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
		inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true

		let messageView = messagesViewController.view as! NSCollectionView

		view.addSubview(messageView)

		messageView.translatesAutoresizingMaskIntoConstraints = false
		messageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		messageView.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 4).isActive = true
		messageView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -4).isActive = true
		messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
	}

	override func loadView() {
		self.view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		groupsTableView.delegate = self
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
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		messagesViewController.messages = groups[row].messages

		return true
	}
}

