import XCTest
@testable import PersonalityTest

class AnswerNumberRangeTests: XCTestCase {
    
    private let mock = AnswerDescription.init(type: .numberRange(.init(from: 10, to: 80)), condition: nil)
    private let correctAnswer = Answer.range(.init(from: 12, to: 25))
    private let incorrectAnswer = Answer.range(.init(from: -12, to: -25))
    private let differentTypeAnswer = Answer.number(0)
    
    func test_whenVerifiesCorrectRangeAnswer_shouldVerifyCorrectAnswer() {
        //when
        let result = mock.verifyAnswer(correctAnswer)
        
        //then
        switch result {
        case let .success(answer):
            guard let range = answer.range, range.from == 12, range.to == 25 else {
                XCTFail("Should not modify answer")
                return
            }
        case .failure:
            XCTFail("Should not happen")
        }
    }
    
    func test_whenVerifiesInvalidRangeAnswer_shouldFailVerification() {
        //when
        let result = mock.verifyAnswer(incorrectAnswer)
        
        //then
        switch result {
        case let .success(answer):
            guard case let Answer.range(range) = answer else {
                XCTFail("Should not happen")
                return
            }
            
            // Returns initial range
            XCTAssertEqual(range.from, mock.type.range!.from)
            XCTAssertEqual(range.to, mock.type.range!.to)
            
        case .failure:
            XCTFail("Should not happen")
        }
    }
    
    func test_whenVerifiesInvalidTypeAnswer_shouldFailVerification() {
        //when
        let result = mock.verifyAnswer(differentTypeAnswer)
        
        //then
        switch result {
        case .success:
            XCTFail("Should not happen")
        case let .failure(error):
            guard case AnswerVerificationError.invalid = error else {
                XCTFail("Wrong error type")
                return
            }
        }
    }
}
