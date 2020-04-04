//
//  QuestionaryViewController+Layout.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import UIKit
import SnapKit

// MARK:  Load View
extension QuestionaryViewController {
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .screenDarkBackground
        
        let topBar = UIView()
        topBar.backgroundColor = .clear
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let title = makeTitle()
        topBar.addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let nextButton = makeNextButton()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(48)
        }
        
        let tableView = UITableView()
        tableView.backgroundColor = .screenDarkBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        self.view = view
        self.topBar = topBar
        self.titleLbl = title
        self.tableView = tableView
        self.nextButton = nextButton
    }
    
}

// MARK:  View Factory Methods
extension QuestionaryViewController {
    
    private func makeTitle() -> UILabel {
        let label = UILabel()
        label.textColor = .textLightColor
        label.font = .avenirBoldOfSize(20)
        label.text = "Welcome"
        return label
    }
    
    private func makeNextButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .accentColor
        button.titleLabel?.font = .avenirBoldOfSize(20)
        button.titleLabel?.textColor = .white
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton(_:)), for: .touchUpInside)
        button.alpha = 0
        button.isEnabled = false
        return button
    }
}
