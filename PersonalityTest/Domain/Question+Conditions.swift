import Foundation

extension AnswerDescription.Condition {
    public func isFullfilled(with answer: Answer) -> Bool {
        switch predicate {
        case let .exactEquals(predicateArray):
            
            guard let lhs = predicateArray[safe: 0],
                  let rhs = predicateArray[safe: 1] else {
                return false
            }
            
            if lhs == "${selection}" {
                
                if case let .option(text) = answer, text == rhs {
                    return true
                }
                
            }
            
            return false
        }
    }
    
    public func nextQuestion(for answer: Answer) -> Question? {
        if isFullfilled(with: answer) {
            return ifPositive
        } else {
            return nil
        }
    }
}
