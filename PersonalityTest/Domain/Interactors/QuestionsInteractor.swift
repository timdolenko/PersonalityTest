import Foundation

protocol QuestionsInteractorProtocol {
    @discardableResult
    func fetchQuestions(completion: @escaping (Result<QuestionList, Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func saveAnswers(answers: [Question:Answer], completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable?
}

final class QuestionsInteractor: QuestionsInteractorProtocol {
    
    private let repository: QuestionsRepositoryProtocol
    
    init(repository: QuestionsRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    func fetchQuestions(completion: @escaping (Result<QuestionList, Error>) -> Void) -> Cancellable? {
        repository.fetchQuestions { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    @discardableResult
    func saveAnswers(answers: [Question:Answer], completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        repository.saveAnswers(answers: answers) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
}
