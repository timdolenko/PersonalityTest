import XCTest
@testable import PersonalityTest

class AnswerOptionsTests: XCTestCase {
    
    private let mock = AnswerDescription.init(type: .singleChoice(["o1","o2","o3"]), condition: nil)
    private let correctAnswer = Answer.option("o1")
    private let incorrectAnswer = Answer.option("b2")
    private let differentTypeAnswer = Answer.number(0)
    
    func test_whenVerifiesCorrectOptionAnswer_shouldVerifyCorrectAnswer() {
        //when
        let result = mock.verifyAnswer(correctAnswer)
        
        //then
        switch result {
        case let .success(answer):
            guard let option = answer.option, option == "o1" else {
                XCTFail("Should not modify answer")
                return
            }
        case .failure:
            XCTFail("Should not happen")
        }
    }
    
    func test_whenVerifiesInvalidOptionAnswer_shouldFailVerification() {
        //when
        let result = mock.verifyAnswer(incorrectAnswer)
        
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
