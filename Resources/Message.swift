//
//  Message.swift
//  GroupMac
//
//  Created by Will Tyler on 6/26/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


protocol GroupMeMessage {
	var name: String { get }
	var text: String { get }
}

extension GroupMe.Chat.Message: GroupMeMessage {}
extension GroupMe.Group.Message: GroupMeMessage {}
