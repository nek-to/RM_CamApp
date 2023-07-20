//
//  DoorData.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import RealmSwift

class DoorData: Object, Codable {
	@objc dynamic var name: String = ""
	@objc dynamic var room: String? = nil
	@objc dynamic var id: Int = 0
	@objc dynamic var favorites: Bool = false
	@objc dynamic var snapshot: String? = nil
}
