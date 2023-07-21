import RealmSwift

enum DataSource {
    case network
}

enum DataType {
    case camera
    case door
}

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func writeDataIntoDB(_ source: DataSource, _ data: DataType, completion: @escaping () -> Void) {
        let realm = try? Realm()
        switch source {
        case .network:
            switch data {
            case .camera:
                NetworkManager.shared.getCamerasData { cameraData, error in
                    guard error == nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    if let cameraData {
                        self.writeToRealm(object: cameraData)
                        cameraData.data?.cameras.forEach({ camera in
                            self.saveImagesToRealm(camera.snapshot)
                        })
                        completion()
                    }
                }
            case .door:
                NetworkManager.shared.getDoorsData { doorsData, error in
                    guard error == nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    if let doorsData {
                        self.writeToRealm(object: doorsData)
                        doorsData.data.forEach { door in
                            self.saveImagesToRealm(door.snapshot ?? "")
                        }
                        completion()
                    }
                }
            }
        }
    }
    
    private func saveImagesToRealm(_ url: String) {
        let realm = try? Realm()
            if let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl) {
                let imageModel = ImageModel()
                imageModel.imageUrl = url
                imageModel.imageData = imageData
                
                try? realm?.write {
                    realm?.add(imageModel)
                }
            }
    }
    
    func readDataFromDB<T: Object>(_ source: DataSource, _ type: T.Type) -> Results<T>? {
		let realm = try? Realm()
        switch source {
        case .network:
            let results = realm?.objects(type)
            return results
        }
    }
    
    func loadImageFromRealm(imageUrl: String) -> UIImage? {
        let realm = try! Realm()
        let imageModel = realm.objects(ImageModel.self).filter("imageUrl = %@", imageUrl).first
        
        if let imageData = imageModel?.imageData, let image = UIImage(data: imageData) {
            return image
        }
        
        return nil
    }
    
    func deleteDataFromDB(_ source: DataSource, _ data: DataType) {
        let realm = try? Realm()
        switch source {
        case .network:
            switch data {
            case .camera:
                if let camerasModel = realm?.objects(CamerasModel.self),
				let camerasModelData = realm?.objects(CamerasModelData.self),
				let cameraData = realm?.objects(CameraData.self){
                    try? realm?.write({
						realm?.delete(camerasModel)
						realm?.delete(camerasModelData)
						realm?.delete(cameraData)
                    })
                }
            case .door:
                if let doorsModel = realm?.objects(DoorsModel.self),
				   let doorData = realm?.objects(DoorData.self) {
                    try? realm?.write({
                        realm?.delete(doorsModel)
						realm?.delete(doorData)
                    })
                }
            }
        }
		deletingImages()
    }
	
	func deletingImages() {
		let realm = try? Realm()
		if let images = realm?.objects(ImageModel.self) {
			try? realm?.write {
				realm?.delete(images)
			}
		}
	}
    
    func clearAllDB(completion: @escaping () -> Void) {
        deleteDataFromDB(.network, .camera)
        deleteDataFromDB(.network, .door)
		deletingImages()
		completion()
    }
	
	func clear(completion: @escaping() -> Void) {
		let realm = try? Realm()
		try? realm?.write {
			realm?.deleteAll()
		}
		completion()
	}
    
    private func writeToRealm(object: Object) {
        let realm = try? Realm()
        do {
            try realm?.write {
                realm?.add(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
