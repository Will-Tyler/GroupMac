//
//  Attachments.swift
//  GroupMac
//
//  Created by Will Tyler on 7/14/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation

extension GroupMe {
	class Attachment: Decodable {

		let contentType: ContentType

		init(from decoder: Decoder) throws {
			let values = try! decoder.container(keyedBy: CodingKeys.self)

			let contentString = try! values.decode(String.self, forKey: .contentType)

			self.contentType = ContentType(rawValue: contentString) ?? .notSupported

			if self.contentType == .image {
				self = try Image.init(from: decoder)
			}
		}

		enum ContentType: String {
			case image
			case location
			case split
			case emoji
			case notSupported
		}

		private enum CodingKeys: String, CodingKey {
			case contentType = "type"
		}

		class Image: Attachment {
			let url: URL

			init(from decoder: Decoder) throws {
				let values = try! decoder.container(keyedBy: AdditionalKeys.self)

				self.url = try! values.decode(URL.self, forKey: .url)

				try! super.init(from: decoder)
			}

			private enum AdditionalKeys: String, CodingKey {
				case url
			}
		}

	}
}
