//
//  PaymentType.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 18.02.2026.
//

struct PaymentType {
    var imageName: String
    var type: String
    var shortForm: String
    
    init(crypto: Crypto) {
        self.imageName = crypto.rawValue
        self.type = crypto.rawValue
        self.shortForm = crypto.shortForm
    }
}

enum Crypto: String, CaseIterable {
    case Bitcoin
    case Dogecoin
    case Tether
    case Apecoin
    case Solana
    case Ethereum
    case Cardano
    case ShibaInu
    
    var shortForm: String {
        switch self {
        case .Bitcoin: return "BTS"
        case .Dogecoin: return "DOGE"
        case .Tether: return "USDT"
        case .Apecoin: return "APE"
        case .Solana: return "SOL"
        case .Ethereum: return "ETH"
        case .Cardano: return "ADA"
        case .ShibaInu: return "SHIB"
        }
    }
    
    static func createCryptoArray() -> [Crypto] {
        var arrayToReturn = [Crypto]()
        
        for i in self.allCases {
            arrayToReturn.append(i)
        }
        
        return arrayToReturn
    }
}
