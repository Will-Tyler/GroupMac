//
//  MessageInfo.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation

extension GroupMe.Group {
	class MessageInfo: Decodable {
		let count: Int
		let lastMessageID: String
		let lastMessageCreatedAt: Int
//		let preview: Preview?

		init(count: Int, lastMessageID: String, lastMessageCreatedAt: Int) {
			self.count = count
			self.lastMessageID = lastMessageID
			self.lastMessageCreatedAt = lastMessageCreatedAt
		}

		enum CodingKeys: String, CodingKey {
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
