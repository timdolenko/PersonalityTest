//
//  Answer.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

public enum Answer {
    case option(String)
    case number(Int)
    
    public var option: String? {
        get {
            guard case let .option(value) = self else { return nil }
            return value
        }
        set {
            guard case .option = self, let newValue = newValue else { return }
            self = .option(newValue)
        }
    }
    
    public var number: Int? {
        get {
            guard case let .number(value) = self else { return nil }
            return value
        }
        set {
            guard case .number = self, let newValue = newValue else { return }
            self = .number(newValue)
        }
    }
}
