import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
  
  let spriteComponent: SpriteComponent
  
  var velocity = CGPoint.zero
  let gravity: CGFloat = -1500
  let impulse: CGFloat = 400
  
  var velocityModifier: CGFloat = 1000.0
  var angularVelocity: CGFloat = 0.0
  let minDegrees: CGFloat = -90
  let maxDegrees: CGFloat = 25
  
  var lastTouchTime: NSTimeInterval = 0
  var lastTouchY: CGFloat = 0.0
  
  var playableStart: CGFloat = 0
  
  let flapAction = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
  
  init(entity: GKEntity) {
    self.spriteComponent = entity.componentForClass(SpriteComponent)!
  }
  
  func applyInitialImpulse() {
    velocity = CGPoint(x: 0, y: impulse * 2)
  }
  
  func moveSombrero() {
    if let player = entity as? Player {
      let moveUp = SKAction.moveByX(0, y: 12, duration: 0.15)
      moveUp.timingMode = .EaseInEaseOut
      let moveDown = moveUp.reversedAction()
      player.sombrero.runAction(SKAction.sequence([moveUp, moveDown]))
    }
  }
  
  func applyImpulse(lastUpdateTime: NSTimeInterval) {
    
    spriteComponent.node.runAction(flapAction)
    
    moveSombrero()
    
    velocity = CGPoint(x: 0, y: impulse)
    
    angularVelocity = velocityModifier.degreesToRadians()
    lastTouchTime = lastUpdateTime
    lastTouchY = spriteComponent.node.position.y
  }
  
  func applyMovement(seconds: NSTimeInterval) {
    let spriteNode = spriteComponent.node
    
    // Apply gravity
    let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(seconds)
    velocity += gravityStep
    
    // Apply velocity
    let velocityStep = velocity * CGFloat(seconds)
    spriteNode.position += velocityStep
    
    if spriteNode.position.y < lastTouchY {
      angularVelocity = -velocityModifier.degreesToRadians()
    }
    
    // Rotate
    let angularStep = angularVelocity * CGFloat(seconds)
    spriteNode.zRotation += angularStep
    spriteNode.zRotation = min(max(spriteNode.zRotation, minDegrees.degreesToRadians()), maxDegrees.degreesToRadians())
    
    // Temporary ground hit
    if spriteNode.position.y - spriteNode.size.height/2 < playableStart {
      spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableStart + spriteNode.size.height/2)
    }
  }
  
  override func updateWithDeltaTime(seconds: NSTimeInterval) {
    if let player = entity as? Player {
      if player.movementAllowed {
        applyMovement(seconds)
      }
    }
  }
}