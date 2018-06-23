//
//  Chat.swift
//  GroupMac
//
//  Created by Will Tyler on 6/23/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension GroupMe {
	class Chat: Decodable, Conversation {
		let createdAt: Int
		let updatedAt: Int
		let messageCount: Int
		let otherUser: OtherUser

		var name: String {
			get {
				return otherUser.name
			}
		}

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

		var messages: [GroupMe.ChatMessage] {
			get {
				let components: URLComponents = {
					let url = GroupMe.baseURL.appendingPathComponent("/direct_messages")
					var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!

					comps.queryItems = [
						URLQueryItem(name: "token", value: GroupMe.accessToken),
						URLQueryItem(name: "other_user_id", value: otherUser.id)
					]

					return comps
				}()
				let request: URLRequest = {
					var request = URLRequest(url: components.url!)

					request.httpMethod = HTTP.RequestMethod.get.rawValue

					return request
				}()

				let results = HTTP.syncRequest(request: request)

				guard results.error == nil else {
					print(results.error!)

					return []
				}
				guard let data = results.data else {
					print("Received nil data...")

					return []
				}

				let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]

				let countAndMessages = json["response"] as! [String: Any]

				let messages: [GroupMe.ChatMessage] = {
					let data = try! JSONSerialization.data(withJSONObject: countAndMessages["direct_messages"]!)

					return try! JSONDecoder().decode([GroupMe.ChatMessage].self, from: data)
				}()

				return messages
			}
		}

		static var chats: [Chat] {
			get {
				let components: URLComponents = {
					let url = GroupMe.baseURL.appendingPathComponent("/chats")
					var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!

					comps.queryItems = [URLQueryItem(name: "token", value: GroupMe.accessToken)]

					return comps
				}()
				let request: URLRequest = {
					var request = URLRequest(url: components.url!)

					request.httpMethod = HTTP.RequestMethod.get.rawValue

					return request
				}()

				let results = HTTP.syncRequest(request: request)

				guard results.error == nil else {
					print(results.error!)

					return []
				}
				guard let data = results.data else {
					print("Received nil data...")

					return []
				}

				let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]

				let chats: [Chat] = {
					let data = try! JSONSerialization.data(withJSONObject: json["response"]!)

					return try! JSONDecoder().decode([Chat].self, from: data)
				}()

				return chats
			}
		}
	}
}

extension GroupMe.Chat {
	class OtherUser: Decodable {
		let avatarURL: URL?
		let id: String
		let name: String

		private enum CodingKeys: String, CodingKey {
			case avatarURL = "avatar_url"
			case id
			case name
		}
	}
}
