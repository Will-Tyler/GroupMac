//
//  Chat.swift
//  GroupMac
//
//  Created by Will Tyler on 6/23/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension GroupMe {
	class Chat: Decodable {
		let createdAt: Int
		let updatedAt: Int
		let messageCount: Int
		let otherUser: OtherUser

//		private init(createdAt: Int, updatedAt: Int, messageCount: Int, otherUser: OtherUser) {
//			self.createdAt = createdAt
//			self.updatedAt = updatedAt
//			self.messageCount = messageCount
//			self.otherUser = otherUser
//		}

		private enum CodingKeys: String, CodingKey {
			case createdAt = "created_at"
			case updatedAt = "updated_at"
			case messageCount = "messages_count"
			case otherUser = "other_user"
		}
	}
}

extension GroupMe.Chat {
	class OtherUser: Decodable {
		let avatarURL: URL?
		let id: Int
		let name: String

		private enum CodingKeys: String, CodingKey {
			case avatarURL = "avatar_url"
			case id
			case name
		}
	}
}
