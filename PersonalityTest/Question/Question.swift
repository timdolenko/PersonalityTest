//
//  Question.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import Foundation

enum QuestionTypeString: String, Codable {
    case singleChoice = "single_choice"
    case singleChoiceConditional = "single_choice_conditional"
    case numberRange = "number_range"
}

enum QuestionType {
    
    typealias Options = [String]
    
    struct NumberRange: Decodable {
        var from: Int
        var to: Int
    }
    
    struct Condition: Decodable {
        
        enum Predicate: Decodable {
            
            enum CodingKeys: String, CodingKey {
                case exactEquals
            }
            
            case exactEquals([String])
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                let predicate = try container.decode([String].self, forKey: .exactEquals)
                self = .exactEquals(predicate)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case predicate
            case ifPositive = "if_positive"
            case ifNegative = "if_negative"
        }
        
        var predicate: Predicate
        var ifPositive: Question?
        var ifNegative: Question?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            predicate = try container.decode(Predicate.self, forKey: .predicate)
            ifPositive = try? container.decode(Question.self, forKey: .ifPositive)
            ifNegative = try? container.decode(Question.self, forKey: .ifNegative)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case options
        case range
        case condition
    }
    
    // MARK:  Cases
    case singleChoice(options: [String])
    case singleChoiceConditional(options: [String], condition: QuestionType.Condition?)
    case numberRange(range: NumberRange)
}

extension QuestionType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeString = try container.decode(QuestionTypeString.self, forKey: .type)
        
        switch typeString {
        case .singleChoice:
            
            let options = try container.decode(Options.self, forKey: .options)
        
            self = .singleChoice(options: options)
            
        case .singleChoiceConditional:
            
            let options = try container.decode(Options.self, forKey: .options)
            let condition = try container.decode(Condition.self, forKey: .condition)
            
            self = .singleChoiceConditional(options: options, condition: condition)
            
        case .numberRange:
            
            let range = try container.decode(NumberRange.self, forKey: .range)
            
            self = .numberRange(range: range)
        }
    }
    
    var typeString: QuestionTypeString {
        switch self {
        case .singleChoice(_):
            return .singleChoice
        case .singleChoiceConditional(options: _, condition: _):
            return .singleChoiceConditional
        case .numberRange(_):
            return .numberRange
        }
    }
}

class Question: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case question
        case category
        case questionType = "question_type"
    }
    
    var title: String
    var category: String
    var type: QuestionType
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .question)
        category = try container.decode(String.self, forKey: .category)
        type = try container.decode(QuestionType.self, forKey: .questionType)
    }
}
