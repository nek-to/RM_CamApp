//
//  CameraModelData.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import Foundation

struct CamerasModelData: Codable {
	var room: [String]
	var cameras: [CameraData]
}
