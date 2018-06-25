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

		private init(createdAt: Int, updatedAt: Int, messageCount: Int, otherUser: OtherUser) {
			self.createdAt = createdAt
			self.updatedAt = updatedAt
			self.messageCount = messageCount
			self.otherUser = otherUser
		}

		private enum CodingKeys: String, CodingKey {
			case createdAt = "created_at"
			case updatedAt = "updated_at"
			case messageCount = "messages_count"
			case otherUser = "other_user"
		}

		var messages: [Chat.Message] {
			get {
				let params = ["other_user_id": otherUser.id]
				let responseData = try! GroupMe.apiRequest(pathComponent: "/direct_messages", additionalParameters: params)
				let countAndMessages = try! JSONSerialization.jsonObject(with: responseData) as! [String: Any]

				let messages: [Chat.Message] = {
					let data = try! JSONSerialization.data(withJSONObject: countAndMessages["direct_messages"]!)

					return try! JSONDecoder().decode([Chat.Message].self, from: data)
				}()

				return messages
			}
		}
	}
}

extension GroupMe.Chat {
	class OtherUser: Decodable {
		let avatarURL: URL?
		let id: String
		let name: String

		private init (avatarURL: URL?, id: String, name: String) {
			self.avatarURL = avatarURL
			self.id = id
			self.name = name
		}

		private enum CodingKeys: String, CodingKey {
			case avatarURL = "avatar_url"
			case id
			case name
		}
	}
}

extension GroupMe.Chat {
	class Message: Decodable {
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
