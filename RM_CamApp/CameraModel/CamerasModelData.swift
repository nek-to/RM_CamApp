import RealmSwift

class CamerasModelData: Object, Codable {
	dynamic var room = List<String>()
	dynamic var cameras = List<CameraData>()
}
