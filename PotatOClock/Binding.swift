import Foundation

final class Binding<T> {

  // MARK: Lifecycle

  init(_ value: T) {
    self.value = value
  }

  // MARK: Internal

  typealias OnChange = (T) -> Void

  var callback: OnChange?

  var value: T {
    didSet {
      callback?(value)
    }
  }

  func bind(callback: OnChange?) {
    self.callback = callback
    callback?(value)
  }
}
