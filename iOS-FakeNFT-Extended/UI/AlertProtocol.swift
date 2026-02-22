//
//  AlertProtocol.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 19.02.2026.
//

protocol AlertProtocol {
    var alertTitle: String { get }
    func cancelPaymentRequest()
    func repeatNetworkRequest() async
}
