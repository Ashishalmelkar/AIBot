//
//  wificonnectionViewController.swift
//  Fluffbotics
//
//  Created by Ashish on 18/11/25.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreLocation
import CoreBluetooth

class wificonnectionViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var ssidNameTxtRef: UITextField!
    @IBOutlet weak var passwordTxtRef: UITextField!
    @IBOutlet weak var connectBtnRef: UIButton!
    
    let dimView = UIView()
    let locationManager = CLLocationManager()
    var SSIDString = ""
    
//    var centralManager: CBCentralManager!
//    var peripherals: [CBPeripheral] = []
//    var selectedPeripheral: CBPeripheral?
//    
//    let serviceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
//    let characteristicUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
//    var commandCharacteristic: CBCharacteristic?
//    var writeCharacteristic: CBCharacteristic?
//    var notifyCharacteristic: CBCharacteristic?
    
    var BluetoothNameStr = ""
    var backcodeStr = ""
    
    
    
    @IBOutlet weak var wifiViewRef: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDimBackground()
        self.wifiViewRef.layer.cornerRadius = 10
        wifiViewRef.clipsToBounds = true
        connectBtnRef.layer.cornerRadius = 10
        connectBtnRef.clipsToBounds = true
        print("Bluetooth Name :\(BluetoothNameStr)")
        self.ssidNameTxtRef.text = SSIDString
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onWiFiSuccess),
            name: .wifiSuccess,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onWiFiErrorUnknown),
            name: .wifiErrorUnknown,
            object: nil
        )
        
    }
    
    @objc func onWiFiSuccess() {
        print("WiFi Connected Successfully!")
        LoaderView.hide()
        let alert = UIAlertController(
            title: "Connected",
            message: "Wi-Fi connected successfully 🎉",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
           // self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true){
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first,
                   let nav = window.rootViewController as? UINavigationController {
                    nav.popToRootViewController(animated: true)
                }
            }
        }))

        self.present(alert, animated: true)
    }
    
    @objc func onWiFiErrorUnknown() {
        LoaderView.hide()
        let alert = UIAlertController(
            title: "Error",
            message: "Unknown Wi-Fi error occurred. Please try again.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func closeBtnAtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
      //  fetchSSIDIfAuthorized()
    }
    
    func setupDimBackground() {
        let dimView = UIView(frame: self.view.bounds)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.75) // DIM
        dimView.isUserInteractionEnabled = false  // Don’t absorb touches if you want popup only active
        self.view.insertSubview(dimView, at: 0)    // Behind your popup view
    }
    
    @IBAction func connectBtnAtn(_ sender: Any) {
        //Send SSID
        LoaderView.show(on: self.view)
        let ssid = "SSID:" + self.ssidNameTxtRef.text!
        let password = "PASS:" + self.passwordTxtRef.text!
        print("Printing SSID : \(ssid)")
        print("Printing password : \(password)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            BluetoothManager.shared.sendDataToPeripheral(data: ssid)
        }
        //Wait for 3 seconds and send password
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            BluetoothManager.shared.sendDataToPeripheral(data: password)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            BluetoothManager.shared.sendDataToPeripheral(data: "Connect")
        }
    }
    
    func fetchSSIDIfAuthorized() {
         let status = locationManager.authorizationStatus
         
         switch status {
         case .authorizedWhenInUse, .authorizedAlways:
             loadSSID()
             
         case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
             
         case .denied, .restricted:
             ssidNameTxtRef.text = ""
             print("Location permission denied. Cannot fetch SSID.")
             
         @unknown default:
             break
         }
     }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            let status = manager.authorizationStatus
            
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                loadSSID()
            }
        }
    
    
    
    func loadSSID() {
            if let ssid = getConnectedSSID() {
                ssidNameTxtRef.text = ssid
            } else {
                ssidNameTxtRef.text = ""
                print("Could not fetch SSID — user not connected or permission missing")
            }
        }
    
    func getConnectedSSID() -> String? {
            if let interfaces = CNCopySupportedInterfaces() as? [String] {
                for interface in interfaces {
                    if let info = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject],
                       let ssid = info[kCNNetworkInfoKeySSID as String] as? String {
                        return ssid
                    }
                }
            }
            return nil
        }
    
    
    

}
