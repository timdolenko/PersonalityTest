//
//  MockDataProvider.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import Foundation

struct MockDataProvider {
    
    static func provideQuestions() -> QuestionDataResponse {
        guard let path = Bundle.main.url(forResource: "personality_test", withExtension: "json") else { fatalError() }
        
        do {
            let data = try Data(contentsOf: path)
            let response = try! JSONDecoder().decode(QuestionDataResponse.self, from: data)
            
            return response
        } catch {
            fatalError()
        }
    }
}
