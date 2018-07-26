//
//  PeripheralManager.swift
//  MyDemoSwift
//
//  Created by 张鑫 on 2018/7/25.
//  Copyright © 2018年 张鑫. All rights reserved.
//

import UIKit

import CoreBluetooth

protocol BluetoothPeripheralDelegate: NSObjectProtocol {
    func showInfo(_ text:String)
}

class PeripheralManager: NSObject, CBPeripheralManagerDelegate {

    weak var delegate: BluetoothPeripheralDelegate?
    
    var peri:CBPeripheralManager? = nil
    var notifyChar:CBCharacteristic? = nil
    
    override init() {
        
        super.init()
        
        peri = CBPeripheralManager.init(delegate: self, queue: nil, options: [CBPeripheralManagerOptionRestoreIdentifierKey : "BLUETOOTH_PERIPHERAL_NAME",
                                                                              CBPeripheralManagerOptionShowPowerAlertKey : true])
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(CBPeripheralManager.authorizationStatus().rawValue)")
    }
    
    
    func send() {
        delegate?.showInfo("update value: hello noti")
        peri?.updateValue("hello noti".data(using: String.Encoding.utf8)!, for: notifyChar as! CBMutableCharacteristic, onSubscribedCentrals: nil)
    }
    
    //MARK delegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(peripheral.state.rawValue)")
        switch peripheral.state {
        case .poweredOn:
            //MARK  set service and characteristic
            let read = CBMutableCharacteristic.init(type: CBUUID.init(string: "A001"),
                                                    properties: CBCharacteristicProperties.read,
                                                    value: nil,
                                                    permissions: CBAttributePermissions.readable)

            let write = CBMutableCharacteristic.init(type: CBUUID.init(string: "A002"),
                                                    properties: CBCharacteristicProperties.write,
                                                    value: nil,
                                                    permissions: CBAttributePermissions.writeable)

            notifyChar = CBMutableCharacteristic.init(type: CBUUID.init(string: "A003"),
                                                    properties: CBCharacteristicProperties.notify,
                                                    value: nil,
                                                    permissions: CBAttributePermissions.readable)

//            notifyChar = notify
            
            let service = CBMutableService.init(type: CBUUID.init(string: "AAAA"), primary: true)
            service.characteristics = [read, write, notifyChar] as? [CBCharacteristic]
            
            peripheral.add(service)
            
        default:
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) default")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: error?.localizedDescription))")
            return
        }
        if !peripheral.isAdvertising {
            delegate?.showInfo("start advertising")
            peripheral.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [CBUUID.init(string: "AAAA")],
                                         CBAdvertisementDataLocalNameKey : "deviceName"])
        }
        
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) \(String(describing: error))")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    //MARK notification subscribe
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) max length \(central.maximumUpdateValueLength))")
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) subscribe to  \(characteristic))")
        
        delegate?.showInfo("subscribe to \(characteristic.uuid)")
        self.send()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) unsubscribe to  \(characteristic)")
        
        delegate?.showInfo("unsubscribe to \(characteristic.uuid)")
    }
    
    //MARK receive read
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        
        print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) offset is  \(request.offset)")
        request.value = "read resp".data(using: String.Encoding.utf8)
        delegate?.showInfo("resp read : <read resp>")
        peripheral.respond(to: request, withResult: CBATTError.Code.success)
    }
    
    //MARK receive write
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for req in requests {
            delegate?.showInfo("receive data: <\(String.init(data: req.value!, encoding: String.Encoding.utf8)!)>")
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) value is  \(String(describing: String.init(data: req.value!, encoding: String.Encoding.utf8)))")
            print("\(Date.init(timeIntervalSinceNow: 8*3600)) \(type(of: self)):\(#line) offset is  \(req.offset)")
            req.value = "write resp".data(using: String.Encoding.utf8)
            
            peripheral.respond(to: req, withResult: CBATTError.Code.success)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
