import UIKit

extension UITableView {
    func register<Cell: UITableViewCell & ClassIdentifiable>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
}
