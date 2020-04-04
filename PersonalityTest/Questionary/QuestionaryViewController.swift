//
//  QuestionaryViewController.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import UIKit

class QuestionaryViewController: UIViewController {
    
    weak var titleLbl: UILabel!
    weak var topBar: UIView!
    weak var nextButton: UIButton!
    weak var tableView: UITableView!
    
    weak var popup: PopupView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureTableView() {
        
    }
}

// MARK:  Popup
extension QuestionaryViewController {
    
    private func showPopup(_ message: String) {
        let popup = PopupView()
        popup.label.text = message
        popup.activityIndicator.startAnimating()
        popup.alpha = 0
        self.view.addSubview(popup)
        
        let animator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1) { [weak self] in
            guard let `self` = self else { return }
            self.tableView.alpha = 0
            self.nextButton.alpha = 0
            popup.alpha = 1
        }
        
        animator.startAnimation()
    }
    
    private func hidePopup() {
        guard let popup = popup else { return }
        popup.activityIndicator.stopAnimating()
        
        let animator = UIViewPropertyAnimator(duration: 0.1, dampingRatio: 1) {
            popup.alpha = 0
        }
        
        animator.addCompletion { (_) in
            popup.removeFromSuperview()
        }
        
        animator.startAnimation()
    }
}
