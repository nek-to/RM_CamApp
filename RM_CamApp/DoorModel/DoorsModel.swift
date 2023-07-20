//
//  DoorsModel.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import RealmSwift

class DoorsModel: Object, Codable {
	@objc dynamic var success: Bool = false
	dynamic var data = List<DoorData>()
}
