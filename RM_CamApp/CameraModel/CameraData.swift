//
//  CameraModel.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import Foundation

struct CameraData: Codable, Sequence, IteratorProtocol {
	var name: String
	var snapshot: String
	var room: String?
	var id: Int
	var favorites: Bool
	var rec: Bool
	
	mutating func next() -> CameraData? {
		// implementation of next() method for IteratorProtocol
		// return the next CameraData object in the iteration
		// or nil if there are no more elements
		return self // return self as an example
	}
	
	func makeIterator() -> CameraData {
		// implementation of makeIterator() method for Sequence
		return self
	}
}

