import Foundation
import Networking

struct Endpoints {
    
    static func getQuestions() -> Endpoint<QuestionsResponseDTO> {
        Endpoint(path: "/personality_test.json", method: .get)
    }
    
    static func saveAnswers(with saveAnswerRequestDTO: SaveAnswersRequestDTO) -> Endpoint<Void> {
        Endpoint(path: "/saveAnswers", method: .post, bodyParameters: saveAnswerRequestDTO)
    }
    
}
