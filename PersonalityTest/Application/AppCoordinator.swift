import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        navigationController.isNavigationBarHidden = true
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let questionarySceneDIContainer = appDIContainer.makeQuestionarySceneDIContainer()
        let coordinator = questionarySceneDIContainer.makeQuestionaryFlowCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
