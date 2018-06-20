//
//  AppDelegate.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let windowController: NSWindowController = {
		let window = NSWindow()
		window.setFrame(NSRect(x: window.screen!.visibleFrame.midX, y: window.screen!.visibleFrame.midY, width: 500, height: 300), display: true)
		window.center()
		window.styleMask = NSWindow.StyleMask(rawValue: NSWindow.StyleMask.RawValue((UInt8(NSWindow.StyleMask.titled.rawValue) | UInt8(NSWindow.StyleMask.closable.rawValue) | UInt8(NSWindow.StyleMask.miniaturizable.rawValue) | UInt8(NSWindow.StyleMask.resizable.rawValue))))
		window.title = "GroupMac"
		window.isMovable = true
		window.minSize = NSSize(width: 500, height: 300)

		window.makeKeyAndOrderFront(nil)
		
		let windowController = NSWindowController(window: window)
		windowController.shouldCascadeWindows = true

		return windowController
	}()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		windowController.window?.makeKeyAndOrderFront(nil)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}

