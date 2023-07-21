import RealmSwift

class ImageModel: Object {
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var imageData: Data? = nil
}
