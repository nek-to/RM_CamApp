import UIKit

final class CameraCell: UITableViewCell {
	@IBOutlet private weak var playerBlock: UIImageView!
	@IBOutlet private weak var recStatusLogo: UIImageView!
	@IBOutlet private weak var favoriteStatusLogo: UIImageView!
	@IBOutlet private weak var cameraName: UILabel!
	@IBOutlet private weak var backView: UIView!
	
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
        playerBlock.image = DataManager.shared.loadImageFromRealm(imageUrl: camera.snapshot)
		recStatusLogo.isHidden = !camera.rec
		favoriteStatusLogo.isHidden = !camera.favorites
		cameraName.text = camera.name
	}
}
