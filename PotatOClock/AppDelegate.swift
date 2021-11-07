//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem?
  var mainWindowController: NSWindowController!
  var mainViewController: ViewController!

  func applicationDidFinishLaunching(_: Notification) {
    mainWindowController = NSStoryboard.main!
      .instantiateController(withIdentifier: .init("MainWindow")) as? NSWindowController
    mainViewController = mainWindowController.contentViewController as? ViewController
    let window = mainWindowController.window!
    window.level = .floating
    window.setFrameOrigin(NSPoint(x: NSScreen.main!.frame.width, y: window.frame.minY))
    statusItem = makeStatusItem()

    toggleVisibility(nil)
  }

  @objc
  func toggleSitStand(_: Any?) {
    mainViewController.viewModel.toggleStatus()
  }


  @objc
  func toggleVisibility(_: Any?) {
    let _window = mainWindowController.window

    let screenWidth = NSScreen.main!.frame.width

    let size = _window?.frame.size ?? .zero
    let minX = _window?.frame.minX ?? 0
    let minY = _window?.frame.minY ?? 0
    let width = _window?.frame.width ?? 0

    let offScreenFrame = NSRect(origin: CGPoint(x: screenWidth, y: minY), size: size)
    let onScreenFrame = NSRect(origin: CGPoint(x: screenWidth - width, y: minY), size: size)

    _window?.makeKeyAndOrderFront(nil)
    _window?.animator()
      .setFrame(
        minX < screenWidth ? offScreenFrame : onScreenFrame,
        display: false,
        animate: true)
  }
}

extension AppDelegate: NSUserInterfaceValidations {
  func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
    if let item = item as? NSMenuItem, item.action == #selector(toggleSitStand) {
      item.title = mainViewController.viewModel.isSitting ? "Stand" : "Sit"
      if mainViewController.viewModel.potatoState.value == .death {
        return false
      }
    }

    return true
  }
}
