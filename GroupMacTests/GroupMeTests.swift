//
//  GroupMeTests.swift
//  GroupMacTests
//
//  Created by Will Tyler on 6/25/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import XCTest

class GroupMeTests: XCTestCase {

	var group: GroupMe.Group!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

		group = GroupMe.Group.create(name: "Test Group", description: "This group is for testing the Swift GroupMe API wrapper.")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

		group.destroy()
    }

	func testGroupUpdate() {
		let newName = "Bloopsies"
		group = group.update(name: newName)!

		XCTAssertEqual(group.name, newName)
	}

	func testGroupShow() {
		let groupID = group.id
		let groupCopy = GroupMe.Group.show(id: groupID)

		XCTAssertEqual(groupID, groupCopy.id)
		XCTAssertEqual(group.name, groupCopy.name)
		XCTAssertEqual(group.description, groupCopy.description)
	}

}
