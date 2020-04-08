//
//  QuestionsRepository.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation
import Networking

protocol QuestionsRepositoryProtocol {
    @discardableResult
    func fetchQuestions(completion: @escaping (Result<QuestionList, Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func saveAnswers(answers: [Question:Answer], completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable?
}

final class QuestionsRepository {
    
    private let dataTransferService: DataTransferServiceProtocol
    
    init(dataTransferService: DataTransferServiceProtocol) {
        self.dataTransferService = dataTransferService
    }
}

extension QuestionsRepository: QuestionsRepositoryProtocol {
    
    public func fetchQuestions(completion: @escaping (Result<QuestionList, Error>) -> Void)
        -> Cancellable? {
        let endpoint = Endpoints.getQuestions()
        
        let networkTask = dataTransferService.request(with: endpoint) { (response: Result<QuestionsResponseDTO, Error>) in
            switch response {
            case let .success(questionsResponseDTO):
                
                do {
                    let questionList = try questionsResponseDTO.mapToDomain()
                    
                    completion(.success(questionList))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
        return RepositoryTask(networkTask: networkTask)
    }
    
    public func saveAnswers(
        answers: [Question:Answer],
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        let endpoint = Endpoints.saveAnswers(with: SaveAnswersRequestDTO(answers: answers))
        
        let networkTask = dataTransferService.request(with: endpoint) { (response) in
            completion(response)
        }
        
        return RepositoryTask(networkTask: networkTask)
    }
}
