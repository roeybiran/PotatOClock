//

import Cocoa
import GameplayKit
import SpriteKit

class ViewController: NSViewController {
  //
  @IBOutlet
  var skView: SKView!

  let scene = GameScene(fileNamed: "GameScene")
  let viewModel = ViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = skView {
      scene!.scaleMode = .aspectFill
      view.presentScene(scene)
      // view.showsPhysics = true
    }
    viewModel.potatoState.bind { [weak self] in
      self?.scene?.updateScene(with: $0)
    }
  }
}

