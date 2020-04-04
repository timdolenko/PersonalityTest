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
        case savingResults
        case savedResults
    }
    
    enum Event {
        case didRequestQuestions
        case didTapNext(answer: Answer)
    }
    
    var state: State = .initial {
        didSet {
            subscriber?()
        }
    }
    
    private var subscriber: (() -> ())?
    
    func bind(_ subscriber: @escaping () -> ()) {
        self.subscriber = subscriber
    }
    
    func send(_ event: Event) {
        state = reduce(state, event)
    }
    
    private func reduce(_ state: State, _ event: Event) -> State {
        switch event {
        case .didRequestQuestions:
            return .loadingQuestions
        default:
            return .initial
        }
    }
}
