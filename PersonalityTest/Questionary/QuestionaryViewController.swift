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
    
    private enum Section: Int, CaseIterable {
        case question
        case answer
    }
    
    required convenience init(viewModel: QuestionaryViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        viewModel.bind { [weak self] in
            self?.viewModelStateDidChange()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.send(.didRequestQuestions)
    }
    
    private func viewModelStateDidChange() {
        switch viewModel.state {
        case .initial:
            break
        case .loadingQuestions:
            showPopup("Let’s wait for the questions")
        case .didDisplay(_):
            hidePopupIfNeeded()
            
            tableView.reloadSections(IndexSet(arrayLiteral: 0,1), with: .left)
        
        case .didSelectAnswer(_, _):
            
            tableView.reloadSections(IndexSet(Section.answer.rawValue), with: .none)
        default:
            break
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.register(QuestionTextCell.self)
        tableView.register(AnswerOptionCell.self)
        tableView.register(AnswerOptionCell.self)
    }
    
    @objc func didTapNextButton(_ sender: UIButton) {
        
    }
}

// MARK:  Table View Delegate
extension QuestionaryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { Section.allCases.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        guard case let .didDisplay(question, _) = viewModel.state else { return 0 }
        
        switch section {
        case .question:
            return 1
        case .answer:
            
            switch question.type.answerType {
            case let .singleChoice(options: options):
                return options.count
            case .numberRange(_):
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        guard case let .didDisplay(question, _) = viewModel.state else { return UITableViewCell() }
        
        switch section {
        case .question:
            
            let cell = tableView.dequeue(QuestionTextCell.self, at: indexPath)
            
            cell.configure(with: question.title)
            
            return cell
            
        case .answer:
            
            switch question.type.answerType {
            case let .singleChoice(options: options):
                
                let option = options[indexPath.row]
                
                let cell = tableView.dequeue(AnswerOptionCell.self, at: indexPath)
                
                cell.configure(with: option)
                
                cell.setOption(selected: isOptionSelected(option))
                
                cell.didTap = { [weak self] in
                    self?.viewModel.send(.didSelectAnswer(question, .option(option)))
                }
                
                return cell
            case let .numberRange(range: range):
                
                let cell = tableView.dequeue(AnswerRangeCell.self, at: indexPath)
                
                cell.configure(with: AnswerRangeCell.RangeValue(current: selectedValue(), from: range.from, to: range.to))
                
                cell.didChangeValue = { [weak self] value in
                    self?.viewModel.send(.didSelectAnswer(question, .number(value)))
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        
        guard case let .didDisplay(question, _) = viewModel.state else { return 0 }
        
        switch section {
        case .question:
            
            let minimumCellHeight = QuestionTextCell.height(for: question.title, with: tableView.frame.width)
            
            let tableViewHeight = tableView.frame.height
            let answerSectionHeight = height(for: Section.answer.rawValue)
            
            let remainingHeight = tableViewHeight - answerSectionHeight
            
            return max(remainingHeight, minimumCellHeight)
        case .answer:
            
            switch question.type.answerType {
            case let .singleChoice(options: options):
                guard let option = options[safe: indexPath.row] else { return 0 }
                
                return AnswerOptionCell.height(for: option, with: tableView.frame.width)
            case .numberRange(_):
                
                return AnswerRangeCell.height
            }
        }
    }
    
    private func height(for section: Int) -> CGFloat {
        let sectionMargins = sectionMargin(for: section) * 2
        
        let sectionRows = 0..<tableView.numberOfRows(inSection: section)
        
        let sectionRowsTotalHeight = sectionRows
            .reduce(into: CGFloat.zero) { (result, row) in
            result += self.tableView(tableView, heightForRowAt: IndexPath(row: row, section: section))
        }
        
        return sectionMargins + sectionRowsTotalHeight
    }
    
    func sectionMargin(for section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return 0 }
        guard case .didDisplay(_, _) = viewModel.state else { return 0 }
        
        switch section {
        case .question:
            return 0
        case .answer:
           return 20
        }
    }
    
    func sectionMarginView() -> UIView {
        let view = UIView()
        view.backgroundColor = .elevatedDarkBackground
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int)
        -> UIView? { sectionMarginView() }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int)
        -> UIView? { sectionMarginView() }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int)
        -> CGFloat { sectionMargin(for: section) }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)
        -> CGFloat { sectionMargin(for: section) }
}

extension QuestionaryViewController {
    func isOptionSelected(_ option: String) -> Bool {
        guard case let .didSelectAnswer(_, answer) = viewModel.state else { return false }
        guard case let .option(text) = answer else { return false }
        return text == option
    }
    
    func selectedValue() -> Int {
        
        switch viewModel.state {
        case let .didDisplay(question):
            guard case let .numberRange(range: range) = question.type.answerType else { return 0 }
            return range.from
        case let .didSelectAnswer(question, answer):
            guard case let .numberRange(range: range) = question.type.answerType else { return 0 }
            guard case let .number(number) = answer else { return range.from }
            return number
        default:
            return 0
        }
    }
}

// MARK:  Popup
extension QuestionaryViewController {
    
    private func showPopup(_ message: String) {
        let popup = PopupView()
        self.popup = popup
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
    
    private func hidePopupIfNeeded() {
        guard let popup = popup else { return }
        popup.activityIndicator.stopAnimating()
        
        let animator = UIViewPropertyAnimator(duration: 0.1, dampingRatio: 1) { [weak self] in
            guard let `self` = self else { return }
            self.tableView.alpha = 1
            self.nextButton.alpha = 1
            popup.alpha = 0
        }
        
        animator.addCompletion { (_) in
            popup.removeFromSuperview()
        }
        
        animator.startAnimation()
    }
}
