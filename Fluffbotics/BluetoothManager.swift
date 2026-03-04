//
//  BluetoothManager.swift
//  Fluffbotics
//
//  Created by Equipp on 27/11/25.
//

import Foundation
import CoreBluetooth
import UIKit
import CoreData



class BluetoothManager: NSObject {
    
    static let shared = BluetoothManager()
    
    var centralManager: CBCentralManager!
    var peripherals: [CBPeripheral] = []
    var selectedPeripheral: CBPeripheral?
    
    let serviceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let characteristicUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    
    var commandCharacteristic: CBCharacteristic?
    var writeCharacteristic: CBCharacteristic?
    var notifyCharacteristic: CBCharacteristic?
    
    var selectedDeviceName: String?
    var characteristicAssigned = false
    var scannedList: [String] = []
    
    override init() {
        super.init()
    }
    func start() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func sendDataToPeripheral(data: String) {
        guard let peripheral = selectedPeripheral else{
            return
        }
        guard let services = peripheral.services else { return  }
        
        for service in services{
            
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics(nil, for: service)
                let characteristics = service.characteristics
                
                for characteristic in characteristics!  {
                    if characteristic.uuid == characteristicUUID {
                        self.commandCharacteristic = characteristic
                    }
                    let dataToSend = data.data(using: .utf8)
                    peripheral.writeValue(dataToSend!, for: characteristic , type: .withResponse)
                }
            }
        }
    }
    func disconnect() {
        if let peripheral = selectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
            print("🔌 Disconnected from peripheral")
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            
        case .poweredOff:
            print("Bluetooth is powered off")
            NotificationCenter.default.post(name: .bluetoothPoweredOff, object: nil)
            
        case .resetting:
            print("Bluetooth Resetting")
            
        default:
            print("Unknown state")
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {

        let deviceName = peripheral.name ?? "Unknown"

        // Filter only ESP32_Fluffy
        if deviceName == "ESP32_Fluffy" {
            if !peripherals.contains(where: { $0.identifier == peripheral.identifier }) {
                peripherals.append(peripheral)
                print("Added → \(deviceName)")
               // bluetoothTableRef.reloadData()
                NotificationCenter.default.post(name: .bluetoothDeviceUpdated, object: nil)
            }
        } else {
            print("Ignored → \(deviceName)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("✅ CONNECTED → \(peripheral.name ?? "Unknown")")
        centralManager.stopScan()
        print("⛔️ Scan stopped after connection")
        peripheral.delegate = self
        
        // Discover services on ESP32
        peripheral.discoverServices([serviceUUID])
        let deviceName = peripheral.name ?? "Unnamed Device"
        saveDeviceToCoreData(name: deviceName)
        NotificationCenter.default.post(name: .deviceSavedToCoreData, object: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("❌ Failed to connect: \(error?.localizedDescription ?? "Unknown Error")")
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        
        if let error = error {
            print("Service discovery error: \(error.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            print("Service → \(service.uuid)")
            
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                        didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        
        for char in service.characteristics ?? [] {
            
            print("Characteristic Found → \(char.uuid) props: \(char.properties)")
            
            // Enable NOTIFY
            if char.properties.contains(.notify) {
                notifyCharacteristic = char
                peripheral.setNotifyValue(true, for: char)
                print("📡 NOTIFY enabled")
            }
            
            // Assign WRITE
            if char.properties.contains(.write) || char.properties.contains(.writeWithoutResponse) {
                writeCharacteristic = char
                print("✏️ WRITE characteristic assigned")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        
        guard let data = characteristic.value,
              let text = String(data: data, encoding: .utf8) else { return }
        
        print("📥 Received → \(text)")
        
        if text.starts(with: "SCAN:") {
            
            let cleanText = text.replacingOccurrences(of: "SCAN:", with: "")
            
            scannedList = cleanText
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            
            print("📡 Parsed SSIDs → \(scannedList)")
//            DispatchQueue.main.async {
//                self.goToNextScreen()
//            }
            NotificationCenter.default.post(
                name: .wifiScanCompleted,
                object: nil,
                userInfo: ["list": self.scannedList]
            )
        }
        if text == "SUCCESS" {
            print("🎉 WiFi SUCCESS received")
            NotificationCenter.default.post(name: .wifiSuccess, object: nil)
            return
        }
        if text == "ERROR:UNKNOWN" {
            print("❌ WiFi ERROR UNKNOWN received")
            NotificationCenter.default.post(name: .wifiErrorUnknown, object: nil)
            return
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing value: \(error.localizedDescription)")
        } else {
            print("Value written successfully")
        }
    }
    
    func saveDeviceToCoreData(name: String) {
        let context = CoreDataManager.shared.context

        let device = FluffDevices(context: context)
        device.name = name

        CoreDataManager.shared.save()
    }
}

extension Notification.Name {
    static let bluetoothPoweredOff = Notification.Name("bluetoothPoweredOff")
}

extension Notification.Name {
    static let wifiScanCompleted = Notification.Name("wifiScanCompleted")
}
extension Notification.Name {
    static let bluetoothDeviceUpdated = Notification.Name("bluetoothDeviceUpdated")
}
extension Notification.Name {
    static let wifiSuccess = Notification.Name("wifiSuccess")
    static let wifiErrorUnknown = Notification.Name("wifiErrorUnknown")
}
extension Notification.Name {
    static let deviceSavedToCoreData = Notification.Name("deviceSavedToCoreData")
}
