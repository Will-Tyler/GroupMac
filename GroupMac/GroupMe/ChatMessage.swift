//
//  ChatMessage.swift
//  GroupMac
//
//  Created by Will Tyler on 6/23/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension GroupMe {
	class ChatMessage: Decodable {
		let id: String
		let sourceGUID: String
		let recipientID: String
		let userID: String
		let createdAt: Int
		let name: String
		let avatarURL: URL?
		let text: String?
		let favoritedBy: [String]

		private init(id: String, sourceGUID: String, recipientID: String, userID: String, createdAt: Int, name: String, avatarURL: URL?, text: String?, favoritedBy: [String]) {
			self.id = id
			self.sourceGUID = sourceGUID
			self.recipientID = recipientID
			self.userID = userID
			self.createdAt = createdAt
			self.name = name
			self.avatarURL = avatarURL
			self.text = text
			self.favoritedBy = favoritedBy
		}

		private enum CodingKeys: String, CodingKey {
			case id
			case sourceGUID = "source_guid"
			case recipientID = "recipient_id"
			case userID = "user_id"
			case createdAt = "created_at"
			case name
			case avatarURL = "avatar_url"
			case text
			case favoritedBy = "favorited_by"
		}
	}
}
