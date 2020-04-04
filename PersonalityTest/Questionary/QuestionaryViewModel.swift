//
//  QuestionaryViewModel.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import Foundation

class QuestionaryViewModel {
    
    enum State {
        case initial
        case loadingQuestions
        case didDisplay(Question)
        case savingResults
        case didSaveResults
        case didFailToSaveResults(Error)
    }
    
    enum Event {
        case didRequestQuestions
        case didLoadQuestions
        case didTapNext(Answer)
        case didSaveResults
        case didFailToSaveResults(Error)
    }
    
    var state: State = .initial {
        didSet {
            subscriber?()
        }
    }
    
    private var subscriber: (() -> ())?
    
    private var questionQueue: [Question] = []
    private var currentQuestionIndex: Int = -1
    private var currentQuestion: Question? {
        return questionQueue[safe: currentQuestionIndex]
    }
    private var answers: [(Question, Answer)] = []
    private var currentAnswer: Answer? {
        return answers[safe: currentQuestionIndex]?.1
    }
    
    private var questions: [Question]?
    private var categories: [String]?
    
    func bind(_ subscriber: @escaping () -> ()) {
        self.subscriber = subscriber
    }
    
    func send(_ event: Event) {
        state = reduce(state, event)
        handle(event)
    }
    
    private func requestQuestions() {
        MockDataProvider.provideQuestionsWithDelay { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case let .success(response):
                self.setupQueue(with: response)
            default:
                break
            }
        }
    }
    
    private func setupQueue(with response: QuestionDataResponse) {
        questions = response.questions
        categories = response.categories
        
        questionQueue = response.categories
            .map { category in
                response.questions.filter { $0.category == category }
            }
            .flatMap { $0 }
        
        send(.didLoadQuestions)
    }
    
    private func requestNextQuestion() -> Question? {
        
        insertConditionQuestionIfNeeded()
        
        currentQuestionIndex += 1
        
        return questionQueue[safe: currentQuestionIndex]
    }
    
    private func insertConditionQuestionIfNeeded() {
        guard let current = currentQuestion else { return }
        guard let condition = current.type.condition else { return }
        guard let answer = currentAnswer else { return }
        guard let question = condition.nextQuestion(for: answer) else { return }
        
        questionQueue.insert(question, at: currentQuestionIndex + 1)
    }
    
    func handle(_ event: Event) {
        
        switch event {
        case .didRequestQuestions:
            requestQuestions()
        case .didLoadQuestions, .didTapNext(_):
            handleSavingResultsIfNeeded()
        default:
            break
        }
    }
    
    private func handleSavingResultsIfNeeded() {
        guard case .savingResults = state else { return }
        MockDataProvider.uploadResultsWithDelaySuccess { [weak self] (result) in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                
                switch result {
                case .success(_):
                    self.send(.didSaveResults)
                case let .failure(error):
                    self.send(.didFailToSaveResults(error))
                }
            }
        }
    }
    
    private func reduce(_ state: State, _ event: Event) -> State {
        switch event {
        case .didRequestQuestions:
            return .loadingQuestions
        case .didLoadQuestions, .didTapNext(_):
            
            if let nextQuestion = requestNextQuestion() {
                return .didDisplay(nextQuestion)
            } else {
                return .savingResults
            }
        
        case .didSaveResults:
            return .didSaveResults
            
        case let .didFailToSaveResults(error):
            return .didFailToSaveResults(error)
        }
    }
}
