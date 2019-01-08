//
//  GroupMe.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation
import SocketRocket


class GroupMe {

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
		let members: [GroupMe.Group.Member]
		let messagesInfo: GroupMe.Group.MessagesInfo
		let maxMembers: Int

//		private init(id: String, name: String, phoneNumber: String?, type: String, description: String, imageURL: URL?, creatorUserID: String, createdAt: Int, updatedAt: Int, officeMode: Bool, shareURL: URL?, shareQRCodeURL: URL?, members: [Group.Member], messagesInfo: MessagesInfo, maxMembers: Int) {
//			self.id = id
//			self.name = name
//			self.phoneNumber = phoneNumber
//			self.type = type
//			self.description = description
//			self.imageURL = imageURL
//			self.creatorUserID = creatorUserID
//			self.createdAt = createdAt
//			self.updatedAt = updatedAt
//			self.officeMode = officeMode
//			self.shareURL = shareURL
//			self.shareQRCodeURL = shareQRCodeURL
//			self.members = members
//			self.messagesInfo = messagesInfo
//			self.maxMembers = maxMembers
//		}

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

		@discardableResult
		func handleMessages(with handler: @escaping ([Group.Message])->(), beforeID: String? = nil) -> URLSessionDataTask {
			return GroupMe.betterAPIRequest(appendingPathComponent: "/groups/\(id)/messages", additionalParameters: beforeID == nil ? nil : ["before_id": beforeID!]) { (response: APIResponse) in
				guard response.meta.code == 200 else { return }

				let countAndMessages = try! JSONSerialization.jsonObject(with: response.contentData) as! [String: Any]
				let messageData = try! JSONSerialization.data(withJSONObject: countAndMessages["messages"]!)
				let messages = try! JSONDecoder().decode([Group.Message].self, from: messageData)

				handler(messages)
			}
		}

		func destroy() {
			GroupMe.apiContact(pathComponent: "/groups/\(id)/destroy")
		}

		class Message: Decodable {

			let attachments: [Attachment]
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

//			private init(attachments: [[String: Data]], avatarURL: URL?, createdAt: Int, favoritedBy: [String], groupID: String, id: String, name: String, senderID: String, senderType: String, sourceGUID: String, isSystem: Bool, text: String?, userID: String) {
//				self.attachments = attachments
//				self.avatarURL = avatarURL
//				self.createdAt = createdAt
//				self.favoritedBy = favoritedBy
//				self.groupID = groupID
//				self.id = id
//				self.name = name
//				self.senderID = senderID
//				self.senderType = senderType
//				self.sourceGUID = sourceGUID
//				self.isSystem = isSystem
//				self.text = text
//				self.userID = userID
//			}

			required init(from decoder: Decoder) throws {
				let values = try decoder.container(keyedBy: CodingKeys.self)

				self.attachments = try values.decode([Attachment].self, forKey: .attachments)
				self.avatarURL = try values.decode(URL?.self, forKey: .avatarURL)
				self.createdAt = try values.decode(Int.self, forKey: .createdAt)
				self.favoritedBy = try values.decode([String].self, forKey: .favoritedBy)
				self.groupID = try values.decode(String.self, forKey: .groupID)
				self.id = try values.decode(String.self, forKey: .id)
				self.name = try values.decode(String.self, forKey: .name)
				self.senderID = try values.decode(String.self, forKey: .senderID)
				self.senderType = try values.decode(String.self, forKey: .senderType)
				self.sourceGUID = try values.decode(String.self, forKey: .sourceGUID)
				self.isSystem = try values.decode(Bool.self, forKey: .isSystem)
				self.text = try values.decode(String?.self, forKey: .text)
				self.userID = try values.decode(String.self, forKey: .userID)
			}

			private enum CodingKeys: String, CodingKey {
				case attachments
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

