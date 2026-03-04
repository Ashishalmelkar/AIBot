//
//  DashBoardViewController.swift
//  Fluffbotics
//
//  Created by Equipp on 28/11/25.
//

import UIKit
import CoreData

class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var nodeviceViewRef: UIView!
    @IBOutlet weak var connecteddeviceViewRef: UIView!
    @IBOutlet weak var dashboardTlbRef: UITableView!
    @IBOutlet weak var fluffbuddyViewRef: UIView!
    @IBOutlet weak var miniViewRef: UIView!
    
    
    var savedDevices: [FluffDevices] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadSavedDevices),
            name: .deviceSavedToCoreData,
            object: nil
        )
       // CoreDataManager.shared.deleteAllConnectedDevices()
        reloadSavedDevices() // initial load
        self.dashboardTlbRef.dataSource = self
        self.dashboardTlbRef.delegate = self
        
        self.updateUI()

    }
    func updateUI() {
        if savedDevices.count == 0  {
            connecteddeviceViewRef.isHidden = true
            nodeviceViewRef.isHidden = false
        }else{
            nodeviceViewRef.isHidden = true
            connecteddeviceViewRef.isHidden = false
        }
        
    }
    
    @objc func reloadSavedDevices() {
        savedDevices = fetchDevices()
        dashboardTlbRef.reloadData()
        self.updateUI()
    }
    func fetchDevices() -> [FluffDevices] {
        let request: NSFetchRequest<FluffDevices> = FluffDevices.fetchRequest()

        do {
            return try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return []
        }
    }

    
    @IBAction func AddBtnAtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "BluetoothVC") as! ViewController
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func adddevicesBtnAtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "BluetoothVC") as! ViewController
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func fluffbuddyBtnAtn(_ sender: Any) {
        if let url = URL(string: "https://www.fluffbotics.ai") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func miniBtnRef(_ sender: Any) {
        if let url = URL(string: "https://www.fluffbotics.ai") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

extension DashBoardViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTableCell
        cell.cellViewRef.layer.cornerRadius = 10
        cell.cellViewRef.clipsToBounds = true
        cell.cellnameLblRef.text = savedDevices[indexPath.row].name
        return cell
        
    }
    
    
}
