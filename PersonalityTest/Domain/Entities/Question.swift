//
//  Question.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import Foundation

public typealias QuestionCategory = String

public class Question {
    
    var title: String
    var category: QuestionCategory
    var answerDescription: AnswerDescription
    
    init(title: String, category: QuestionCategory, answerDescription: AnswerDescription) {
        self.title = title
        self.category = category
        self.answerDescription = answerDescription
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
