//
//  CentralManager.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/25.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

import CoreBluetooth

protocol BluetoothCentralDelegate: NSObjectProtocol {
    func showInfo(_ text:String)
}

class CentralManager: NSObject,CBCentralManagerDelegate, CBPeripheralDelegate {

    weak var delegate: BluetoothCentralDelegate?
    
    var cent:CBCentralManager? = nil
    var peri:CBPeripheral? = nil
    
    
    override init() {
        super.init()
        cent = CBCentralManager.init(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey : "BLUETOOTH_CENTRAL_NAME",
                                                                           CBCentralManagerOptionShowPowerAlertKey : true])
        
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            scanForPeripheral()
        default:
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) default")
        }
        
    }
    
    //MARK scan peripheral
    func scanForPeripheral() {
        delegate?.showInfo("scan for peripherals")
        cent?.scanForPeripherals(withServices: [CBUUID.init(string: "AAAA")], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(RSSI) \(peripheral.identifier) \(advertisementData)")
    
        central.stopScan()
        
        peri = peripheral
        
        central.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey: true,
                                              CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) connected to \(peripheral.identifier)")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) service is \(String(describing: peripheral.services))")
        
        delegate?.showInfo("did connected to peripheral \(peripheral.identifier)")
        
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID.init(string: "AAAA")])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: error?.localizedDescription))")
        delegate?.showInfo("did fail connected to peripheral \(peripheral.identifier)")

    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    //MARK peripheral delegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: error?.localizedDescription))")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) service is \(String(describing: peripheral.services))")
        
        delegate?.showInfo("discover service count \(String(describing: peripheral.services?.count))")

        
        peripheral.discoverCharacteristics(nil, for: peripheral.services![0])
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: error?.localizedDescription))")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) character is \(String(describing: service.characteristics))")

        for char in service.characteristics! {
            
            if char.properties.rawValue & CBCharacteristicProperties.notify.rawValue == CBCharacteristicProperties.notify.rawValue  {
                print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) character is notify")
                delegate?.showInfo("add notify to \(char.uuid)")
                peripheral.setNotifyValue(true, for: char)
            }
            if char.properties.rawValue & CBCharacteristicProperties.read.rawValue == CBCharacteristicProperties.read.rawValue  {
                print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) character is read")
                delegate?.showInfo("read from \(char.uuid)")
                peripheral.readValue(for: char)
            }
            if char.properties.rawValue & CBCharacteristicProperties.write.rawValue == CBCharacteristicProperties.write.rawValue  {
                print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) character is write")
                delegate?.showInfo("wirte \"hello\" to \(char.uuid)")
                peripheral.writeValue("write to ".data(using: String.Encoding.utf8)!, for: char, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.showInfo("notify status change to \(characteristic.isNotifying)")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) error \(String(describing: error?.localizedDescription))")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.showInfo("write value for \(characteristic.uuid)")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) error \(String(describing: error?.localizedDescription))")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.showInfo("receive \(characteristic.uuid) value update \(String(describing: String.init(data: characteristic.value!, encoding: String.Encoding.utf8)))")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) error \(String(describing: error?.localizedDescription))")
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