			func like(successHandler: @escaping ()->()) {
				GroupMe.betterAPIRequest(method: .post, appendingPathComponent: "/messages/\(groupID)/\(id)/like") { (response: APIResponse) in
					if response.meta.code == 200 { successHandler() }
				}
			}
			func unlike(successHandler: @escaping ()->()) {
				GroupMe.betterAPIRequest(method: .post, appendingPathComponent: "/messages/\(groupID)/\(id)/unlike") { (response: APIResponse) in
					if response.meta.code == 200 { successHandler() }
				}
			}

		}

	}

	static let baseURL: URL = URL(string: "https://api.groupme.com/v3")!
	static let accessToken: String = {
		let path = Bundle.main.path(forResource: "token", ofType: "txt")!
		let token = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)

		return token
	}()

	static func responseCode(from data: Data) -> Int {
		let response = try! APIResponse(from: data)

		return response.meta.code
	}
	static func apiContact(pathComponent: String, requestMethod: HTTP.RequestMethod = .post) {
		let request = URLRequest(url: baseURL.appendingPathComponent(pathComponent))

		URLSession.shared.dataTask(with: request)
	}
	@discardableResult
	static func betterAPIRequest(method: HTTP.RequestMethod = .get, appendingPathComponent extraPath: String, additionalParameters extraParams: [String: String]? = nil, jsonObject: Any? = nil, apiResponseHandler: @escaping (GroupMe.APIResponse)->()) -> URLSessionDataTask {
		let components: URLComponents = {
			let url = baseURL.appendingPathComponent(extraPath)
			var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
			let params: [String: String] = {
				var params = ["token": accessToken]

				if let extraParams = extraParams {
					extraParams.forEach({ params[$0.key] = $0.value })
				}

				return params
			}()

			comps.queryItems = params.map({ return URLQueryItem(name: $0.key, value: $0.value) })

			return comps
		}()

		print(method.rawValue, components.url!)

		let request: URLRequest = {
			var req = URLRequest(url: components.url!)

			req.httpMethod = method.rawValue
			if let jsonObject = jsonObject {
				if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject) {
					req.setValue("application/json", forHTTPHeaderField: "Content-Type")
					req.httpBody = jsonData
				}
			}

			return req
		}()
		let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
			guard error == nil, let data = data, !data.isEmpty else { return }
			let response = try! APIResponse(from: data)

			apiResponseHandler(response)
		}

		task.resume()

		return task
	}

	static func handleGroups(with handler: @escaping ([GroupMe.Group])->()) {
		GroupMe.betterAPIRequest(appendingPathComponent: "/groups", apiResponseHandler: { apiResponse in
			var groups = try! JSONDecoder().decode([Group].self, from: apiResponse.contentData)

			groups.sort(by: { $0.updatedAt > $1.updatedAt })
			handler(groups)
		})
	}

	static func handleChats(with handler: @escaping ([GroupMe.Chat])->()) {
		GroupMe.betterAPIRequest(appendingPathComponent: "/chats", apiResponseHandler: { apiResponse in
			var chats = try! JSONDecoder().decode([Chat].self, from: apiResponse.contentData)

			chats.sort(by: { $0.updatedAt > $1.updatedAt })
			handler(chats)
		})
	}

	private static var clientID = 1
	static let notificationSocket: SRWebSocket = {
		print("Creating notification socket...")
		defer {
			print("Finished setting up socket...")
		}

		let handshake = [
			[
				"channel": "/meta/handshake",
				"version": "1.0",
				"supportedConnectionTypes": ["long-polling"],
				"id": "\(clientID++)"
			]
		]
		let handshakeData = try! JSONSerialization.data(withJSONObject: handshake)
		let url = URL(string: "https://push.groupme.com/faye")!
		let request: URLRequest = {
			var req = URLRequest(url: url)

			req.setValue("application/json", forHTTPHeaderField: "Content-Type")
			req.httpMethod = HTTP.RequestMethod.post.rawValue
			req.httpBody = handshakeData

			return req
		}()

		let results = HTTP.syncRequest(request: request)

		guard results.error == nil, let data = results.data, !data.isEmpty else {
			fatalError()
		}

		return SRWebSocket()
	}()

}
