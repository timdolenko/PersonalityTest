//
//  MockDataProvider.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import Foundation

struct MockDataProvider {
    
    static func provideQuestionsDTO() -> QuestionsResponseDTO {
        guard let path = Bundle.main.url(forResource: "personality_test", withExtension: "json") else { fatalError() }
        
        do {
            let data = try Data(contentsOf: path)
            let response = try! JSONDecoder().decode(QuestionsResponseDTO.self, from: data)
            
            return response
        } catch {
            fatalError()
        }
    }
    
    static func provideQuestionsWithDelay(
        _ completion: @escaping (Result<QuestionList,Never>) -> ()
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(try! provideQuestionsDTO().mapToDomain()))
        }
    }
    
    static func uploadResultsWithDelaySuccess(
        _ completion: @escaping (Result<Void,Error>) -> ()
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
        }
    }
    
    enum FakeError: Error {
        case corruptData(String)
    }
    
    static func uploadResultsWithDelayError(
        _ completion: @escaping (Result<Void,Error>) -> ()
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.failure(FakeError.corruptData("Something went wrong.")))
        }
    }
}
