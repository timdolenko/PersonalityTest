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
        case savedResults
    }
    
    enum Event {
        case didRequestQuestions
        case didLoadQuestions
        case didDisplay(Question)
        case didTapNext(Answer)
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
        guard currentQuestionIndex > -1
            && currentQuestionIndex < questionQueue.count else { return nil }
        return questionQueue[currentQuestionIndex]
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
    
    private func requestNextQuestion() -> Question {
        
        if let current = currentQuestion {
            if let case .
        }
        
        currentQuestionIndex += 1
        
        return questionQueue[currentQuestionIndex]
    }
    
    func handle(_ event: Event) {
        if case .didRequestQuestions = event {
            requestQuestions()
        }
        if case .didLoadQuestions = event {
            handleSavingResultsIfNeeded()
        }
        if case .didTapNext(_) = event {
            handleSavingResultsIfNeeded()
        }
    }
    
    private func handleSavingResultsIfNeeded() {
        guard case .savingResults = state else { return }
        // Request saving results
    }
    
    private func reduce(_ state: State, _ event: Event) -> State {
        switch event {
        case .didRequestQuestions:
            return .loadingQuestions
        case .didLoadQuestions, .didTapNext(_):
            
            if currentQuestionIndex == questionQueue.count - 1 {
                return .savingResults
            }
            
            return .didDisplay(requestNextQuestion())
        default:
            return .initial
        }
    }
}
