//
//  ViewController.swift
//  RM_CamApp
//
//  Created by admin on 19.07.2023.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
	@IBOutlet weak var camerasButton: UIButton!
	@IBOutlet weak var doorsButton: UIButton!
	@IBOutlet weak var camerasBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var doorsBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var contentTableView: UITableView!
	
	private var camerasData: CamerasModel?
	private var doorsData: DoorsModel?
	private var camerasSelected = true
	private let realm = try? Realm()
	
	var sendDataClosure: ((DoorData) -> Void)?
	var sections: [String?: [CameraData]] = [:]
	var sectionsIn =  [Dictionary<String?, [CameraData]>.Keys.Element]()
	
	//	var cameraDataArray: [CameraData] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		contentTableView.delegate = self
		contentTableView.dataSource = self
		contentTableView.register(CameraCell.nib(), forCellReuseIdentifier: CameraCell.identifier)
		contentTableView.register(DoorCell.nib(), forCellReuseIdentifier: DoorCell.identifier)
		contentTableView.separatorStyle = .none
		DataManager.shared.clearAllDB()
		
		NetworkManager.shared.getCamerasData { [weak self] newData, error in
			// Ensure there are no errors and the data is not nil
			guard let newData = newData, error == nil else {
				return
			}

			// Sort the data by room
			let sortedData = newData.data?.cameras.sorted { $0.room ?? "" < $1.room ?? "" }
			for data in sortedData ?? [CameraData]() {
				let room = data.room ?? "No Room"
				if self?.sections[room] == nil {
					self?.sections[room] = [data]
				} else {
					self?.sections[room]?.append(data)
				}
			}

			// Update the table view on the main thread
			DispatchQueue.main.async {
				self?.sectionsIn = Array(self!.sections.keys)
				self?.contentTableView.reloadData()
			}

			// Write the new data into the database on a background thread
			DispatchQueue.global(qos: .background).async {
				DataManager.shared.writeDataIntoDB(.network, .camera)
				DataManager.shared.writeDataIntoDB(.network, .door)
			}
		}
	}
//		let dispatchGroup = DispatchGroup()
//
//		dispatchGroup.enter()
//		dispatchGroup.leave()
//
//
//		camerasData = DataManager.shared.readDataFromDB(.network, CamerasModel.self)?.first
//		doorsData = DataManager.shared.readDataFromDB(.network, DoorsModel.self)?.first
//		NetworkManager.shared.getCamerasData { cameras, error in
//			self.camerasData = cameras
//
//			let sortedData = self.camerasData?.data?.cameras.sorted { $0.room ?? "" < $1.room ?? "" }
//
//			for data in sortedData! {
//				let room = data.room ?? "No Room" // Если поле room может быть неопределено (nil), можно использовать пустую строку в качестве значения по умолчанию
//				if self.sections[room] == nil {
//					self.sections[room] = [data]
//				} else {
//					self.sections[room]?.append(data)
//				}
//			}
//			self.sectionsIn = Array(self.sections.keys)
//
//			DispatchQueue.main.sync {
//				self.contentTableView.reloadData()
//			}
//		}
//		NetworkManager.shared.getDoorsData { door, error in
//			self.doorsData = door
//		}

@IBAction func switchToCameras(_ sender: Any) {
	camerasBottomConstraint.constant = 2.0
	doorsBottomConstraint.constant = 0.0
	
	camerasSelected = true
	contentTableView.reloadData()
}

@IBAction func switchToDoors(_ sender: Any) {
	camerasBottomConstraint.constant = 0.0
	doorsBottomConstraint.constant = 2.0
	
	camerasSelected = false
	contentTableView.reloadData()
}
}

extension ViewController: UITableViewDelegate {
	//	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
	//		return 280
	//	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if !camerasSelected {
			let data = doorsData?.data[indexPath.row]
			
			// Check if the "image" property of the data is nil or not
			if data?.snapshot == nil {
				return 80 // Return a smaller height if there is no image
			} else {
				return 280
			}
		} else {
			return 280
		}
	}
}

extension ViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		if camerasSelected {
			//			return camerasData?.data.room.count ?? 0
			return sectionsIn.count
		} else {
			return 1
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if camerasSelected {
			let sectionKey = sectionsIn[section]
			return sections[sectionKey]?.count ?? 0
		} else {
			return doorsData?.data.count ?? 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//		let cell: UITableViewCell
		//		let room = Array(sections.keys)[indexPath.section]
		if camerasSelected {
			let cameraCell = tableView.dequeueReusableCell(withIdentifier: CameraCell.identifier) as! CameraCell
			let sectionKey = sectionsIn[indexPath.section]
			//				let cameraData = cameraDataDict[sectionKey]?[indexPath.row]
			if let dataForConfiguration = sections[sectionKey]?[indexPath.row] {
				cameraCell.configuration(by: dataForConfiguration)
			}
			return cameraCell
		} else {
			let doorCell = tableView.dequeueReusableCell(withIdentifier: DoorCell.identifier) as! DoorCell
			doorCell.doorName.text = doorsData?.data[indexPath.row].name
			if let dataForConfiguration = doorsData?.data[indexPath.row] {
				doorCell.configuration(by: dataForConfiguration)
			}
			return doorCell
		}
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let customAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
			// Handle the action when it's tapped
			print("action")
			completionHandler(true)
		}
		customAction.backgroundColor = .white
		customAction.image = UIImage(named: "favorite")
		
		let configuration = UISwipeActionsConfiguration(actions: [customAction])
		configuration.performsFirstActionWithFullSwipe = false
		return configuration
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !camerasSelected && doorsData?.data[indexPath.row].snapshot != nil {
			if let doorData = doorsData?.data[indexPath.row] {
				let vc = DoorViewController(doorData)
				vc.modalPresentationStyle = .fullScreen
				vc.modalTransitionStyle = .flipHorizontal
				present(vc, animated: true)
			}
		}
	}
	
	
	//		func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
	//			guard let title = camerasData?.data.room[section] else { return nil }
	//			let attributedString = NSMutableAttributedString(string: title)
	//			attributedString.addAttribute(.font, value: UIFont(name: "Circe", size: 21), range: NSRange(location: 0, length: title.count))
	//			switch section {
	//			case 0:
	//				return camerasSelected ? title : nil
	//			case 1:
	//				return camerasSelected ? title : nil
	//			default:
	//				return nil
	//			}
	//		}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let title = sectionsIn[section]
		switch section {
		case 0:
			return camerasSelected ? title : nil
		case 1:
			return camerasSelected ? title : nil
		default:
			return nil
		}
	}
	
}

