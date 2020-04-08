//
//  Observable.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 08.04.2020.
//

import Foundation

public class ObservationToken {
    
    private let cancellationClosure: () -> Void
    
    public init(cancellationClosure: @escaping () -> Void) {
        self.cancellationClosure = cancellationClosure
    }
    
    public func cancel() {
        cancellationClosure()
    }
}

extension Dictionary where Key == UUID {
    mutating func insert(_ value: Value) -> UUID {
        let id = UUID()
        self[id] = value
        return id
    }
}


public final class Observable<Value> {
    
    struct Observer<Value> {
        weak var observer: AnyObject?
        let closure: (Value) -> Void
    }
    
    private var observers = [UUID: (Value) -> Void]()
    
    public var value: Value {
        didSet { notifyObservers() }
    }
    
    public init(_ value: Value) {
        self.value = value
    }
    
    @discardableResult
    public func observe(using closure: @escaping (Value) -> Void) -> ObservationToken {
        let id = observers.insert(closure)
        
        return ObservationToken { [weak self] in
            self?.observers.removeValue(forKey: id)
        }
    }
    
    private func notifyObservers() {
        observers.values.forEach { $0(value) }
    }
}
