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

		return token
	}()

	static var groups: [String] {
		get {
			let url = URL(string: baseURL.absoluteString + "/groups?token=" + accessToken)!
			let request: URLRequest = {
				var request = URLRequest(url: url)
				request.httpMethod = "GET"

				return request
			}()

			let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
				guard error == nil else {
					print(error!)

					return
				}

				guard let data = data else {
					fatalError("No data.")
				}

				let dataDict = try! JSONSerialization.jsonObject(with: data) as! [String: Any]

				for item in dataDict {
					print(item)
				}
			}
			task.resume()

			return [String]()
		}
	}

}
