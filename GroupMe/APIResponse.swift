//
// Created by Will Tyler on 8/5/18.
// Copyright (c) 2018 Will Tyler. All rights reserved.
//

import Foundation


extension GroupMe {

	class APIResponse {

		let contentData: Data?
		let meta: Meta

		init(from data: Data) throws {
			let jsonDict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
			let metaDict = jsonDict["meta"] as! [String: Any]
			let code = metaDict["code"] as! Int
			let content = jsonDict["response"]

			self.meta = Meta(code: code)

			if let content = content, !(content is NSNull) {
				self.contentData = try! JSONSerialization.data(withJSONObject: content)
			}
			else {
				self.contentData = nil
			}
		}

	}

}

extension GroupMe.APIResponse {

	struct Meta: Decodable {

		let code: Int

		fileprivate init(code: Int) {
			self.code = code
		}

	}

}
