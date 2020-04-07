//
//  AppDIContainer.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()

    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)

        let networkService = NetworkService(config: config)

        return DataTransferService(networkService: networkService)
    }()
    
    func makeQuestionarySceneDIContainer() -> QuestionarySceneDIContainer {
        let dependencies = QuestionarySceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        
        return QuestionarySceneDIContainer(dependencies: dependencies)
    }
}
