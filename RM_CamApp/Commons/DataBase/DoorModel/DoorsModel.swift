import RealmSwift

class DoorsModel: Object, Codable {
	@objc dynamic var success: Bool = false
	dynamic var data = List<DoorData>()
}
