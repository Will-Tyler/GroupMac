//
//  AppDelegate.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import AppKit


final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

	private var window: NSWindow!
	private let defaults = UserDefaults.standard
	private let windowFrameKey = "window.frame"

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		window = NSWindow()

		let screen = window.screen!
		let screenSize = screen.size
		let windowFrame: NSRect

		if let frameData = defaults.object(forKey: windowFrameKey) as? Data, let frame = NSKeyedUnarchiver.unarchiveObject(with: frameData) as? NSRect {
			windowFrame = frame
		}
		else {
			windowFrame = NSRect(x: screen.visibleFrame.midX, y: screen.visibleFrame.midY, width: screenSize.width / 4, height: screenSize.height / 4)
		}

		window.delegate = self
		window.minSize = NSSize(width: 500, height: 300)
		window.styleMask = [.miniaturizable, .closable, .resizable, .titled]
		window.title = "GroupMac"
		window.isMovable = true
		window.contentViewController = ViewController()
		window.setFrame(windowFrame, display: false)

		let windowController = NSWindowController(window: window)

		windowController.shouldCascadeWindows = true
		window.makeKeyAndOrderFront(self)
	}

	private func saveWindowFrame() {
		let frame = window.frame
		let frameData = NSKeyedArchiver.archivedData(withRootObject: frame)

		defaults.set(frameData, forKey: windowFrameKey)
	}

	func windowDidEndLiveResize(_ notification: Notification) {
		saveWindowFrame()
	}
	func windowDidMove(_ notification: Notification) {
		saveWindowFrame()
	}

}
