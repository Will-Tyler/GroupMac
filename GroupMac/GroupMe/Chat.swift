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
	func handlePreviewText(with handler: @escaping (String)->Void) {
		let parameters = ["token": GroupMe.accessToken, "other_user_id": otherUser.id]
		let components: URLComponents = {
			let url = GroupMe.baseURL.appendingPathComponent("/direct_messages")
			var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!

			comps.queryItems = parameters.map({ return URLQueryItem(name: $0.key, value: $0.value) })

			return comps
		}()

//		print(components.url!)

		let request: URLRequest = {
			var request = URLRequest(url: components.url!)

			request.httpMethod = HTTP.RequestMethod.get.rawValue

			return request
		}()

		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error == nil, let data = data {
				let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
				let responseCode = (json["meta"] as! [String: Int])["code"]

				if responseCode == 200 {
					let jsonMessages = (json["response"] as! [String: Any])["direct_messages"]!
					let data = try! JSONSerialization.data(withJSONObject: jsonMessages)
					let messages = try! JSONDecoder().decode([GroupMe.Chat.Message].self, from: data)
					
					if let text = messages.first!.text {
						handler(text)
					}
				}
			}
		}.resume()
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
		let attachments: [[String: String]]?
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

			self.attachments = try? values.decode([[String: String]].self, forKey: .attachments)
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
	}
}
