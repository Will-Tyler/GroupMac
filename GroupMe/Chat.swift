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
		
		@discardableResult
		func handleMessages(with handler: @escaping ([Chat.Message])->(), beforeID: String? = nil) -> URLSessionDataTask {
			var params = ["other_user_id": otherUser.id]

			if let before = beforeID {
				params["before_id"] = before
			}

			let runningTask = GroupMe.betterAPIRequest(appendingPathComponent: "direct_messages", additionalParameters: params) { (response: APIResponse) in
				guard response.meta.code == 200 else { return }

				let countAndMessages = try! JSONSerialization.jsonObject(with: response.contentData) as! [String: Any]
				let messageData = try! JSONSerialization.data(withJSONObject: countAndMessages["direct_messages"]!)
				let messages = try! JSONDecoder().decode([Chat.Message].self, from: messageData)

				handler(messages)
			}

			return runningTask
		}

		func handlePreviewText(with handler: @escaping (String)->Void) {
			GroupMe.betterAPIRequest(appendingPathComponent: "/direct_messages", additionalParameters: ["other_user_id": otherUser.id]) { (response: APIResponse) in
				guard response.meta.code == 200 else {
					return
				}

				let json = try! JSONSerialization.jsonObject(with: response.contentData) as! [String: Any]
				let jsonMessages = json["direct_messages"]!
				let data = try! JSONSerialization.data(withJSONObject: jsonMessages)
				let messages = try! JSONDecoder().decode([GroupMe.Chat.Message].self, from: data)

				if let text = messages.first!.text {
					handler(text)
				}
			}
		}

		private static var GUIDcount = 1
		func sendMessage(text: String, successHandler: @escaping ()->() = {}) {
			guard !text.isEmpty else { return }
			guard text.count <= 1000 else { print("Message is too long, quitting..."); return }

			let jsonDict = ["direct_message": ["source_guid": "\(GroupMe.Chat.GUIDcount++)", "recipient_id": otherUser.id, "text": text]]

			GroupMe.betterAPIRequest(method: .post, appendingPathComponent: "/direct_messages", jsonObject: jsonDict) { (response: APIResponse) in
				if response.meta.code == 201 { successHandler() }
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

		let attachments: [GroupMe.Attachment]
		let avatarURL: URL?
		let chatID: String
		let createdAt: Int
		let favoritedBy: [String]
		let id: String
		let name: String
		let recipientID: String
		let senderID: String
		let senderType: String
		let sourceGUID: String
		let text: String?
		let userID: String

		required init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)

			self.attachments = try values.decode([GroupMe.Attachment].self, forKey: .attachments)
			self.avatarURL = try values.decode(URL?.self, forKey: .avatarURL)
			self.chatID = try values.decode(String.self, forKey: .chatID)
			self.createdAt = try values.decode(Int.self, forKey: .createdAt)
			self.favoritedBy = try values.decode([String].self, forKey: .favoritedBy)
			self.id = try values.decode(String.self, forKey: .id)
			self.name = try values.decode(String.self, forKey: .name)
			self.recipientID = try values.decode(String.self, forKey: .recipientID)
			self.senderID = try values.decode(String.self, forKey: .senderID)
			self.senderType = try values.decode(String.self, forKey: .senderType)
			self.sourceGUID = try values.decode(String.self, forKey: .sourceGUID)
			self.text = try values.decode(String?.self, forKey: .text)
			self.userID = try values.decode(String.self, forKey: .userID)
		}

//		private init(id: String, sourceGUID: String, recipientID: String, userID: String, createdAt: Int, name: String, avatarURL: URL?, text: String?, favoritedBy: [String]) {
//			self.id = id
//			self.sourceGUID = sourceGUID
//			self.recipientID = recipientID
//			self.userID = userID
//			self.createdAt = createdAt
//			self.name = name
//			self.avatarURL = avatarURL
//			self.text = text
//			self.favoritedBy = favoritedBy
//		}

		private enum CodingKeys: String, CodingKey {
			case attachments
			case avatarURL = "avatar_url"
			case chatID = "conversation_id"
			case createdAt = "created_at"
			case favoritedBy = "favorited_by"
			case id
			case name
			case recipientID = "recipient_id"
			case senderID = "sender_id"
			case senderType = "sender_type"
			case sourceGUID = "source_guid"
			case text
			case userID = "user_id"
		}

		func like(successHandler: @escaping ()->() = {}) {
			GroupMe.betterAPIRequest(method: .post, appendingPathComponent: "/messages/\(chatID)/\(id)/like") { (response: GroupMe.APIResponse) in
				if response.meta.code == 200 { successHandler() }
			}
		}
		func unlike(successHandler: @escaping ()->() = {}) {
			GroupMe.betterAPIRequest(method: .post, appendingPathComponent: "/messages/\(chatID)/\(id)/unlike") { (response: GroupMe.APIResponse) in
				if response.meta.code == 200 { successHandler() }
			}
		}

	}

}


































































