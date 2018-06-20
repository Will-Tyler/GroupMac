//
//  GroupMe.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Cocoa


class GroupMe {

	private static let baseURL: URL = URL(string: "https://api.groupme.com/v3")!
	private static let accessToken: String = {
		let path = Bundle.main.path(forResource: "token", ofType: "txt")!
		let token = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)

		print("Access Token: \"\(token)\"")

		return token
	}()

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
		let members: [Member]
		let messageInfo: MessageInfo
		let maxMembers: Int

		enum CodingKeys: String, CodingKey {
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

		class MessageInfo: Decodable {
			let count: Int
			let lastMessageID: String
			let lastMessageCreatedAt: Int
//			let preview: Preview?

			init(count: Int, lastMessageID: String, lastMessageCreatedAt: Int) {
				self.count = count
				self.lastMessageID = lastMessageID
				self.lastMessageCreatedAt = lastMessageCreatedAt
			}

			enum CodingKeys: String, CodingKey {
				case count
				case lastMessageID = "last_message_id"
				case lastMessageCreatedAt = "last_message_created_at"
//				case preview
			}

//			class Preview: Decodable {
//				let nickname: String
//				let text: String
//				let imageURL: URL?
//
//				enum CodingKeys: String, CodingKey {
//					case nickname
//					case text = "text"
//					case imageURL = "image_url"
//				}
//			}
		}

		class Member: Decodable {
			let userID: String
			let nickname: String
			let imageURL: URL?
			let id: String
			let isMuted: Bool
			let isAutokicked: Bool
			let roles: [String]

			init(userID: String, nickname: String, imageURL: URL?, id: String, isMuted: Bool, isAutokicked: Bool, roles: [String]) {
				self.userID = userID
				self.nickname = nickname
				self.imageURL = imageURL
				self.id = id
				self.isMuted = isMuted
				self.isAutokicked = isAutokicked
				self.roles = roles
			}

			enum CodingKeys: String, CodingKey {
				case userID = "user_id"
				case nickname
				case imageURL = "image_url"
				case id
				case isMuted = "muted"
				case isAutokicked = "autokicked"
				case roles
			}
		}

		static var groups: [Group] {
			get {
				let url = URL(string: baseURL.absoluteString + "/groups?token=" + accessToken)!
				let request: URLRequest = {
					var request = URLRequest(url: url)
					request.httpMethod = HTTPRequestMethod.get.rawValue

					return request
				}()

				let results: HTTP.Response = HTTP.syncRequest(request: request)

				guard results.error == nil else {
					print(results.error!)

					return [Group]()
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
