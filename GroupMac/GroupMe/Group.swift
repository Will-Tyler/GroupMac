//
//  Group.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension GroupMe {
	class Group: Decodable {
		let id: String
		let name: String
		let phoneNumber: String
		let type: String
		let description: String
		let imageURL: URL?
		let creatorUserID: String
		let createdAt: Int
		let updatedAt: Int
		let officeMode: Bool
		let shareURL: URL?
		let shareQRCodeURL: URL?
		let members: [Group.Member]
		let messageInfo: Group.MessagesInfo
		let maxMembers: Int

		private enum CodingKeys: String, CodingKey {
			case id
			case name
			case phoneNumber = "phone_number"
			case type
			case description
			case imageURL = "image_url"
			case creatorUserID = "creator_user_id"
			case createdAt = "created_at"
			case updatedAt = "updated_at"
			case officeMode = "office_mode"
			case shareURL = "share_url"
			case shareQRCodeURL = "share_qr_code_url"
			case members
			case messageInfo = "messages"
			case maxMembers = "max_members"
		}

		var messages: [GroupMe.Group.Message] {
			get {
				let components: URLComponents = {
					let url = GroupMe.baseURL.appendingPathComponent("/groups/\(id)/messages")
					var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!

					comps.queryItems = [URLQueryItem(name: "token", value: GroupMe.accessToken), URLQueryItem(name: "limit", value: "100")]

					return comps
				}()
				let request: URLRequest = {
					var request = URLRequest(url: components.url!)
					request.httpMethod = HTTP.RequestMethod.get.rawValue

					return request
				}()

				let results: HTTP.Response = HTTP.syncRequest(request: request)

				guard results.error == nil else {
					print(results.error!)

					return []
				}

				let json = try! JSONSerialization.jsonObject(with: results.data!) as! [String: Any]

				let countAndMessages = json["response"] as! [String: Any]

				let messages: [Group.Message] = {
					let data = try! JSONSerialization.data(withJSONObject: countAndMessages["messages"]!)

					return try! JSONDecoder().decode([Group.Message].self, from: data)
				}()

				return messages
			}
		}

		static var groups: [Group] {
			get {
				let components: URLComponents = {
					let url = GroupMe.baseURL.appendingPathComponent("/groups")
					var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!

					comps.queryItems = [URLQueryItem(name: "token", value: GroupMe.accessToken)]

					return comps
				}()
				let request: URLRequest = {
					var request = URLRequest(url: components.url!)
					request.httpMethod = HTTP.RequestMethod.get.rawValue

					return request
				}()

				let results: HTTP.Response = HTTP.syncRequest(request: request)

				guard results.error == nil else {
					print(results.error!)

					return []
				}

				let json = try! JSONSerialization.jsonObject(with: results.data!) as! [String: Any]

				let groups: [Group] = {
					let data = try! JSONSerialization.data(withJSONObject: json["response"]!)

					return try! JSONDecoder().decode([Group].self, from: data)
				}()

				return groups
			}
		}
	}
}

extension GroupMe.Group {
	class Message: Decodable {
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

extension GroupMe.Group {
	class MessagesInfo: Decodable {
		let count: Int
		let lastMessageID: String
		let lastMessageCreatedAt: Int
//		let preview: Preview?

		private init(count: Int, lastMessageID: String, lastMessageCreatedAt: Int) {
			self.count = count
			self.lastMessageID = lastMessageID
			self.lastMessageCreatedAt = lastMessageCreatedAt
		}

		private enum CodingKeys: String, CodingKey {
			case count
			case lastMessageID = "last_message_id"
			case lastMessageCreatedAt = "last_message_created_at"
//			case preview
		}

//		class Preview: Decodable {
//			let nickname: String
//			let text: String
//			let imageURL: URL?
//
//			enum CodingKeys: String, CodingKey {
//				case nickname
//				case text = "text"
//				case imageURL = "image_url"
//			}
//		}
	}
}
