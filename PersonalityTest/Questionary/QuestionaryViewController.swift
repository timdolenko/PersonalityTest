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
    
    private var viewModel: QuestionaryViewModel!
    
    required convenience init(viewModel: QuestionaryViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPopup("Let’s wait for the questions")
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.register(
            QuestionTextCell.self, forCellReuseIdentifier: QuestionTextCell.identifier
        )
    }
    
    @objc func didTapNextButton(_ sender: UIButton) {
        
    }
}

extension QuestionaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK:  Popup
extension QuestionaryViewController {
    
    private func showPopup(_ message: String) {
        let popup = PopupView()
        popup.label.text = message
        popup.activityIndicator.startAnimating()
        popup.alpha = 0
        view.addSubview(popup)
        popup.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        view.layoutIfNeeded()
        
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
