//
//  Message.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension GroupMe {
	class GroupMessage: Decodable, Message {
		let avatarURL: URL?
		let createdAt: Int
		let favoritedBy: [String]
		let groupID: String
		let id: String
		let name: String
		let senderID: String
		let senderType: String
		let sourceGUID: String
		let isSystem: Bool
		let text: String?
		let userID: String

		private init(avatarURL: URL?, createdAt: Int, favoritedBy: [String], groupID: String, id: String, name: String, senderID: String, senderType: String, sourceGUID: String, isSystem: Bool, text: String?, userID: String) {
			self.avatarURL = avatarURL
			self.createdAt = createdAt
			self.favoritedBy = favoritedBy
			self.groupID = groupID
			self.id = id
			self.name = name
			self.senderID = senderID
			self.senderType = senderType
			self.sourceGUID = sourceGUID
			self.isSystem = isSystem
			self.text = text
			self.userID = userID
		}

		private enum CodingKeys: String, CodingKey {
			case avatarURL = "avatar_url"
			case createdAt = "created_at"
			case favoritedBy = "favorited_by"
			case groupID = "group_id"
			case id
			case name
			case senderID = "sender_id"
			case senderType = "sender_type"
			case sourceGUID = "source_guid"
			case isSystem = "system"
			case text
			case userID = "user_id"
		}
	}
}
