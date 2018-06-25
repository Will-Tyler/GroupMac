//
//  Message.swift
//  GroupMac
//
//  Created by Will Tyler on 6/23/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


protocol Message {
	var id: String { get }
	var createdAt: Int { get }
	var avatarURL: URL? { get }
	var favoritedBy: [String] { get }
	var name: String { get }
	var text: String? { get }
}
