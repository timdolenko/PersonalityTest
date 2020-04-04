import UIKit

extension UITableView {
    func register<Cell: UITableViewCell & ClassIdentifiable>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeue<Cell: UITableViewCell & ClassIdentifiable>(
        _ cellClass: Cell.Type, at indexPath: IndexPath
    ) -> Cell {
        dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
    }
}
