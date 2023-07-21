import RealmSwift

class CamerasModel: Object, Codable {
	@objc dynamic var success: Bool = false
	@objc dynamic var data: CamerasModelData? = nil
}
