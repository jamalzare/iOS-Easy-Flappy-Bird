
import SpriteKit
import GameplayKit

class PlayingState: GKState {
  unowned let scene: GameScene
  
  init(scene: SKScene) {
    self.scene = scene as! GameScene
    super.init()
  }
  
  override func didEnterWithPreviousState(previousState: GKState?) {
    scene.startSpawning()
    
    scene.player.movementAllowed = true
    scene.player.animationComponent.startAnimation()
    
    scene.player.animationComponent.stopWobble()
  }
  
  override func isValidNextState(stateClass: AnyClass) -> Bool {
    return (stateClass == FallingState.self) || (stateClass ==  GameOverState.self)
  }
  
  override func updateWithDeltaTime(seconds: NSTimeInterval) {
    scene.updateForeground()
    scene.updateScore()
  }
}