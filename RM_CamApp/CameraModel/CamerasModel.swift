//
//  CameraModel.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import RealmSwift

class CamerasModel: Object, Codable, Sequence {
	@objc dynamic var success: Bool = false
	@objc dynamic var data: CamerasModelData? = nil
	
	func makeIterator() -> AnyIterator<CameraData> {
		// Get the camera array from the CamerasModelData object
		guard let cameras = data?.cameras else {
			return AnyIterator { return nil }
		}
		
		// Create an iterator that returns each camera in the array
		var index = 0
		return AnyIterator {
			defer { index += 1 }
			return index < cameras.count ? cameras[index] : nil
		}
	}
}
