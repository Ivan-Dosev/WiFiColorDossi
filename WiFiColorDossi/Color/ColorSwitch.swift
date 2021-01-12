//
//  ColorSwitch.swift
//  WiFiColorDossi
//
//  Created by Ivan Dimitrov on 11.01.21.
//

import UIKit

extension ColorView : ColorServiceDelegate {

    func connectedDevicesChanged(manager: ColorService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.text = "Connections: \(connectedDevices)"
        }
    }

    func colorChanged(manager: ColorService, dataModel: Data) {
        OperationQueue.main.addOperation {
            
            let dataFromModel = try! JSONDecoder().decode(Model.self, from: dataModel)
           
            if !dataFromModel.peerID.isEmpty {
                self.numberID = String(decoding: dataFromModel.peerID, as: UTF8.self)
            
            }
            if !dataFromModel.massige.isEmpty {
                self.sendedMassage = String(decoding: dataFromModel.massige, as: UTF8.self)
            }
//            switch colorString {
//            case "red":
//                self.change(color: .red)
//            case "yellow":
//                self.change(color: .yellow)
//            default:
//                NSLog("%@", "Unknown color value received: \(colorString)")
//            }
        }
    }
    func change(color : Data) {
        self.numberID = String(decoding: color, as: UTF8.self)
    }
}
