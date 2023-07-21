import UIKit

final class DoorCell: UITableViewCell {
	@IBOutlet private  weak var playerBlock: UIImageView!
	@IBOutlet private weak var favoriteStatusLogo: UIImageView!
	@IBOutlet private weak var doorName: UILabel!
	@IBOutlet private weak var backView: UIView!
	@IBOutlet private weak var labelBack: UIView!
	@IBOutlet private weak var playLogo: UIImageView!
	@IBOutlet private weak var aTopConstraint: NSLayoutConstraint?
	@IBOutlet private weak var isOnline: UILabel!
	
	static let identifier = "DoorCell"
	
	static func nib() -> UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .none
		labelBack.translatesAutoresizingMaskIntoConstraints = false
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
	
	func configuration(by door: DoorData) {
		let hasSnapshot = door.snapshot != nil
		
		if hasSnapshot {
			showPlayerBlock(with: door.snapshot!)
			favoriteStatusLogo.isHidden = !door.favorites
		} else {
			hidePlayerBlock()
		}
		
		doorName.text = door.name
	}
	
	private func showPlayerBlock(with snapshot: String) {
		self.playerBlock.image = DataManager.shared.loadImageFromRealm(imageUrl: snapshot)
		playLogo.isHidden = false
		playerBlock.isHidden = false
		aTopConstraint?.constant = 0
		isOnline.isHidden = false
	}
	
	private func hidePlayerBlock() {
		playLogo.isHidden = true
		playerBlock.image = nil
		playerBlock.isHidden = true
		aTopConstraint?.constant = -40
		favoriteStatusLogo.isHidden = true
		isOnline.isHidden = true
	}
	
}
