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
}

extension GroupMe.Group: GMConversation {
	var blandMessages: [GMMessage] {
		get { return messages as [GMMessage] }
	}
	var conversationType: GMConversationType {
		get { return .group }
	}
}
