//
//  Answer+Verification.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 08.04.2020.
//

import Foundation

enum AnswerVerificationError: Error {
    case invalid
}

extension AnswerDescription {
    
    func verifyAnswer(_ answer: Answer) -> Result<Answer,Error> {
        
        switch type {
        case let .singleChoice(options):
            
            guard let option = answer.option else {
                return .failure(AnswerVerificationError.invalid)
            }
            
            guard options.contains(option) else {
                return .failure(AnswerVerificationError.invalid)
            }
            
            return .success(answer)
            
        case let .numberRange(range):
            
            guard var selectedRange = answer.range else {
                return .failure(AnswerVerificationError.invalid)
            }
            
            guard selectedRange.to <= range.to && selectedRange.from >= range.from else {
                return .success(.range(range))
            }
            
            guard selectedRange.from <= selectedRange.to else {
                selectedRange.to = selectedRange.from
                return .success(.range(selectedRange))
            }
            
            return .success(answer)
        }
    }
}
