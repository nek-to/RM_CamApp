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
                        completion() // Call the completion handler after writing data
                        print("Written C")
                        print(cameraData)
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
                        completion() // Call the completion handler after writing data
                        print("Written D")
                        print(doorsData)
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
        switch source {
        case .network:
            let realm = try? Realm()
            let results = realm?.objects(type)
            print("Reeden")
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
        deleteDataFromDB(.network, .camera)
        deleteDataFromDB(.network, .door)
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
