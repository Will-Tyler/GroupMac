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

	static var me: Me {
		get {
			let responseData = try! GroupMe.apiRequest(pathComponent: "/users/me")

			return try! JSONDecoder().decode(Me.self, from: responseData)
		}
	}
}
