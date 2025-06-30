//

import GameplayKit
import SpriteKit


class GameScene: SKScene {

  // MARK: Internal

  override func didMove(to _: SKView) {
    let sky = SKShapeNode(rect: frame)
    sky.strokeColor = strokeColor
    sky.fillColor = skyColor
    addChild(sky)

    let cases = CGFloat(GAME_STAGES)
    let pedestalHeight = (frame.height / cases) * (cases - 1)
    let pedestalFrame = CGRect(x: 0, y: 0, width: frame.width, height: pedestalHeight)
    pedestal = SKShapeNode(rect: pedestalFrame)
    pedestal.strokeColor = strokeColor
    pedestal.fillColor = pedestalColor
    addChild(pedestal)

    water.position = CGPoint(x: frame.midX, y: -frame.height)
    water.anchorPoint.y = 0
    addChild(water)

    waterSurfaceAction.timingMode = .easeInEaseOut
    water.run(waterSurfaceAction)

    let water2 = water.copy() as! SKSpriteNode
    water2.position = .init(x: 0, y: -5)
    water2.removeAllActions()
    water2.run(.sequence([
      .wait(forDuration: 0.3),
      waterSurfaceAction
        .reversed(),
    ]))
    water.addChild(water2)

    let bubbles = SKSpriteNode(texture: bubbleTextures.first)
    bubbles.run(
      .repeatForever(
        .animate(with: bubbleTextures, timePerFrame: 0.3)))
    water.addChild(bubbles)
    bubbles.position.y = water.frame.height

    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

    potato = SKSpriteNode(texture: potatoTextures.first!.first)
    potato.setScale(0.5)
    potato.position.y = pedestal.frame.height + (potato.frame.height / 2) + CGFloat(POTATO_OFFSET)
    potato.position.x = frame.midX
    potato.physicsBody = SKPhysicsBody(circleOfRadius: potato.size.width * 0.4)
    potato.physicsBody?.affectedByGravity = false
    addChild(potato)
  }

  func updateScene(with state: PotatoState) {
    if state == .whistling {
      potato.removeAllActions()
      potato.alpha = 1
    }

    let textures = potatoTextures[state.rawValue]
    let newHeight = -frame.height + ((frame.height / CGFloat(GAME_STAGES - 1)) * CGFloat(state.rawValue))

    let waterMoveAction = SKAction.moveTo(y: newHeight, duration: 0.8)
    waterMoveAction.timingMode = .easeInEaseOut
    water.run(waterMoveAction)

    potato.run(
      .repeatForever(
        .animate(with: textures, timePerFrame: 0.3, resize: true, restore: false)))

    if state == .death {
      potato.run(.group([
        .fadeAlpha(by: -0.4, duration: 0.3),
        .moveTo(y: 0, duration: 60),
        .repeatForever(
          .sequence([
            .rotate(byAngle: -0.5, duration: 20),
            .rotate(byAngle: 0.5, duration: 20),
          ])),
      ]))
    }
  }

  // MARK: Private

  private var potato: SKSpriteNode!

  private let potatoTextures: [[SKTexture]] = [
    [SKTexture(imageNamed: "stage1-1"), SKTexture(imageNamed: "stage1-2")],
    [SKTexture(imageNamed: "stage2-1"), SKTexture(imageNamed: "stage2-2")],
    [SKTexture(imageNamed: "stage3-1"), SKTexture(imageNamed: "stage3-2")],
    [SKTexture(imageNamed: "stage4-1"), SKTexture(imageNamed: "stage4-2")],
    [SKTexture(imageNamed: "dead")],
  ]

  private let bubbleTextures = [
    SKTexture(imageNamed: "bubbles-1"),
    SKTexture(imageNamed: "bubbles-2"),
  ]

  private let POTATO_OFFSET = -10
  private let GAME_STAGES = PotatoState.allCases.count
  private let water = SKSpriteNode(texture: SKTexture(imageNamed: "water"))
  private var pedestal: SKShapeNode!
  private let pedestalColor = NSColor(calibratedRed: 196 / 255, green: 196 / 255, blue: 196 / 255, alpha: 1)
  private let skyColor = NSColor(calibratedRed: 138 / 255, green: 196 / 255, blue: 215 / 255, alpha: 1)
  private let waterColor = NSColor(calibratedRed: 1 / 255, green: 142 / 255, blue: 220 / 255, alpha: 1)
  private let strokeColor = NSColor.black
  private let waterSurfaceAction = SKAction
    .repeatForever(
      .sequence([
        .moveBy(x: 4, y: -2, duration: 0.3),
        .moveBy(x: -4, y: 2, duration: 0.3),
        .moveBy(x: -4, y: 2, duration: 0.3),
        .moveBy(x: 4, y: -2, duration: 0.3),
      ]))

}
