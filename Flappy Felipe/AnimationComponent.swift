import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
  
  let spriteComponent: SpriteComponent
  var textures: Array<SKTexture> = []
  
  init(entity: GKEntity, textures: Array<SKTexture>) {
    self.textures = textures
    self.spriteComponent = entity.componentForClass(SpriteComponent)!
  }
  
  override func updateWithDeltaTime(seconds: NSTimeInterval) {
    if let player = entity as? Player {
      if player.movementAllowed {
        startAnimation()
      } else {
        stopAnimation("Flap")
      }
    }
  }
  
  func startWobble() {
    let moveUp = SKAction.moveByX(0, y: 10, duration: 0.4)
    moveUp.timingMode = .EaseInEaseOut
    let moveDown = moveUp.reversedAction()
    let sequence = SKAction.sequence([moveUp, moveDown])
    let repeatWobble = SKAction.repeatActionForever(sequence)
    spriteComponent.node.runAction(repeatWobble, withKey: "Wobble")
    
    let flapWings = SKAction.animateWithTextures(textures, timePerFrame: 0.07)
    let repeatFlap = SKAction.repeatActionForever(flapWings)
    spriteComponent.node.runAction(repeatFlap, withKey: "Wobble-Flap")
  }
  
  func stopWobble() {
    stopAnimation("Wobble")
    stopAnimation("Wobble-Flap")
  }
  
  func startAnimation() {
    if (spriteComponent.node.actionForKey("Flap") == nil) {
      let playerAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.07)
      let repeatAction = SKAction.repeatActionForever(playerAnimation)
      spriteComponent.node.runAction(repeatAction, withKey: "Flap")
    }
  }
  
  func stopAnimation(name: String) {
    spriteComponent.node.removeActionForKey(name)
  }
}