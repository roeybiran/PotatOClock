//

import Cocoa

func makeStatusItem(in bar: NSStatusBar = .system) -> NSStatusItem {
  let item = bar.statusItem(withLength: NSStatusItem.squareLength)
  item.button?.image = NSImage(named: "statusItem")
  item.button?.image?.isTemplate = true
  let statusMenu = NSMenu()
  statusMenu
    .addItem(NSMenuItem(
      title: "Sit",
      action: #selector(AppDelegate.toggleSitStand),
      keyEquivalent: ""))
  statusMenu.addItem(NSMenuItem(
    title: "Toggle Visibility",
    action: #selector(AppDelegate.toggleVisibility),
    keyEquivalent: ""))
  statusMenu
    .addItem(.init(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: ""))

  item.menu = statusMenu
  return item
}
