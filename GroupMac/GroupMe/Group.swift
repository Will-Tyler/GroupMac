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
		let phoneNumber: String?
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
		let messagesInfo: Group.MessagesInfo
		let maxMembers: Int

		private init(id: String, name: String, phoneNumber: String?, type: String, description: String, imageURL: URL?, creatorUserID: String, createdAt: Int, updatedAt: Int, officeMode: Bool, shareURL: URL?, shareQRCodeURL: URL?, members: [Group.Member], messagesInfo: MessagesInfo, maxMembers: Int) {
			self.id = id
			self.name = name
			self.phoneNumber = phoneNumber
			self.type = type
			self.description = description
			self.imageURL = imageURL
			self.creatorUserID = creatorUserID
			self.createdAt = createdAt
			self.updatedAt = updatedAt
			self.officeMode = officeMode
			self.shareURL = shareURL
			self.shareQRCodeURL = shareQRCodeURL
			self.members = members
			self.messagesInfo = messagesInfo
			self.maxMembers = maxMembers
		}

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
			case messagesInfo = "messages"
			case maxMembers = "max_members"
		}

		var messages: [GroupMe.Group.Message] {
			get {
				let responseData = try! GroupMe.apiRequestReceivingData(pathComponent: "/groups/\(id)/messages", additionalParameters: ["limit": "100"])
				let countAndMessages = try! JSONSerialization.jsonObject(with: responseData) as! [String: Any]

				let messages: [Group.Message] = {
					let data = try! JSONSerialization.data(withJSONObject: countAndMessages["messages"]!)

					return try! JSONDecoder().decode([Group.Message].self, from: data)
				}()

				return messages
			}
		}

		func update(name: String? = nil, description: String? = nil, imageURL: URL? = nil, officeMode: Bool? = nil, share: Bool? = nil) -> Group? {
			if name == nil, description == nil, imageURL == nil, officeMode == nil, share == nil { return nil }

			let jsonDict: [String: Any] = {
				var dict: [String: Any] = [:]

				if let name = name {
					dict["name"] = name
				}
				if let desc = description {
					dict["description"] = desc
				}
				if let imageURL = imageURL {
					dict["image_url"] = imageURL.absoluteString
				}
				if let office = officeMode {
					dict["office_mode"] = office
				}
				if let share = share {
					dict["share"] = share
				}

				return dict
			}()
			let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict)

			let responseData = try! GroupMe.apiRequestReceivingData(pathComponent: "/groups/\(id)/update", requestMethod: .post, httpBody: jsonData)
			let group = try! JSONDecoder().decode(Group.self, from: responseData)

			return group
		}

		func destroy() {
			GroupMe.apiRequest(pathComponent: "/groups/\(id)/destroy")
		}

		static func show(id: String) -> Group {
			let responseData = try! GroupMe.apiRequestReceivingData(pathComponent: "/groups/\(id)")
			let group = try! JSONDecoder().decode(Group.self, from: responseData)

			return group
		}

		static func create(name: String, description: String? = nil, imageURL: URL? = nil, share: Bool = false) -> Group {
			let jsonDict: [String: Any] = {
				var dict: [String: Any] = ["name": name, "share": share]

				if let desc = description {
					dict["description"] = desc
				}
				if let imageURL = imageURL {
					dict["image_url"] = imageURL.absoluteString
				}

				return dict
			}()
			let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict)

			let responseData = try! GroupMe.apiRequestReceivingData(pathComponent: "/groups", requestMethod: .post, httpBody: jsonData)
			let group = try! JSONDecoder().decode(Group.self, from: responseData)

			return group
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
		let preview: Preview

		private init(count: Int, lastMessageID: String, lastMessageCreatedAt: Int, preview: Preview) {
			self.count = count
			self.lastMessageID = lastMessageID
			self.lastMessageCreatedAt = lastMessageCreatedAt
			self.preview = preview
		}

		private enum CodingKeys: String, CodingKey {
			case count
			case lastMessageID = "last_message_id"
			case lastMessageCreatedAt = "last_message_created_at"
			case preview
		}

		class Preview: Decodable {
			let nickname: String
			let text: String?
			let imageURL: String?

			private init(nickname: String, text: String?, imageURL: String?) {
				self.nickname = nickname
				self.text = text
				self.imageURL = imageURL
			}

			private enum CodingKeys: String, CodingKey {
				case nickname
				case text
				case imageURL = "image_url"
			}
		}
	}
}
