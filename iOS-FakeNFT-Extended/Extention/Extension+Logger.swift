//
//  Extension+Logger.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир on 25.02.2026.
//

import Logging

extension Logger {
    static let shared: Logger = {
        var logger = Logger(label: "iOS-FakeNFT-Extended")
        logger.logLevel = .debug
        return logger
    }()
}
