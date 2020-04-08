//
//  QuestionsSceneDIContainer.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import UIKit
import Networking

final class QuestionarySceneDIContainer {
    
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
    
    func makeQuestionaryViewModel() -> QuestionaryViewModel {
        QuestionaryViewModel(repository: makeQuestionsRepository())
    }
    
    func makeQuestionaryViewController() -> QuestionaryViewController {
        QuestionaryViewController(viewModel: makeQuestionaryViewModel())
    }
}

extension QuestionarySceneDIContainer: QuestionaryCoordinatorDependencies {
    
    func makeQuestionaryFlowCoordinator(navigationController: UINavigationController) -> QuestionaryCoordinator {
        QuestionaryCoordinator(navigationController: navigationController, dependencies: self)
    }
}
