//
//  ViewController.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


final class ViewController: NSViewController {

	private lazy var convosViewController = ConvosViewController()
	private lazy var convoViewController = ConvoViewController()

	private func setupInitialLayout() {
		view.removeSubviews()

		let convosView = convosViewController.view
		let convoView = convoViewController.view

		view.addSubview(convosView)
		view.addSubview(convoView)

		convosView.translatesAutoresizingMaskIntoConstraints = false
		convosView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		convosView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		convosView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
		convosView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true

		convoView.translatesAutoresizingMaskIntoConstraints = false
		convoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
		convoView.leadingAnchor.constraint(equalTo: convosView.trailingAnchor, constant: 4).isActive = true
		convoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
		convoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
	}

	override func loadView() {
		view = NSView()
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		addChild(convosViewController)
		addChild(convoViewController)

		convosViewController.convoViewController = convoViewController

		setupInitialLayout()
	}
	
}
