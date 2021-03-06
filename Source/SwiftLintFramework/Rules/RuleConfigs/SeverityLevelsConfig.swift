//
//  SeverityLevelsConfig.swift
//  SwiftLint
//
//  Created by Scott Hoyt on 1/19/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Foundation

public struct SeverityLevelsConfig: RuleConfig, Equatable {
    var warning: Int
    var error: Int?

    var params: [RuleParameter<Int>] {
        if let error = error {
            return [RuleParameter(severity: .Error, value: error),
                RuleParameter(severity: .Warning, value: warning)]
        }
        return [RuleParameter(severity: .Warning, value: warning)]
    }

    mutating public func setConfig(config: AnyObject) throws {
        if let config = [Int].arrayOf(config) where !config.isEmpty {
            warning = config[0]
            error = (config.count > 1) ? config[1] : nil
        } else if let config = config as? [String: Int]
                where !config.isEmpty && Set(config.keys).isSubsetOf(["warning", "error"]) {
            warning = config["warning"] ?? warning
            error = config["error"]
        } else {
            throw ConfigurationError.UnknownConfiguration
        }
    }
}

public func == (lhs: SeverityLevelsConfig, rhs: SeverityLevelsConfig) -> Bool {
    return lhs.warning == rhs.warning && lhs.error == rhs.error
}
