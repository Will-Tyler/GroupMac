//
// Created by Will Tyler on 8/5/18.
// Copyright (c) 2018 Will Tyler. All rights reserved.
//

import Foundation


extension GroupMe {

	class APIResponse {

		let contentData: Data
		let meta: Meta

		init(from data: Data) throws {
			let jsonDict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
			let content = jsonDict["response"]!

			self.contentData = try! JSONSerialization.data(withJSONObject: content)

			let metaDict = jsonDict["meta"] as! [String: Any]
			let code = metaDict["code"] as! Int

			meta = Meta(code: code)
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
