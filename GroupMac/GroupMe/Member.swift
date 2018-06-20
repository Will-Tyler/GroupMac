//
//  Member.swift
//  GroupMac
//
//  Created by Will Tyler on 6/20/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


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
