import Foundation

protocol ClassIdentifiable {}
extension ClassIdentifiable {
    static var identifier: String { String(describing: self) }
}
