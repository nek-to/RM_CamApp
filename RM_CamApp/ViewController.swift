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
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        contentTableView.refreshControl = refreshControl
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(CameraCell.nib(), forCellReuseIdentifier: CameraCell.identifier)
        contentTableView.register(DoorCell.nib(), forCellReuseIdentifier: DoorCell.identifier)
        contentTableView.separatorStyle = .none
        let dispatchGroup = DispatchGroup()
        
        print("There")
        doorsData = DataManager.shared.readDataFromDB(.network, DoorsModel.self)?.first
        camerasData = DataManager.shared.readDataFromDB(.network, CamerasModel.self)?.first
        
        if doorsData == nil && camerasData == nil {
            print("Here")
            dispatchGroup.enter()
            DataManager.shared.writeDataIntoDB(.network, .camera) {
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            DataManager.shared.writeDataIntoDB(.network, .door) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            self.doorsData = DataManager.shared.readDataFromDB(.network, DoorsModel.self)?.first
            self.camerasData = DataManager.shared.readDataFromDB(.network, CamerasModel.self)?.first
            
            let sortedData = self.camerasData?.data?.cameras.sorted { $0.room ?? "" < $1.room ?? "" } ?? []
            if sortedData.isEmpty {
                print("sortedData is empty.")
            } else {
                for data in sortedData {
                    let room = data.room ?? "NO ROOM"
                    if self.sections[room] == nil {
                        self.sections[room] = [data]
                    } else {
                        self.sections[room]?.append(data)
                    }
                }
            }
            
            // Update the table view on the main thread
            self.sectionsIn = self.sections.keys.compactMap { $0 }
            self.contentTableView.reloadData()
            print("END")
        }
    }
    
    //    func prepareCameras(_ data: CamerasModel) {
    //        DispatchQueue.global().async {
    //            let sortedData = data.data?.cameras.sorted { $0.room ?? "" < $1.room ?? "" }
    //            for data in sortedData ?? [CameraData]() {
    //                let room = data.room ?? "No Room"
    //                if self.sections[room] == nil {
    //                    self.sections[room] = [data]
    //                } else {
    //                    self.sections[room]?.append(data)
    //                }
    //            }
    //        }
    //    }
    
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
    
    @objc private func refreshData() {
        DataManager.shared.clearAllDB()
        guard let windows = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows else { return }
        
        windows.forEach { $0.isUserInteractionEnabled = false }
        
        let alertWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let alertController = UIAlertController(title: "Ошибка", message: "Данные не обновились", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.contentTableView.refreshControl?.endRefreshing()
                windows.forEach { $0.isUserInteractionEnabled = true }
            })
            self.present(alertController, animated: true, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: alertWorkItem)
        
        DataManager.shared.writeDataIntoDB(.network, .camera) { [weak self] in
            guard let self = self else { return }
            DataManager.shared.writeDataIntoDB(.network, .door) { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.doorsData = DataManager.shared.readDataFromDB(.network, DoorsModel.self)?.first
                    self.camerasData = DataManager.shared.readDataFromDB(.network, CamerasModel.self)?.first
                    
                    let sortedData = self.camerasData?.data?.cameras.sorted { $0.room ?? "" < $1.room ?? "" } ?? []
                    if sortedData.isEmpty {
                        print("sortedData is empty.")
                    } else {
                        for data in sortedData {
                            let room = data.room ?? "NO ROOM"
                            if self.sections[room] == nil {
                                self.sections[room] = [data]
                            } else {
                                self.sections[room]?.append(data)
                            }
                        }
                    }
                    
                    self.sectionsIn = self.sections.keys.compactMap { $0 }
                    print(self.sectionsIn)
                    self.contentTableView.reloadData()
                    self.contentTableView.refreshControl?.endRefreshing()
                    
                    windows.forEach { $0.isUserInteractionEnabled = true }
                    alertWorkItem.cancel()
                }
            }
        }
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
                //                cameraCell.configImage(dataForConfiguration.snapshot)
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
        let editAction = UIContextualAction(style: .normal, title: "Изменить") { [weak self] (_, _, completionHandler) in
            self?.editTitle(self?.doorsData?.data[indexPath.row].name ?? "" ,completionHandler: completionHandler)
        }
        
        editAction.backgroundColor = .white
        editAction.image = UIImage(named: "favorite")
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    func editTitle(_ old: String, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Изменение названия", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Новое название"
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let self = self,
                  let newTitle = alertController.textFields?.first?.text else { return }
            
                  let doorToUpdate = realm?.objects(DoorData.self).filter("name == %@", old).first
            
            do {
                try realm?.write {
                    doorToUpdate?.name = newTitle
                }
            } catch {
                print("Не записалось ------")
            }
            
            DispatchQueue.main.async {
                self.doorsData = DataManager.shared.readDataFromDB(.network, DoorsModel.self)?.first
                print(self.doorsData)
                self.contentTableView.reloadData()
                print("Обновился интерфейс ++++++++++")
            }
            
            completionHandler(true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            completionHandler(false)
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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

