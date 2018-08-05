//
//  Group.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation

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

extension GroupMe.Group {

	class Member: Decodable {

		let userID: String
		let nickname: String
		let imageURL: URL?
		let id: String
		let isMuted: Bool
		let isAutokicked: Bool
		let roles: [String]

		private init(userID: String, nickname: String, imageURL: URL?, id: String, isMuted: Bool, isAutokicked: Bool, roles: [String]) {
			self.userID = userID
			self.nickname = nickname
			self.imageURL = imageURL
			self.id = id
			self.isMuted = isMuted
			self.isAutokicked = isAutokicked
			self.roles = roles
		}

		private enum CodingKeys: String, CodingKey {
			case userID = "user_id"
			case nickname
			case imageURL = "image_url"
			case id
			case isMuted = "muted"
			case isAutokicked = "autokicked"
			case roles
		}

	}

}

extension GroupMe.Group {

	private static var GUIDcount = 1

	func sendMessage(text: String, successHandler: @escaping ()->() = {}) {
		guard !text.isEmpty else { return }
		guard text.count <= 1000 else { print("Message is too long, quitting..."); return }

		let jsonDict = ["message": ["source_guid": "\(GroupMe.Group.GUIDcount++)", "text": text]]

		GroupMe.betterAPIRequest(method: .post, appendingPathComponent: "/groups/\(id)/messages", jsonObject: jsonDict) { (response: GroupMe.APIResponse) in
			if response.meta.code == 201 { successHandler() }
		}
	}

}







































































