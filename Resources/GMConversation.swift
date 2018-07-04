//
//  GMConversation.swift
//  GroupMac
//
//  Created by Will Tyler on 6/26/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


protocol GMConversation {
	var name: String { get }
	var updatedAt: Int { get }
	var blandMessages: [GMMessage] { get }
	var conversationType: GMConversationType { get }
	var imageURL: URL? { get }
	var previewText: String? { get }
}

extension GroupMe.Chat: GMConversation {
	var name: String {
		get { return otherUser.name }
	}
	var blandMessages: [GMMessage] {
		get { return messages as [GMMessage] }
	}
	var conversationType: GMConversationType {
		get { return .chat }
	}
	var previewText: String? {
		get { return blandMessages.first!.text }
	}
	var imageURL: URL? {
		get { return otherUser.avatarURL }
	}
}

extension GroupMe.Group: GMConversation {
	var blandMessages: [GMMessage] {
		get { return messages as [GMMessage] }
	}
	var conversationType: GMConversationType {
		get { return .group }
	}
	var previewText: String? {
		get { return messagesInfo.preview.text }
	}
}
