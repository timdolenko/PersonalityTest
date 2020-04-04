//
//  Question.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import Foundation

enum QuestionTypeString: String, Codable {
    case singleChoice
    case numberRange
}

enum QuestionType {
    
    case singleChoice(options: [String])
    case numberRange(range: Question.NumberRange)
    
    var typeString: QuestionTypeString {
        switch self {
        case .singleChoice(_):
            return .singleChoice
        case .numberRange(_):
            return .numberRange
        }
    }
}

class Question: Decodable {
    
    typealias Options = [String]
    
    struct NumberRange: Decodable {
        var from: Int
        var to: Int
    }
    
    enum Category: String, Codable {
        case hardFact = "hard_fact"
        case lifestyle
        case introversion
        case passion
    }
    
    struct Condition {
        
        enum Predicate {
            case exactEquals([String])
        }
        
        var predicate: Predicate
        var ifPositive: Question?
        var ifNegative: Question?
    }

    struct Description: Decodable {
        
        enum CodingKeys: String, CodingKey {
            case type
            case options
            case range
            case condition
        }
        
        var type: QuestionType
        var condition: Question.Condition?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let typeString = try container.decode(QuestionTypeString.self, forKey: .type)
            
            switch typeString {
            case .singleChoice:
                
                let options = try container.decode(Options.self, forKey: .options)
                type = QuestionType.singleChoice(options: options)
                
            case .numberRange:
                
                let range = try container.decode(NumberRange.self, forKey: .range)
                type = QuestionType.numberRange(range: range)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case question
        case category
        case questionType = "question_type"
    }
    
    var title: String
    var category: Category
    var type: Description
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .question)
        category = try container.decode(Category.self, forKey: .category)
        type = try container.decode(Description.self, forKey: .questionType)
    }
}
