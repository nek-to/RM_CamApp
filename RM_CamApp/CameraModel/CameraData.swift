//
//  CameraModel.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import RealmSwift

class CameraData: Object, Codable {
	@objc dynamic var name: String = ""
	@objc dynamic var snapshot: String = ""
	@objc dynamic var room: String? = nil
	@objc dynamic var id: Int = 0
	@objc dynamic var favorites: Bool = false
	@objc dynamic var rec: Bool = false
	
	func makeIterator() -> AnyIterator<CameraData> {
		let iterator = AnyIterator {
			self.id += 1
			if self.id <= 1 {
				return self
			} else {
				return nil
			}
		}
		return iterator
	}
}

