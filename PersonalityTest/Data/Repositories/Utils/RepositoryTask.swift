//
//  RepositoryTask.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation
import Networking

struct RepositoryTask: Cancellable {
    let networkTask: NetworkCancellable?
    func cancel() {
        networkTask?.cancel()
    }
}
