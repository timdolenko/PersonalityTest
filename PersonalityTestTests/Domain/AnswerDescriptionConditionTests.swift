//
//  AnswerDescriptionConditionTests.swift
//  PersonalityTestTests
//
//  Created by Tymofii Dolenko on 08.04.2020.
//

import XCTest
@testable import PersonalityTest

class AnswerDescriptionConditionTests: XCTestCase {
    
    private let mock = AnswerDescription.Condition(
        predicate: .exactEquals(["${selection}","o2"]),
        ifPositive: Question(
            title: "mock",
            category: "fact",
            answerDescription: .init(type: .numberRange(.init(from: 0, to: 1)),
                                     condition: nil)
        )
    )

    func test_whenFullfilledConditionIsChecked_shouldConfirmFullfillment() {
        //given
        let answer = Answer.option("o2")
        
        //when
        let result = mock.isFullfilled(with: answer)
        
        //then
        XCTAssertTrue(result)
    }
    
    func test_whenUnfullfilledConditionIsChecked_shouldNotConfirmFullfillment() {
        //given
        let answer = Answer.option("o1")
        
        //when
        let result = mock.isFullfilled(with: answer)
        
        //then
        XCTAssertFalse(result)
    }
    
    func test_whenNextAnswerIsRequestedWithFullfilledCondition_shouldReturnNextAnswer() {
        //given
        let answer = Answer.option("o2")
        
        //when
        let result = mock.nextQuestion(for: answer)
        
        //then
        XCTAssertEqual(result?.title, mock.ifPositive?.title)
    }
}
