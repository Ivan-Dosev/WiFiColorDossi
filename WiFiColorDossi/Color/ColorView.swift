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
    @State var signingID       : String = ""
    @State var agreementID    : String = ""
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
    var privateAgreement_Key : Curve25519.KeyAgreement.PrivateKey {
        if let data = UserDefaults.standard.data(forKey: "AgreementKey") {
            
            return try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: data)
            
        }else{
            let kay = Curve25519.KeyAgreement.PrivateKey()
                        UserDefaults.standard.set( kay.rawRepresentation, forKey: "AgreementKey")
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
                colorService.send(colorName: senderSigningPublic())
            }) {
                Text("Send Public Key")
                    .padding()
            }
            
            Button(action: {
//                self.change(color: .yellow)
                colorService.send(colorName: senderData())
            }) {
                Text("Send Data")
                    .padding()
            }
            
            Section {
                VStack {
                    Text("signingID: \(signingID)")
                        .padding()
                    Divider()
                    Text("agreementID: \(agreementID)")
                        .padding()
                }

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
    func senderSigningPublic() -> Data {
        let model = Model(peerID: privateID_Key.publicKey.rawRepresentation, massige: Data(),isSender: true)
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    func keyAgreenentPublic() -> Data {
        let model = Model(peerID: privateAgreement_Key.publicKey.rawRepresentation, massige: Data(),isSender: false)
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    
    func senderData() -> Data {
        let model = Model(peerID: Data(), massige: "data is arda ".data(using: .utf8)!, isSender: true)
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    
    func answerData() -> Data {
        let model = Model(peerID: Data(), massige: "Ок".data(using: .utf8)!, isSender: false)
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
    
    var peerID   : Data
    var massige  : Data
    var isSender : Bool
}
