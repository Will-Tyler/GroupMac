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

		var messages: [GroupMe.Message] {
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

					return [GroupMe.Message]()
				}

				let json = try! JSONSerialization.jsonObject(with: results.data!) as! [String: Any]

				let countAndMessages = json["response"] as! [String: Any]

				let messages: [GroupMe.Message] = {
					let data = try! JSONSerialization.data(withJSONObject: countAndMessages["messages"]!)

					return try! JSONDecoder().decode([GroupMe.Message].self, from: data)
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
