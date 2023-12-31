import Foundation
import RealmSwift

class NetworkManager {
	static let shared = NetworkManager()
	
	private init() {}
	
	func getCamerasData(_ completion: @escaping(CamerasModel?, Error?) -> Void) {
		guard let url = URL(string: "https://cars.cprogroup.ru/api/rubetek/cameras/") else {
			print("URL ISSUE")
			return
		}
		
		URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
			guard let data = data else {
				print("Data issue")
				return
			}
			do {
				let res = try JSONDecoder().decode(CamerasModel.self, from: data)
				completion(res, nil)
			} catch {
				completion(nil, error)
			}
		}.resume()
	}
	
	
	func getDoorsData(_ completion: @escaping(DoorsModel?, Error?) -> Void) {
		guard let url = URL(string: "https://cars.cprogroup.ru/api/rubetek/doors/") else {
			print("URL ISSUE")
			return
		}
		
		URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
			guard let data = data else {
				print("Data issue")
				return
			}
			do {
				let res = try JSONDecoder().decode(DoorsModel.self, from: data)
				completion(res, nil)
			} catch {
				completion(nil, error)
			}
		}.resume()
	}
	
	func uploadImage(by url: String, _ completion: @escaping(UIImage?) -> Void) {
		guard let url = URL(string: url) else {
			print("Image error")
			return
		}
		var resultImage = UIImage()
		
		URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
			guard let data else {
				print("Data issue")
				return
			}
			
			do {
				resultImage = UIImage(data: data) ?? UIImage()
				completion(resultImage)
			}
		}
		.resume()
		
	}
}
