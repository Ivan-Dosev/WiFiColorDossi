//
//  ColorView.swift
//  WiFiColorDossi
//
//  Created by Ivan Dimitrov on 11.01.21.
//

import SwiftUI
import CryptoKit

struct ColorView: View {
    
    @ObservedObject var colorService = ColorService()
    
    
    @State var text           : String = ""
    @State var numberID       : String = ""
    @State var sendedMassage  : String = ""
//    @State var privateID_Key : Curve25519.Signing.PrivateKey = Curve25519.Signing.PrivateKey()
    
   var privateID_Key : Curve25519.Signing.PrivateKey {
    
        if let data = UserDefaults.standard.data(forKey: "PrivateKey") {
            
              return try! Curve25519.Signing.PrivateKey(rawRepresentation: data)
            
        }else{
              let kay = Curve25519.Signing.PrivateKey()
                        UserDefaults.standard.set( kay.rawRepresentation, forKey: "PrivateKey")
           return kay
        }
    }
    
    var body: some View {
        VStack {
        
            VStack {
                Text("\(text)")
                    .foregroundColor(.red)
            }
            .padding()
            .padding()
            
            Button(action: {
//                self.change(color: .red)
//                let model = Model(peerID: "peerID is 9900770011".data(using: .utf8)!, massige: Data())
//                let madelData =  try JSONEncoder().encode(model)
                colorService.send(colorName: aloID())
            }) {
                Text("Send Public Key")
                    .padding()
            }
            
            Button(action: {
//                self.change(color: .yellow)
                colorService.send(colorName: aloData())
            }) {
                Text("Send Data")
                    .padding()
            }
            
            Section {
                Text("Public Kay: \(numberID)")
                    .padding()
            }
            Section {
                Text("recive > : \(sendedMassage)")
                    .padding()
            }

        }
        .onAppear(){
            colorService.delegate = self
        }
    }
    func aloID() -> Data {
        let model = Model(peerID: privateID_Key.publicKey.rawRepresentation, massige: Data())
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    
    func aloData() -> Data {
        let model = Model(peerID: Data(), massige: "data is arda ".data(using: .utf8)!)
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}

 struct Model   :  Codable {
    
    var peerID  : Data
    var massige : Data
}
