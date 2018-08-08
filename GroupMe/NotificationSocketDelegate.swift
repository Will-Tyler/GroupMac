//
// Created by Will Tyler on 8/5/18.
// Copyright (c) 2018 Will Tyler. All rights reserved.
//

import Foundation
import SocketRocket


final class NotificationSocketDelegate: NSObject, SRWebSocketDelegate {

	func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
		print("Notification socket received message...", message, separator: "\n")
	}

}
