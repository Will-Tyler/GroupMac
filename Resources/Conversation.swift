//
//  Conversation.swift
//  GroupMac
//
//  Created by Will Tyler on 6/26/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


protocol Conversation {
	var name: String { get }
	var updatedAt: Int { get }
	var blandMessages: [GroupMeMessage] { get }
}

extension GroupMe.Chat: Conversation {
	var name: String {
		get {
			return otherUser.name
		}
	}
	var blandMessages: [GroupMeMessage] {
		get {
			return messages as [GroupMeMessage]
		}
	}
}

extension GroupMe.Group: Conversation {
	var blandMessages: [GroupMeMessage] {
		get {
			return messages as [GroupMeMessage]
		}
	}
}
