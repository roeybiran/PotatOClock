import Foundation

final class Binding<T> {
  typealias OnChange = (T) -> Void
  var callback: OnChange?

  var value: T {
    didSet {
      callback?(value)
    }
  }

  init(_ value: T) {
    self.value = value
  }

  func bind(callback: OnChange?) {
    self.callback = callback
    callback?(value)
  }
}
