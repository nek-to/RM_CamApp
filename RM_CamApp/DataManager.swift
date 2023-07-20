//
//  DataManager.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import RealmSwift

//protocol DataManagerProtocol {
//	func writeDataIntoDB(_ source: DataSource, _ data: DataType, completion: @escaping (() -> Void))
//	func readDataFromDB<T: Object>(_ source: DataSource, _ type: T.Type) -> Results<T>?
//	func deleteDataFromDB(_ source: DataSource, _ data: DataType)
//	func clearAllDB()
//}

enum DataSource {
	case network
}

enum DataType {
	case camera
	case door
}

class DataManager {
	
	static let shared = DataManager()
	private let realm = try? Realm()
	
	private init() {}

	func writeDataIntoDB(_ source: DataSource, _ data: DataType) {
	 var dataToWrite: Object?
	 switch source {
	 case .network:
		 switch data {
		 case .camera:
			 NetworkManager.shared.getCamerasData { cameraData, error in
				 guard error == nil else {
					 print(error?.localizedDescription as Any)
					 return
				 }
				 if let cameraData = cameraData {
					 dataToWrite = cameraData
					 self.writeToRealm(object: cameraData)
				 }
			 }
		 case .door:
			 NetworkManager.shared.getDoorsData { doorsData, error in
				 guard error == nil else {
					 print(error?.localizedDescription as Any)
					 return
				 }
				 if let doorsData = doorsData {
					 dataToWrite = doorsData
					 self.writeToRealm(object: doorsData)
				 }
			 }
		 }
	 }
 }
	
	func readDataFromDB<T: Object>(_ source: DataSource, _ type: T.Type) -> Results<T>? {
		switch source {
		case .network:
			let realm = try? Realm()
			let results = realm?.objects(type)
			print(results)
			return results
		}
	}

	
	func deleteDataFromDB(_ source: DataSource, _ data: DataType) {
		switch source {
		case .network:
			switch data {
			case .camera:
				if let cameras = realm?.objects(CamerasModel.self) {
					try? realm?.write({
						realm?.delete(cameras)
					})
				}
			case .door:
				if let doors = realm?.objects(DoorsModel.self) {
					try? realm?.write({
						realm?.delete(doors)
					})
				}
			}
		}
	}
	
	func clearAllDB() {
		try? realm?.write({
			realm?.deleteAll()
		})
	}
	
	func writeToRealm(object: Object) {
		guard let realm = try? Realm() else { return }
		do {
			try realm.write {
				realm.add(object)
			}
		} catch {
			print(error.localizedDescription)
		}
	}
}
