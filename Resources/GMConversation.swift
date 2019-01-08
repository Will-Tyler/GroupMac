//
//  GMConversation.swift
//  GroupMac
//
//  Created by Will Tyler on 6/26/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


protocol GMConversation {

	var name: String { get }
	var updatedAt: Int { get }
	var convoType: GMConversationType { get }
	var imageURL: URL? { get }

	func sendMessage(text: String, successHandler: @escaping ()->())
	@discardableResult
	func handleMessages(with handler: @escaping ([GMMessage])->(), beforeID: String?) -> URLSessionDataTask

}

extension GroupMe.Chat: GMConversation {

	var name: String {
		get { return otherUser.name }
	}
	var convoType: GMConversationType {
		get { return .chat }
	}
	var imageURL: URL? {
		get { return otherUser.avatarURL }
	}

	func handleMessages(with handler: @escaping ([GMMessage])->(), beforeID: String?) -> URLSessionDataTask {
		return handleMessages(with: handler as ([GroupMe.Chat.Message])->(), beforeID: beforeID)
	}

}

extension GroupMe.Group: GMConversation {

	var convoType: GMConversationType {
		get { return .group }
	}

	func handleMessages(with handler: @escaping ([GMMessage]) -> (), beforeID: String?) -> URLSessionDataTask {
		return handleMessages(with: handler as ([GroupMe.Group.Message])->(), beforeID: beforeID)
	}

}
