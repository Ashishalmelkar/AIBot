//
//  ViewController.swift
//  Fluffbotics
//
//  Created by Ashish on 17/11/25.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController{

    var peripherals: [CBPeripheral] = []
    var selectedPeripheral: CBPeripheral?
    var selectedDeviceName: String?
    var scannedList: [String] = []
    @IBOutlet weak var bluetoothTableRef: UITableView!
    @IBOutlet weak var continueBtnRef: UIButton!
    var characteristicAssigned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bluetoothTableRef.dataSource = self
        self.bluetoothTableRef.delegate = self
        
        continueBtnRef.layer.cornerRadius = 10
        continueBtnRef.clipsToBounds = true
        continueBtnRef.isEnabled = false
        continueBtnRef.alpha = 0.4
        LoaderView.show(on: self.view)
        BluetoothManager.shared.start()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPeripheralListUpdated(_:)),
            name: .bluetoothDeviceUpdated,
            object: nil
        )
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(onWiFiScanCompleted(_:)),
                    name: .wifiScanCompleted,
                    object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showBluetoothOffAlert),
            name: .bluetoothPoweredOff,
            object: nil
        )
    }
    
    
    
    @IBAction func continueBtnAtn(_ sender: Any) {
        LoaderView.show(on: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            BluetoothManager.shared.sendDataToPeripheral(data: "WiFiScan")
        }
    }
    
    @objc func onPeripheralListUpdated(_ notification: Notification) {
        peripherals = BluetoothManager.shared.peripherals
        bluetoothTableRef.reloadData()
        LoaderView.hide()
    }
    
    @objc func onWiFiScanCompleted(_ notification: Notification) {
        guard let list = notification.userInfo?["list"] as? [String] else { return }
        scannedList = list
        goToNextScreen()
        LoaderView.hide() 
    }
    
    @objc func showBluetoothOffAlert() {
            let alert = UIAlertController(
                title: "Bluetooth Off",
                message: "Please enable Bluetooth to continue.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    
    func goToNextScreen() {
            guard let deviceName = selectedDeviceName else { return }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "WiFiVC") as! WiFiViewController
            nextVC.bluetoothNameStr = deviceName
            nextVC.wifiList = scannedList
            navigationController?.pushViewController(nextVC, animated: true)
            selectedDeviceName = nil
            if let selectedIndexPath = bluetoothTableRef.indexPathForSelectedRow {
                bluetoothTableRef.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    
    
    @IBAction func backBtnAtn(_ sender: Any) {
        BluetoothManager.shared.centralManager.stopScan()
        BluetoothManager.shared.disconnect()
        navigationController?.popViewController(animated: true)
    }
    


}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }

    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BluetoothCell
        let peripheral = peripherals[indexPath.row]
        cell.cellLblRef.text = peripheral.name ?? "Unknown Device"
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripherals[indexPath.row]

                selectedDeviceName = peripheral.name ?? "Unknown"
                selectedPeripheral = peripheral

                print("User Selected → \(selectedDeviceName!)")

                // Tell Bluetooth manager which device to connect
                BluetoothManager.shared.selectedPeripheral = peripheral

                // Connect
                BluetoothManager.shared.centralManager.connect(peripheral, options: nil)

                continueBtnRef.isEnabled = true
                continueBtnRef.alpha = 1.0
        }
    
    
}

