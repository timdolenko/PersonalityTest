import UIKit

protocol QuestionaryCoordinatorDependencies {
    func makeQuestionaryViewController() -> QuestionaryViewController
}

class QuestionaryCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependencies: QuestionaryCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: QuestionaryCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let controller = dependencies.makeQuestionaryViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: false)
    }
}
