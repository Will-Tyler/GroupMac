//
//  Attachments.swift
//  GroupMac
//
//  Created by Will Tyler on 7/14/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


protocol AttachmentContent {}

extension GroupMe {

	class Attachment: Decodable {

		let contentType: ContentType
		let content: AttachmentContent?

		required init(from decoder: Decoder) throws {
			let values = try! decoder.container(keyedBy: CodingKeys.self)
			let contentString = try! values.decode(String.self, forKey: .contentType)

			self.contentType = ContentType(rawValue: contentString) ?? .unknown

			switch contentType {
			case .image:
				content = Image(url: try! values.decode(URL.self, forKey: .url))

			case .location:
				let lat = Double(try! values.decode(String.self, forKey: .lat))!
				let lng = Double(try! values.decode(String.self, forKey: .lng))!
				let name = try! values.decode(String.self, forKey: .name)

				content = Location(latitude: lat, longitude: lng, name: name)

			case .split:
				content = Split(token: try! values.decode(String.self, forKey: .token))

			case .emoji:
				content = Emoji(placeholder: try! values.decode(String.self, forKey: .placeholder), charmap: try! values.decode([[Int]].self, forKey: .charmap))

			case .poll:
				content = Poll(id: try! values.decode(String.self, forKey: .id))

			case .mentions:
				content = Mentions(loci: try! values.decode([[Int]].self, forKey: .loci))

			case .unknown:
				content = nil
			}
		}

		enum ContentType: String {
			case image
			case location
			case split
			case emoji
			case poll
			case mentions
			case unknown
		}

		private enum CodingKeys: String, CodingKey {
			case contentType = "type"
			case url
			case lat
			case lng
			case name
			case token
			case placeholder
			case charmap
			case id = "poll_id"
			case loci
		}

		struct Image: AttachmentContent {
			let url: URL
		}

		struct Location: AttachmentContent {
			let latitude: Double
			let longitude: Double
			let name: String
		}

		struct Split: AttachmentContent {
			let token: String
		}

		struct Emoji: AttachmentContent {
			let placeholder: String
			let charmap: [[Int]]
		}

		struct Poll: AttachmentContent {
			let id: String
		}

		struct Mentions: AttachmentContent {
			let loci: [[Int]]
		}

	}

}
