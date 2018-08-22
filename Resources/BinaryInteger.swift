//
//  IntExt.swift
//  Essentials
//
//  Created by Will Tyler on 5/19/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


precedencegroup ExponentialPrecedence {
	lowerThan: BitwiseShiftPrecedence
	higherThan: MultiplicationPrecedence
}
infix operator **: ExponentialPrecedence

public extension BinaryInteger {

	public static postfix func ++(number: inout Self) -> Self {
		defer {
			number += 1
		}

		return number
	}

	public static prefix func ++(number: inout Self) -> Self {
		number += 1

		return number
	}

	public static postfix func --(number: inout Self) -> Self {
		defer {
			number -= 1
		}

		return number
	}

	public static prefix func --(number: inout Self) -> Self {
		number -= 1

		return number
	}

	public static func **(base: Self, power: Self) -> Self {
		precondition(power >= 0)

		switch power {
		case 0: return Self(1)
		case 1: return base
		default: break
		}

		let baseInt = Int(base)

		var result = 1
		for _ in 1...UInt(power) {
			result *= baseInt
		}

		return Self(result)
	}

}
