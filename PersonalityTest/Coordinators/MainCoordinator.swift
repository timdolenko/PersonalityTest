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
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
}
