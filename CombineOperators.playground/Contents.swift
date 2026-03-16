import Combine
import Foundation

import Combine
import Foundation

var cancellables = Set<AnyCancellable>()

// Use a Subject so we control when values emit
let subject = PassthroughSubject<Int, Never>()

let shared = subject
    .print("upstream")  // 👈 shows you exactly when upstream gets subscribed/values
    .share()

// Attach BOTH subscribers before sending values
shared
    .sink { print("Sub A received: \($0)") }
    .store(in: &cancellables)

shared
    .sink { print("Sub B received: \($0)") }
    .store(in: &cancellables)

// Now emit values — both subs get each one, upstream only runs once
subject.send(1)
subject.send(2)
subject.send(3)
subject.send(completion: .finished)
