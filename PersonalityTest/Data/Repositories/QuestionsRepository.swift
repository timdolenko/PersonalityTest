//
//  QuestionsRepository.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

protocol QuestionsRepositoryProtocol {
    @discardableResult
    func fetchQuestions(completion: @escaping (Result<QuestionList, Error>) -> Void) -> Cancellable?
}

final class QuestionsRepository {
    
    private let dataTransferService: DataTransferServiceProtocol
    
    init(dataTransferService: DataTransferServiceProtocol) {
        self.dataTransferService = dataTransferService
    }
}

extension QuestionsRepository: QuestionsRepositoryProtocol {
    
    public func fetchQuestions(completion: @escaping (Result<QuestionList, Error>) -> Void) -> Cancellable? {
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
}
