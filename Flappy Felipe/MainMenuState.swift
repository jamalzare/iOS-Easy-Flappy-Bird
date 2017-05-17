import SpriteKit
import GameplayKit

class MainMenuState: GKState {
  unowned let scene: GameScene
  
  init(scene: SKScene) {
    self.scene = scene as! GameScene
    super.init()
  }
  
  override func didEnterWithPreviousState(previousState: GKState?) {
    scene.setupBackground()
    scene.setupForeground()
    scene.setupPlayer()
    
    showMainMenu()
    
    scene.player.movementAllowed = false
  }
  
  override func willExitWithNextState(nextState: GKState) {
    
  }
  
  override func isValidNextState(stateClass: AnyClass) -> Bool {
    return stateClass is TutorialState.Type
  }
  
  override func updateWithDeltaTime(seconds: NSTimeInterval) {
    
  }
  
  func showMainMenu() {
    let logo = SKSpriteNode(imageNamed: "Logo")
    logo.position = CGPoint(x: scene.size.width/2, y: scene.size.height * 0.8)
    logo.zPosition = Layer.UI.rawValue
    scene.worldNode.addChild(logo)
    
    // Play button
    let playButton = SKSpriteNode(imageNamed: "Button")
    playButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height * 0.25)
    playButton.zPosition = Layer.UI.rawValue
    scene.worldNode.addChild(playButton)
    
    let play = SKSpriteNode(imageNamed: "Play")
    play.position = CGPoint.zero
    playButton.addChild(play)
    
    // Rate button
    let rateButton = SKSpriteNode(imageNamed: "Button")
    rateButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.25)
    rateButton.zPosition = Layer.UI.rawValue
    scene.worldNode.addChild(rateButton)
    
    let rate = SKSpriteNode(imageNamed: "Rate")
    rate.position = CGPoint.zero
    rateButton.addChild(rate)
    
    // Learn button
    let learn = SKSpriteNode(imageNamed: "button_learn")
    learn.position = CGPoint(x: scene.size.width * 0.5, y: learn.size.height/2 + scene.margin)
    learn.zPosition = Layer.UI.rawValue
    scene.worldNode.addChild(learn)
    
    // Bounce button
    let scaleUp = SKAction.scaleTo(1.02, duration: 0.75)
    scaleUp.timingMode = .EaseInEaseOut
    let scaleDown = SKAction.scaleTo(0.98, duration: 0.75)
    scaleDown.timingMode = .EaseInEaseOut
    
    learn.runAction(SKAction.repeatActionForever(SKAction.sequence([
      scaleUp, scaleDown
      ])))
    
    // At the time of this recording, links were not supported so hide the buttons on tvOS
    #if os(tvOS)
      playButton.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
      rateButton.hidden = true
      learn.hidden = true
    
      playButton.runAction(SKAction.repeatActionForever(SKAction.sequence([
            scaleUp, scaleDown
        ])))
    #endif
  }
}