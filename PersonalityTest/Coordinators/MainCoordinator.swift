//
//  MainCoordinator.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        navigationController.isNavigationBarHidden = true
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = QuestionaryViewController(viewModel: QuestionaryViewModel())
        navigationController.pushViewController(controller, animated: false)
    }
}
