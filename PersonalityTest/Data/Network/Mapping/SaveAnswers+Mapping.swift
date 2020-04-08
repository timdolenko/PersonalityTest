//
//  SaveAnswers+Mapping.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 08.04.2020.
//

import Foundation

struct SaveAnswersRequestDTO: Encodable {
    let answers: [AnswerDTO]
}

extension SaveAnswersRequestDTO {
    struct AnswerDTO: Encodable {
        let question: String
        let category: String
        let option: String?
        let number: Int?
        let range: QuestionsResponseDTO.QuestionDTO.QuestionTypeDTO.NumberRangeDTO?
    }
}

extension SaveAnswersRequestDTO.AnswerDTO {
    init(domainQuestion: Question, domainAnswer: Answer) {
        question = domainQuestion.title
        category = domainQuestion.category
        option = domainAnswer.option
        number = domainAnswer.number
        range = QuestionsResponseDTO
            .QuestionDTO
            .QuestionTypeDTO
            .NumberRangeDTO(numberRange: domainAnswer.range)
    }
}

extension SaveAnswersRequestDTO {
    init(answers: [Question:Answer]) {
        self.answers = answers.map { AnswerDTO(domainQuestion: $0.key, domainAnswer: $0.value) }
    }
}

extension QuestionsResponseDTO.QuestionDTO.QuestionTypeDTO.NumberRangeDTO {
    init?(numberRange: AnswerDescription.NumberRange?) {
        guard let range = numberRange else { return nil }
        from = range.from
        to = range.to
    }
}
