//
//  QuestionaryViewModel.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import Foundation

struct QuestionaryViewModel {
    
    enum State {
        case initial
        case loadingQuestions
        case savingResults
        case savedResults
    }
    
    enum Event {
        case didRequestQuestions
        case didTapNext
    }
    
    var state: State
    
    func reduce(_ state: State, _ event: Event) -> State {
        return .initial
    }
    
}
