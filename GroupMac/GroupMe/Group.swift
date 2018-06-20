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
		let messageInfo: Group.MessageInfo
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

extension GroupMe.Group {
	var messages: [GroupMe.Message] {
		get {
			return [GroupMe.Message]()
		}
	}
}
