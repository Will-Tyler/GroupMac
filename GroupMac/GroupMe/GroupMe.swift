//
//  GroupMe.swift
//  GroupMac
//
//  Created by Will Tyler on 6/18/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


class GroupMe {

	static let baseURL: URL = URL(string: "https://api.groupme.com/v3")!
	static let accessToken: String = {
		let path = Bundle.main.path(forResource: "token", ofType: "txt")!
		let token = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)

		print("Access Token: \"\(token)\"")

		return token
	}()

	static func apiRequest(pathComponent: String, requestMethod: HTTP.RequestMethod = .post) {
		let request = URLRequest(url: baseURL.appendingPathComponent(pathComponent))
		URLSession.shared.dataTask(with: request)
	}
	static func apiRequestReceivingData(pathComponent: String, additionalParameters: [String: String] = ["token": accessToken], requestMethod: HTTP.RequestMethod = .get, httpBody: Data? = nil) throws -> Data {
		let components: URLComponents = {
			let url = baseURL.appendingPathComponent(pathComponent)
			var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
			var params = additionalParameters
			
			params["token"] = accessToken
			comps.queryItems = params.map({ return URLQueryItem(name: $0.key, value: $0.value) })

			return comps
		}()
		let request: URLRequest = {
			var request = URLRequest(url: components.url!)

			request.httpMethod = requestMethod.rawValue
			if let body = httpBody {
				request.httpBody = body
			}

			return request
		}()

		let results = HTTP.syncRequest(request: request)

		guard results.error == nil else {
			throw results.error!
		}
		guard let data = results.data else {
			throw "Received nil data..."
		}

		let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
		let responseCode = (json["meta"] as! [String: Int])["code"]

		guard responseCode == 200 else {
			throw "Non-200 HTTP response code: \(responseCode ?? 0)"
		}

		return try JSONSerialization.data(withJSONObject: json["response"]!)
	}

	static var groups: [Group] {
		get {
			let data = try! apiRequestReceivingData(pathComponent: "/groups")
			let groups: [Group] = try! JSONDecoder().decode([Group].self, from: data)

			return groups
		}
	}

	static var formerGroups: [Group] {
		get {
			let responseData = try! apiRequestReceivingData(pathComponent: "/groups/former")
			let formerGroups = try! JSONDecoder().decode([Group].self, from: responseData)

			return formerGroups
		}
	}

	static var chats: [Chat] {
		get {
			let responseData = try! apiRequestReceivingData(pathComponent: "/chats")
			let chats: [Chat] = try! JSONDecoder().decode([Chat].self, from: responseData)

			return chats
		}
	}

}
