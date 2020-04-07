//
//  QuestionsSceneDIContainer.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

final class QuestionsSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferServiceProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeQuestionsRepository() -> QuestionsRepositoryProtocol {
        QuestionsRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
