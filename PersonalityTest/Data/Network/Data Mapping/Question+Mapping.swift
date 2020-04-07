//
//  Question.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

struct QuestionsResponseDTO: Decodable {
    let questions: [QuestionDTO]
    let categories: [String]
}

extension QuestionsResponseDTO {
    class QuestionDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case question
            case category
            case questionType = "question_type"
        }
        let question: String
        let category: String
        let questionType: QuestionTypeDTO
    }
}

extension QuestionsResponseDTO.QuestionDTO {
    struct QuestionTypeDTO: Decodable {
        let type: QuestionTypeDTO
        let options: [String]?
        let range: NumberRangeDTO?
        let condition: ConditionDTO?
    }
}

extension QuestionsResponseDTO.QuestionDTO.QuestionTypeDTO {
    enum QuestionTypeDTO: String, Decodable {
        case singleChoice = "single_choice"
        case singleChoiceConditional = "single_choice_conditional"
        case numberRange = "number_range"
    }
    
    struct NumberRangeDTO: Decodable {
        let from: Int
        let to: Int
    }
    
    struct ConditionDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case predicate
            case ifPositive = "if_positive"
        }
        let predicate: PredicateDTO
        let ifPositive: QuestionsResponseDTO.QuestionDTO
    }
}

extension QuestionsResponseDTO.QuestionDTO.QuestionTypeDTO.ConditionDTO {
    struct PredicateDTO: Decodable {
        let exactEquals: [String]
    }
}

enum DataMappingError: Error {
    case inconsistentData
}

extension QuestionsResponseDTO {
    func mapToDomain() throws -> QuestionList {
        QuestionList(
            questions: try questions.map { try $0.mapToDomain() },
            categories: categories
        )
    }
}

extension QuestionsResponseDTO.QuestionDTO {
    func mapToDomain() throws -> Question {
        Question(
            title: question,
            category: category,
            answerDescription: try questionType.mapToDomain()
        )
    }
}

extension QuestionsResponseDTO.QuestionDTO.QuestionTypeDTO {
    func mapToDomain() throws -> AnswerDescription {
        
        let domainType: AnswerDescription.AnswerType
        
        switch type {
        case .singleChoice,.singleChoiceConditional:
            guard let options = options else {
                throw DataMappingError.inconsistentData
            }
            
            domainType = .singleChoice(options)
            
            if type == .singleChoiceConditional && condition == nil {
                throw DataMappingError.inconsistentData
            }
            
        case .numberRange:
            guard let range = range else {
                throw DataMappingError.inconsistentData
            }
            
            domainType = .numberRange(range.mapToDomain())
        }
        
        return AnswerDescription(type: domainType, condition: try condition?.mapToDomain())
    }
}

extension QuestionsResponseDTO.QuestionDTO.QuestionTypeDTO.NumberRangeDTO {
    func mapToDomain() -> AnswerDescription.NumberRange {
        AnswerDescription.NumberRange(from: from, to: to)
    }
}

extension QuestionsResponseDTO.QuestionDTO.QuestionTypeDTO.ConditionDTO {
    func mapToDomain() throws -> AnswerDescription.Condition {
        AnswerDescription.Condition(
            predicate: predicate.mapToDomain(),
            ifPositive: try ifPositive.mapToDomain()
        )
    }
}

extension QuestionsResponseDTO.QuestionDTO.QuestionTypeDTO.ConditionDTO.PredicateDTO {
    func mapToDomain() -> AnswerDescription.Condition.Predicate {
        .exactEquals(exactEquals)
    }
}
