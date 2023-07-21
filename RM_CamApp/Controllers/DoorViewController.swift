import UIKit

final class DoorViewController: UIViewController {
	@IBOutlet private weak var doorTitle: UILabel!
	@IBOutlet private weak var playerBlock: UIImageView!
	
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
		playerBlock.image = DataManager.shared.loadImageFromRealm(imageUrl: doorData.snapshot ?? "")
	}
	
	@IBAction private func backToThePrevious(_ sender: UIButton) {
		dismiss(animated: true)
	}
}
