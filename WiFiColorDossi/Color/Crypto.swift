//
//  Crypto.swift
//  WiFiColorDossi
//
//  Created by Ivan Dimitrov on 12.01.21.
//

import CryptoKit
import SwiftUI

class Arda: NSObject,ObservableObject {
    
    
  
    let secretKey = "bvcxz"

    // create sender Sign Key
    let senderSigningKey = Curve25519.Signing.PrivateKey()
//    let senderSigningPublicKey = senderSigningKey.publicKey
    
    
    // create receiver Sign Key
    let receiverEncryptionKey = Curve25519.KeyAgreement.PrivateKey()

    
    func encryptArda(_ data: Data) throws ->  Data {
        
    let  theirEncryptionKey = Curve25519.KeyAgreement.PrivateKey()
    let  ourSigningKey      = Curve25519.Signing.PrivateKey()
        
    // Create a salt for key derivation.
    let protocolSalt       = secretKey.data(using: .utf8)!
    let ephemeralKey       = Curve25519.KeyAgreement.PrivateKey()
    let ephemeralPublicKey = ephemeralKey.publicKey.rawRepresentation
        let sharedSecret       = try ephemeralKey.sharedSecretFromKeyAgreement(with: theirEncryptionKey.publicKey)
    let symmetricKey       = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
    salt:              protocolSalt,
    sharedInfo:        ephemeralPublicKey ,
//    sharedInfo:        ephemeralPublicKey + theirEncryptionKey.rawRepresentation + ourSigningKey.publicKey.rawRepresentation,
    outputByteCount:   32)
    let ciphertext = try ChaChaPoly.seal(data, using: symmetricKey).combined
        let signature = try ourSigningKey.signature(for: ciphertext + ephemeralPublicKey + theirEncryptionKey.publicKey.rawRepresentation)
        
        let encode = Mara(ephemeralPublicKey: ephemeralPublicKey, ciphertext: ciphertext, signature: signature, ourKeyEncryptionKey: theirEncryptionKey.rawRepresentation, theirSigningKey:  ourSigningKey.publicKey.rawRepresentation)
    let encodeData = try JSONEncoder().encode(encode)
        
        return encodeData
    }
    
    func decrypt(_ sealedMessage: Data ) throws -> Data {
//    func decrypt(_ sealedMessage: Data, using ourKeyEncryptionKey: Curve25519.KeyAgreement.PrivateKey, from theirSigningKey: Curve25519.Signing.PublicKey) throws -> Data {
//        (ephmeralPublicKeyData: Data, ciphertext: Data, signature: Data)
    let message = "no send data".data(using: .utf8)
    let message1 = "no arda".data(using: .utf8)
    let sameEmployee = try? JSONDecoder().decode(Mara.self, from: sealedMessage)
        
        guard let ephmeralPublicKeyData = sameEmployee?.ephemeralPublicKey else { return message! }
    
        guard let ciphertext = sameEmployee?.ciphertext else { return message1! }

        guard let signature = sameEmployee?.signature else { return message! }
        
        let ourKeyEncryptionKey = try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: sameEmployee!.ourKeyEncryptionKey)
        let theirSigningKey     = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: sameEmployee!.theirSigningKey)
        
        
//    // Create a salt for key derivation.
    let protocolSalt = secretKey.data(using: .utf8)!
    let ephemeralKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: ephmeralPublicKeyData)
    let sharedSecret = try ourKeyEncryptionKey.sharedSecretFromKeyAgreement(with: ephemeralKey)
    let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
    salt:              protocolSalt,
    sharedInfo:        ephemeralKey.rawRepresentation ,
//    sharedInfo:        ephemeralKey.rawRepresentation + ourKeyEncryptionKey.publicKey.rawRepresentation + theirSigningKey.rawRepresentation,
    outputByteCount:   32)
    let sealedBox = try ChaChaPoly.SealedBox(combined: ciphertext)
    let keyData = try ChaChaPoly.open(sealedBox, using: symmetricKey)
//        print(keyData)
        return keyData
    }
}

struct Mara: Codable {
   
   var ephemeralPublicKey    : Data
   var ciphertext            : Data
   var signature             : Data
   var ourKeyEncryptionKey   : Data
   var theirSigningKey       : Data

}
