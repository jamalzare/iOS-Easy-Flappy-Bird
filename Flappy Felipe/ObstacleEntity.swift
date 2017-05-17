import SpriteKit
import GameplayKit

class Obstacle: GKEntity {
  var spriteComponent: SpriteComponent!
  
  init(imageName: String) {
    super.init()
    
    let texture = SKTexture(imageNamed:imageName)
    spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
    addComponent(spriteComponent)
    
    // Add physics
    let spriteNode = spriteComponent.node
    
    spriteNode.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
    spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
    spriteNode.physicsBody?.collisionBitMask = 0
    spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player
  }
}