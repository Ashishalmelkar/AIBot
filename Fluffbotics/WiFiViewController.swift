//
//  WiFiViewController.swift
//  Fluffbotics
//
//  Created by Ashish on 17/11/25.
//

import UIKit

class WiFiViewController: UIViewController {
    
    @IBOutlet weak var wifiTableRef: UITableView!
    @IBOutlet weak var continueBtnRef: UIButton!
    @IBOutlet weak var ssideViewRef: UIView!
    @IBOutlet weak var ssidTxtRef: UITextField!
    @IBOutlet weak var passwordTxtRef: UITextField!
    @IBOutlet weak var connectBtnRef: UIButton!
    
    var bluetoothNameStr = ""
    var wifiList : [String] = []
    
    var wifinameArr = ["ashish","internet?","Aryan","etc","etc","etc","etc","etc"]
    var selectedWiFiName: String?
    var popCodeStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtnRef.layer.cornerRadius = 10
        continueBtnRef.clipsToBounds = true
        continueBtnRef.isEnabled = false
        continueBtnRef.alpha = 0.4
        wifiTableRef.delegate = self
        wifiTableRef.dataSource = self
        print("Loaded WiFi List → \(wifiList)")
    }
    

    @IBAction func continueBtnAtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "wificonnectionVC") as! wificonnectionViewController
        vc.SSIDString = self.selectedWiFiName ?? ""
        vc.BluetoothNameStr = self.bluetoothNameStr
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
        
    }
    
    @IBAction func backBtnAtn(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    

}

extension WiFiViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wifiList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WiFiCell
        cell.cellLblRef.text = wifiList[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wifiname = wifiList[indexPath.row]
        self.selectedWiFiName = wifiname
        print("Selected → \(selectedWiFiName!)")
        continueBtnRef.isEnabled = true
        continueBtnRef.alpha = 1.0
        
    }
    
    
}
