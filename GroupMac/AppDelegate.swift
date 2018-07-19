//
//  AppDelegate.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {

	static let me = GroupMe.me

	let windowController: NSWindowController = {
		let window = NSWindow()
		let screen = window.screen!
		let screenSize = screen.size

		print("\(screenSize.width)", "\(screenSize.height)")

		let initialWindowFrame = NSRect(x: window.screen!.visibleFrame.midX, y: window.screen!.visibleFrame.midY, width: screenSize.width / 4, height: screenSize.height / 4)

		window.minSize = NSSize(width: 500, height: 300)
		window.setFrame(initialWindowFrame, display: true)
		window.center()
		window.styleMask = [.miniaturizable, .closable, .resizable, .titled]
		window.title = "GroupMac"
		window.isMovable = true
		window.contentViewController = ViewController()

		let windowController = NSWindowController(window: window)
		
		windowController.shouldCascadeWindows = true

		return windowController
	}()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		windowController.window!.makeKeyAndOrderFront(nil)
	}

}

