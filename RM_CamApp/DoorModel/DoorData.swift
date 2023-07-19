//
//  DoorData.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import Foundation

struct DoorData: Codable {
	var name: String
	var room: String?
	var id: Int
	var favorites: Bool
	var snapshot: String?
}
