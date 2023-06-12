import Foundation
import Networking

struct RepositoryTask: Cancellable {
    let networkTask: NetworkCancellable?
    func cancel() {
        networkTask?.cancel()
    }
}
