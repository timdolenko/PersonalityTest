//
//  Endpoints.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

struct Endpoints {
    
    static func getQuestions() -> Endpoint<QuestionsResponseDTO> {
        Endpoint(path: "/personality_test.json", method: .get)
    }
    
}
