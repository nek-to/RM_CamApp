//
//  CameraModelData.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import RealmSwift

class CamerasModelData: Object, Codable {
	dynamic var room = List<String>()
	dynamic var cameras = List<CameraData>()
	
	func makeIterator() -> AnyIterator<CameraData> {
		let iterator = cameras.makeIterator()
		return AnyIterator(iterator)
	}
}
