import SpriteKit
import GameplayKit

class FallingState: GKState {
  unowned let scene: GameScene
  
  let whackAction = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
  let fallingAction = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
  
  init(scene: SKScene) {
    self.scene = scene as! GameScene
    super.init()
  }
  
  override func didEnterWithPreviousState(previousState: GKState?) {
    
    // Screen shake
    let shake = SKAction.screenShakeWithNode(scene.worldNode, amount: CGPoint(x: 0, y: 7.0), oscillations: 10, duration: 1.0)
    scene.worldNode.runAction(shake)
    
    // Flash
    let whiteNode = SKSpriteNode(color: SKColor.whiteColor(), size: scene.size)
    whiteNode.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
    whiteNode.zPosition = Layer.Flash.rawValue
    scene.worldNode.addChild(whiteNode)
    
    whiteNode.runAction(SKAction.removeFromParentAfterDelay(0.01))
    
    scene.runAction(SKAction.sequence([whackAction, SKAction.waitForDuration(0.1), fallingAction]))
    scene.stopSpawning()
  }
  
  override func isValidNextState(stateClass: AnyClass) -> Bool {
    return stateClass is GameOverState.Type
  }
  
  override func updateWithDeltaTime(seconds: NSTimeInterval) {
    
  }
}