//
//  DoorCell.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import UIKit

class DoorCell: UITableViewCell {
	@IBOutlet weak var playerBlock: UIImageView!
	@IBOutlet weak var favoriteStatusLogo: UIImageView!
	@IBOutlet weak var doorName: UILabel!
	@IBOutlet weak var backView: UIView!
	@IBOutlet weak var a: UIView!
	@IBOutlet weak var playLogo: UIImageView!
	@IBOutlet weak var aTopConstraint: NSLayoutConstraint?
	
	static let identifier = "DoorCell"
	
	static func nib() -> UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .none
		a.translatesAutoresizingMaskIntoConstraints = false
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
		NetworkManager().uploadImage(by: snapshot) { [weak self] image in
			DispatchQueue.main.async {
				guard let self = self, let image = image else { return }
				self.playerBlock.image = image
				self.playLogo.isHidden = false
				self.playerBlock.isHidden = false
				self.aTopConstraint?.constant = 0
			}
		}
	}
	
	private func hidePlayerBlock() {
		playLogo.isHidden = true
		playerBlock.image = nil
		playerBlock.isHidden = true
		aTopConstraint?.constant = -40
		favoriteStatusLogo.isHidden = true
	}
	
}
