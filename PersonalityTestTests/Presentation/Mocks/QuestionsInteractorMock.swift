import XCTest
@testable import PersonalityTest

class QuestionsInteractorMock: QuestionsInteractorProtocol {
    
    var expectation: XCTestExpectation?
    var error: Error?
    var list = QuestionList(questions: [], categories: [])
    
    @discardableResult
    func fetchQuestions(completion: @escaping (Result<QuestionList, Error>) -> Void) -> Cancellable? {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(list))
        }
        expectation?.fulfill()
        return nil
    }
    
    func saveAnswers(answers: [Question : Answer], completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
        expectation?.fulfill()
        return nil
    }
}
