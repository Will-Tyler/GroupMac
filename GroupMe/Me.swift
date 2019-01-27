//
//  Me.swift
//  GroupMac
//
//  Created by Will Tyler on 7/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension GroupMe {

	class Me: Decodable {

		let id: String
		let phoneNumber: String
		let imageURL: URL?
		let name: String
		let createdAt: Int
		let updatedAt: Int
		let email: String
		let isSMS: Bool

		private enum CodingKeys: String, CodingKey {
			case id
			case phoneNumber = "phone_number"
			case imageURL = "image_url"
			case name
			case createdAt = "created_at"
			case updatedAt = "updated_at"
			case email
			case isSMS = "sms"
		}

	}

	private static var loadedMe: Me?

	static var me: Me {
		get {
			if loadedMe != nil {
				return loadedMe!
			}
			else {
				let semaphore = DispatchSemaphore(value: 0)

				handleMe(with: { me in
					loadedMe = me
					semaphore.signal()
				})

				semaphore.wait()

				return loadedMe!
			}
		}
	}

	static func handleMe(with handler: @escaping (Me)->()) {
		GroupMe.betterAPIRequest(appendingPathComponent: "/users/me", apiResponseHandler: { apiResponse in
			guard apiResponse.meta.code == 200 else {
				return
			}

			let me = try! JSONDecoder().decode(Me.self, from: apiResponse.contentData!)

			handler(me)
		})
	}

}
