//
//  AsyncOperation.swift
//  Combine Scheduler
//
//  Created by Hossam on 08/03/2021.
//


import Foundation

extension AsyncOperation {
  enum State: String {
    case ready, executing, finished

    fileprivate var keyPath: String {
      "is\(rawValue.capitalized)"
    }
  }
}

class AsyncOperation: Operation {
  // Create state management
  var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }

  // Override properties
  override var isReady: Bool {
    return super.isReady && state == .ready
  }

  override var isExecuting: Bool {
    return state == .executing
  }

  override var isFinished: Bool {
    return state == .finished
  }

  override func cancel() {
    state = .finished
  }

 

  // Override start
  override func start() {
    if isCancelled {
      state = .finished
      return
    }
    main()
    state = .executing
  }
}
