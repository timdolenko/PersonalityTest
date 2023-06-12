import XCTest
@testable import PersonalityTest

class QuestionaryViewModelTests: XCTestCase {
    
    private enum QuestionsInteractorError: Error { case someError }

    func test_whenAnswerConditionWasFullfilled_shouldInsertConditionalQuestion() {
        //given
        let interactor = QuestionsInteractorMock()
        interactor.expectation = self.expectation(description: "should fetch questions list")
        
        let conditionalQuestion = Question(title: "mock2", category: "test", answerDescription: .init(type: .singleChoice(["b1","b2"]), condition: nil))
        
        let question = Question(title: "mock", category: "test", answerDescription: .init(type: .singleChoice(["o1","o2","o3"]), condition: .init(predicate: .exactEquals(["${selection}","o3"]), ifPositive: conditionalQuestion)))
        
        let list = QuestionList(questions: [question], categories: ["test"])
        
        interactor.list = list
        
        let viewModel = QuestionaryViewModel(interactor: interactor)
        
        //when
        viewModel.send(.didRequestQuestions)
        waitForExpectations(timeout: 0.1, handler: nil)
        viewModel.send(.didSelectAnswer(question, .option("o3")))
        viewModel.send(.didTapNext)
        
        //then
        guard let resultQuestion = viewModel.state.value.question else {
            XCTFail("Question should be in state")
            return
        }
        
        XCTAssertEqual(resultQuestion, conditionalQuestion)
    }
    
    func test_whenFetched_shouldDisplayQuestion() {
        //given
        let interactor = QuestionsInteractorMock()
        interactor.expectation = self.expectation(description: "should fetch questions list")
        let question = Question(title: "mock", category: "test", answerDescription: .init(type: .singleChoice(["o1","o2","o3"]), condition: nil))
        
        let list = QuestionList(questions: [question], categories: ["test"])
        
        interactor.list = list
        
        let viewModel = QuestionaryViewModel(interactor: interactor)
        
        //when
        viewModel.send(.didRequestQuestions)
        waitForExpectations(timeout: 0.1, handler: nil)
        
        interactor.expectation = nil
        
        //then
        guard case let .didDisplay(resultQuestion) = viewModel.state.value else {
            XCTFail("Should not happen")
            return
        }
        
        XCTAssertEqual(resultQuestion, question)
    }
    
    func test_whenFetchDidFailWithError_shouldBeInFailedState() {
        //given
        let interactor = QuestionsInteractorMock()
        interactor.expectation = self.expectation(description: "should fetch questions list with error")
        interactor.error = QuestionsInteractorError.someError
        
        let viewModel = QuestionaryViewModel(interactor: interactor)
        
        //when
        viewModel.send(.didRequestQuestions)
        waitForExpectations(timeout: 0.1, handler: nil)
        
        //then
        guard case let .didFailToLoadQuestions(error) = viewModel.state.value else {
            XCTFail("Should not happen")
            return
        }
        
        guard case QuestionsInteractorError.someError = error else {
            XCTFail("Should return the same error")
            return
        }
    }
    
    func test_whenSaved_shouldBeInDidSaveState() {
        //given
        let interactor = QuestionsInteractorMock()
        interactor.expectation = self.expectation(description: "should fetch questions list")
        let question = Question(title: "mock", category: "test", answerDescription: .init(type: .singleChoice(["o1","o2","o3"]), condition: nil))
        
        let list = QuestionList(questions: [question], categories: ["test"])
        
        interactor.list = list
        
        let viewModel = QuestionaryViewModel(interactor: interactor)
        
        //when
        viewModel.send(.didRequestQuestions)
        waitForExpectations(timeout: 0.1, handler: nil)
        
        interactor.expectation = self.expectation(description: "should save questions list with error")
        
        viewModel.send(.didSelectAnswer(question, .option("o3")))
        viewModel.send(.didTapNext)
        waitForExpectations(timeout: 0.1, handler: nil)
        
        //then
        guard case .didSaveResults = viewModel.state.value else {
            XCTFail("Should not happen")
            return
        }
    }
    
    func test_whenSaveDidFailWithError_shouldBeInFailedState() {
        //given
        let interactor = QuestionsInteractorMock()
        interactor.expectation = self.expectation(description: "should fetch questions list")
        let question = Question(title: "mock", category: "test", answerDescription: .init(type: .singleChoice(["o1","o2","o3"]), condition: nil))
        
        let list = QuestionList(questions: [question], categories: ["test"])
        
        interactor.list = list
        
        let viewModel = QuestionaryViewModel(interactor: interactor)
        
        //when
        viewModel.send(.didRequestQuestions)
        waitForExpectations(timeout: 0.1, handler: nil)
        
        interactor.expectation = self.expectation(description: "should save questions list with error")
        interactor.error = QuestionsInteractorError.someError
        
        viewModel.send(.didSelectAnswer(question, .option("o3")))
        viewModel.send(.didTapNext)
        waitForExpectations(timeout: 0.1, handler: nil)
        
        //then
        guard case let .didFailToSaveResults(error) = viewModel.state.value else {
            XCTFail("Should not happen")
            return
        }
        
        guard case QuestionsInteractorError.someError = error else {
            XCTFail("Should return the same error")
            return
        }
    }
    
    func test_whenWrongAnswerIsPassed_shouldNotAcceptIt() {
        //given
        let interactor = QuestionsInteractorMock()
        interactor.expectation = self.expectation(description: "should fetch questions list")
        let question = Question(title: "mock", category: "test", answerDescription: .init(type: .singleChoice(["o1","o2","o3"]), condition: nil))
        
        let list = QuestionList(questions: [question], categories: ["test"])
        
        interactor.list = list
        
        let viewModel = QuestionaryViewModel(interactor: interactor)
        
        //when
        viewModel.send(.didRequestQuestions)
        waitForExpectations(timeout: 0.1, handler: nil)
        
        interactor.expectation = nil
        
        viewModel.send(.didSelectAnswer(question, .number(0)))
        viewModel.send(.didTapNext)
        
        //then
        guard case let .didDisplay(resultQuestion) = viewModel.state.value else {
            XCTFail("Should not happen")
            return
        }
        
        XCTAssertEqual(resultQuestion, question)
    }
    
    func test_whenNextTappedAndNoAnswerIsSelected_shouldNotShowNextQuestion() {
        //given
        let interactor = QuestionsInteractorMock()
        interactor.expectation = self.expectation(description: "should fetch questions list")
        let question = Question(title: "mock", category: "test", answerDescription: .init(type: .singleChoice(["o1","o2","o3"]), condition: nil))
        
        let list = QuestionList(questions: [question], categories: ["test"])
        
        interactor.list = list
        
        let viewModel = QuestionaryViewModel(interactor: interactor)
        
        //when
        viewModel.send(.didRequestQuestions)
        waitForExpectations(timeout: 0.1, handler: nil)
        interactor.expectation = nil
        
        viewModel.send(.didTapNext)
        
        //then
        guard case let .didDisplay(resultQuestion) = viewModel.state.value else {
            XCTFail("Should not happen")
            return
        }
        
        XCTAssertEqual(resultQuestion, question)
    }
}
