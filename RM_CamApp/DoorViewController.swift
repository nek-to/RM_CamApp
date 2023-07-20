//
//  DoorViewController.swift
//  RM_CamApp
//
//  Created by admin on 20.07.2023.
//

import UIKit

class DoorViewController: UIViewController {
	@IBOutlet weak var doorTitle: UILabel!
	@IBOutlet weak var playerBlock: UIImageView!

	private let identifier = "DoorViewController"
	private let doorData: DoorData
	
	init(_ doorData: DoorData) {
			self.doorData = doorData
			super.init(nibName: identifier, bundle: nil)
		}
	
	required init?(coder aDecoder: NSCoder) {
		guard let doorData = aDecoder.decodeObject(forKey: "doorData") as? DoorData else {
			return nil
		}
		self.doorData = doorData
		super.init(coder: aDecoder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		doorTitle.text = doorData.name
    }
	
	@IBAction func backToThePrevious(_ sender: UIButton) {
		dismiss(animated: true)
	}
	
}
