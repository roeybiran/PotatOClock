//

import Foundation

// MARK: - PotatoState

enum PotatoState: Int, CaseIterable {
  case whistling
  case angry
  case panting
  case dazy
  case death
}

private let DEBUG_SEGMENT_LENGTH = 3

// MARK: - ViewModel

class ViewModel {

  // MARK: Lifecycle

  init() {
    sessionTimer = Timer.scheduledTimer(
      withTimeInterval: 1.0,
      repeats: true,
      block: onTick)
    sessionTimer!.tolerance = 0.2
  }

  // MARK: Internal

  var potatoState = Binding<PotatoState>(.whistling)

  var isSitting: Bool {
    userStatus == .sitting
  }

  // arduino input should be directed here
  func toggleStatus() {
    userStatus = userStatus == .sitting ? .standing : .sitting
  }

  // MARK: Private

  private enum UserStatus {
    case standing, sitting
  }

  private var userStatus: UserStatus?
  private var sittingElapsed = 0
  private var standingElapsed = 0

  private let phaseDuration = DEBUG_SEGMENT_LENGTH
  private let sessionDuration = DEBUG_SEGMENT_LENGTH * PotatoState.allCases.count

  private var sessionTimer: Timer?

  private func onTick(_ timer: Timer) {
    guard let status = userStatus else {
      return
    }

    switch status {
    case .standing:
      potatoState.value = .whistling
      if standingElapsed >= phaseDuration {
        userStatus = nil
        standingElapsed = 0
        sittingElapsed = 0
      } else {
        standingElapsed += 1
      }
    case .sitting:
      var newState: PotatoState
      switch sittingElapsed {
      case 0 ..< phaseDuration:
        newState = .whistling
      case phaseDuration ..< phaseDuration * 2:
        newState = .angry
      case phaseDuration * 2 ..< phaseDuration * 3:
        newState = .panting
      case phaseDuration * 3 ..< phaseDuration * 4:
        newState = .dazy
      default:
        newState = .death
      }
      if potatoState.value != newState {
        potatoState.value = newState
      }
      sittingElapsed += 1
    }
  }

}
