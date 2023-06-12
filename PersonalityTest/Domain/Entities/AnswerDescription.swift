import Foundation

public struct AnswerDescription {
    
    public typealias AnswerOption = String
    
    public struct NumberRange {
        var from: Int
        var to: Int
    }
    
    public struct Condition {
        
        public enum Predicate {
            case exactEquals([String])
        }
        
        public var predicate: Predicate
        public var ifPositive: Question?
    }
    
    public enum AnswerType {
        case singleChoice([AnswerOption])
        case numberRange(NumberRange)
        
        public var range: NumberRange? {
            get {
                guard case let .numberRange(value) = self else { return nil }
                return value
            }
            set {
                guard case .numberRange = self, let newValue = newValue else { return }
                self = .numberRange(newValue)
            }
        }
        
        public var options: [AnswerOption]? {
            get {
                guard case let .singleChoice(value) = self else { return nil }
                return value
            }
            set {
                guard case .singleChoice = self, let newValue = newValue else { return }
                self = .singleChoice(newValue)
            }
        }
    }
    
    var type: AnswerType
    var condition: Condition?
}
