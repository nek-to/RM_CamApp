import RealmSwift

class CameraData: Object, Codable {
	@objc dynamic var name: String = ""
	@objc dynamic var snapshot: String = ""
	@objc dynamic var room: String? = nil
	@objc dynamic var id: Int = 0
	@objc dynamic var favorites: Bool = false
	@objc dynamic var rec: Bool = false
}

