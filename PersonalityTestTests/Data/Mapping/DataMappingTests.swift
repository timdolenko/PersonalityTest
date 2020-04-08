//
//  QuestionsRepositoryTests.swift
//  PersonalityTestTests
//
//  Created by Tymofii Dolenko on 08.04.2020.
//

import XCTest
@testable import PersonalityTest

class DataMappingTests: XCTestCase {

    func test_whenMappedValidJSON_shouldReturnDomainData() {
        //given
        guard let path = Bundle.main.url(forResource: "personality_test", withExtension: "json") else {
            XCTFail("Example JSON is missing")
            return
        }

        guard let data = try? Data(contentsOf: path) else {
            XCTFail("Should get data from json file")
            return
        }

        //when
        guard let result = try? JSONDecoder().decode(QuestionsResponseDTO.self, from: data) else {
            XCTFail("Should decode example json")
            return
        }

        //then
        XCTAssertEqual(result.questions.count, 25)
    }
    
    func test_whenMappedAnswers_shouldReturnValidJSON() {
        //given
        let expectedJsonString =
        """
        {"answers":[{"range":{"to":18,"from":15},"question":"q1","category":"fun-fact"},{"option":"op1","question":"q1","category":"fact"}]}
        """
        
        var answers: [Question:Answer] = [:]
        
        let q1 = Question(title: "q1", category: "fact", answerDescription: .init(type: .singleChoice(["op1","op2"]), condition: nil))
        let a1 = Answer.option("op1")
        
        answers[q1] = a1
        
        let q2 = Question(title: "q1", category: "fun-fact", answerDescription: .init(type: .numberRange(.init(from: 10, to: 20)), condition: nil))
        let a2 = Answer.range(.init(from: 15, to: 18))
        answers[q2] = a2
        
        //when
        let result = SaveAnswersRequestDTO.init(answers: answers)
        
        guard let jsonData = try? JSONEncoder().encode(result) else {
            XCTFail("Should encode data object")
            return
        }
        
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
        
        //then
        XCTAssertEqual(jsonString, expectedJsonString)
    }

}
