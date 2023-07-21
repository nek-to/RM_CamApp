import UIKit

class CameraCell: UITableViewCell {
	@IBOutlet weak var playerBlock: UIImageView!
	@IBOutlet weak var recStatusLogo: UIImageView!
	@IBOutlet weak var favoriteStatusLogo: UIImageView!
	@IBOutlet weak var cameraName: UILabel!
	@IBOutlet weak var backView: UIView!
	
	static let identifier = "CameraCell"
	
	static func nib() -> UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .none
		backView.layer.shadowColor = UIColor.black.cgColor
		backView.layer.shadowOffset = CGSize(width: 0, height: 2)
		backView.layer.shadowOpacity = 0.4
		backView.layer.shadowRadius = 4.0
		backView.layer.masksToBounds = false
		playerBlock.layer.cornerRadius = 12
		playerBlock.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	func configuration(by camera: CameraData) {
//		NetworkManager.shared.uploadImage(by: camera.snapshot, { image in
//			DispatchQueue.main.async { [weak self] in
//				if let image {
//					self?.playerBlock.image = image
//				}
//			}
//		})
        playerBlock.image = DataManager.shared.loadImageFromRealm(imageUrl: camera.snapshot)
		recStatusLogo.isHidden = !camera.rec
		favoriteStatusLogo.isHidden = !camera.favorites
		cameraName.text = camera.name
	}
    
//    func configImage(_ link: String) {
//        playerBlock.image = DataManager.shared.loadImageFromRealm(imageUrl: link)
//    }
}
