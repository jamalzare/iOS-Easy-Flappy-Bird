import SpriteKit
import GameplayKit

class EntityNode: SKSpriteNode {
  weak var entity: GKEntity!
}

class SpriteComponent: GKComponent {
  let node: EntityNode
  
  init(entity: GKEntity, texture: SKTexture, size: CGSize) {
    node = EntityNode(texture: texture, color: SKColor.whiteColor(), size: size)
    node.entity = entity
  }
}