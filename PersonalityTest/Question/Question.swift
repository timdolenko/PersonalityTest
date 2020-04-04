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

public struct QuestionType {
    
    public typealias Options = [String]
    
    public struct NumberRange: Decodable {
        var from: Int
        var to: Int
    }
    
    public struct Condition: Decodable {
        
        public enum Predicate: Decodable {
            
            enum CodingKeys: String, CodingKey {
                case exactEquals
            }
            
            case exactEquals([String])
            
            public init(from decoder: Decoder) throws {
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
        
        public var predicate: Predicate
        public var ifPositive: Question?
        public var ifNegative: Question?
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            predicate = try container.decode(Predicate.self, forKey: .predicate)
            ifPositive = try? container.decode(Question.self, forKey: .ifPositive)
            ifNegative = try? container.decode(Question.self, forKey: .ifNegative)
        }
    }
    
    public enum AnswerType {
        case singleChoice(Options)
        case numberRange(NumberRange)
        
        public var range: NumberRange? {
            get {
                guard case let .numberRange(value) = self else { return nil }
                return value
            }
            set {
                guard case .numberRange = self, let newValue = newValue else { return }
                self = .numberRange(newValue)
            }
        }
        
        public var options: Options? {
            get {
                guard case let .singleChoice(value) = self else { return nil }
                return value
            }
            set {
                guard case .singleChoice = self, let newValue = newValue else { return }
                self = .singleChoice(newValue)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case options
        case range
        case condition
    }
    
    var typeString: QuestionTypeString
    var answerType: AnswerType
    var condition: QuestionType.Condition?
}

extension QuestionType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        typeString = try container.decode(QuestionTypeString.self, forKey: .type)
        
        switch typeString {
        case .singleChoice, .singleChoiceConditional:
            
            let options = try container.decode(Options.self, forKey: .options)
        
            answerType = .singleChoice(options)
            
        case .numberRange:
            
            let range = try container.decode(NumberRange.self, forKey: .range)
            
            answerType = .numberRange(range)
        }
        
        condition = try? container.decode(Condition.self, forKey: .condition)
    }
}

public enum Answer {
    case option(String)
    case number(Int)
}

public class Question: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case question
        case category
        case questionType = "question_type"
    }
    
    var title: String
    var category: String
    var type: QuestionType
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .question)
        category = try container.decode(String.self, forKey: .category)
        type = try container.decode(QuestionType.self, forKey: .questionType)
    }
}

extension QuestionType.Condition {
    public func isFullfilled(with answer: Answer) -> Bool {
        switch predicate {
        case let .exactEquals(predicateArray):
            
            guard let lhs = predicateArray[safe: 0],
                  let rhs = predicateArray[safe: 1] else {
                return false
            }
            
            if lhs == "${selection}" {
                
                if case let .option(text) = answer, text == rhs {
                    return true
                }
                
            }
            
            return false
        }
    }
    public func nextQuestion(for answer: Answer) -> Question? {
        if isFullfilled(with: answer) {
            return ifPositive
        } else {
            return ifNegative
        }
    }
}

extension Question: Hashable {
    public static func == (lhs: Question, rhs: Question) -> Bool {
        lhs.title == rhs.title && lhs.category == rhs.category
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(category)
    }
}
