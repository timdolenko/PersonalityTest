//
//  QuestionDataResponse.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import Foundation

struct QuestionDataResponse: Decodable {
    
    var questions: [Question]
    var categories: [String]
    
}
