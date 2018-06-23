//
//  HTTP.swift
//  GroupMac
//
//  Created by Will Tyler on 6/19/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


class HTTP {

	typealias Response = (data: Data?, response: URLResponse?, error: Error?)

	enum RequestMethod: String {
		case get = "GET"
		case post = "POST"
	}

	static func syncRequest(request: URLRequest) -> Response {
		var results: Response

		let semaphore = DispatchSemaphore(value: 0)
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			results.data = data
			results.response = response
			results.error = error

			semaphore.signal()
		}
		task.resume()
		semaphore.wait()

		return results
	}

}
