
import SpriteKit
import GameplayKit

class Player: GKEntity {
  
  var spriteComponent: SpriteComponent!
  var movementComponent: MovementComponent!
  
  var animationComponent: AnimationComponent!
  var numberOfFrames = 3
  
  // temporary flag; will replace with player state machine later
  var movementAllowed = false
  
  let sombrero = SKSpriteNode(imageNamed: "Sombrero")
  
  init(imageName: String) {
    super.init()
    
    let texture = SKTexture(imageNamed:imageName)
    spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
    addComponent(spriteComponent)
    
    sombrero.position = CGPoint(x: 31 - sombrero.size.width/2, y: 29 - sombrero.size.height/2)
    spriteComponent.node.addChild(sombrero)
    
    movementComponent = MovementComponent(entity: self)
    addComponent(movementComponent)
    
    movementComponent.applyInitialImpulse()
    
    var textures: Array<SKTexture> = []
    for i in 0..<numberOfFrames {
      textures.append(SKTexture(imageNamed: "Bird\(i)"))
    }
    
    for i in numberOfFrames.stride(through: 0, by: -1) {
      textures.append(SKTexture(imageNamed: "Bird\(i)"))
    }
    
    animationComponent = AnimationComponent(entity: self, textures: textures)
    addComponent(animationComponent)
    
    
    let spriteNode = spriteComponent.node
    
    let offsetX = spriteNode.frame.size.width * spriteNode.anchorPoint.x;
    let offsetY = spriteNode.frame.size.height * spriteNode.anchorPoint.y;
    
    let path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, 5 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, nil, 18 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, nil, 22 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, nil, 37 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, nil, 39 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, nil, 39 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, nil, 34 - offsetX, 2 - offsetY);
    CGPathAddLineToPoint(path, nil, 24 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, nil, 4 - offsetX, 0 - offsetY);
    
    CGPathCloseSubpath(path);
    
    spriteNode.physicsBody = SKPhysicsBody(polygonFromPath: path)
    spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Player
    spriteNode.physicsBody?.collisionBitMask = 0
    spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground
  }
}