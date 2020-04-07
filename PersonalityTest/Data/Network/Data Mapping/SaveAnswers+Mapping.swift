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
    }
}

extension SaveAnswersRequestDTO.AnswerDTO {
    init(domainQuestion: Question, domainAnswer: Answer) {
        question = domainQuestion.title
        category = domainQuestion.category
        option = domainAnswer.option
        number = domainAnswer.number
    }
}

extension SaveAnswersRequestDTO {
    init(answers: [Question:Answer]) {
        self.answers = answers.map { AnswerDTO(domainQuestion: $0.key, domainAnswer: $0.value) }
    }
}
