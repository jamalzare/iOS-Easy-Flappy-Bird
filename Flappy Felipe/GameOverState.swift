import SpriteKit
import GameplayKit

class GameOverState: GKState {
  unowned let scene: GameScene
  
  let hitGroundAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
  let animationDelay = 0.3
  
  init(scene: SKScene) {
    self.scene = scene as! GameScene
    super.init()
  }
  
  override func didEnterWithPreviousState(previousState: GKState?) {
    scene.runAction(hitGroundAction)
    scene.stopSpawning()
    
    scene.player.movementAllowed = false
    
    showScorecard()
  }
  
  override func isValidNextState(stateClass: AnyClass) -> Bool {
    return stateClass is PlayingState.Type
  }
  
  override func updateWithDeltaTime(seconds: NSTimeInterval) {
    
  }
  
  // MARK: Scoring
  
  func setBestScore(bestScore: Int) {
    NSUserDefaults.standardUserDefaults().setInteger(bestScore, forKey: "BestScore")
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  func bestScore() -> Int {
    return NSUserDefaults.standardUserDefaults().integerForKey("BestScore")
  }
  
  func showScorecard() {
    if scene.score > bestScore() {
      setBestScore(scene.score)
    }
    
    let scorecard = SKSpriteNode(imageNamed: "ScoreCard")
    scorecard.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
    scorecard.name = "Tutorial"
    scorecard.zPosition = Layer.UI.rawValue
    scene.worldNode.addChild(scorecard)
    
    let lastScore = SKLabelNode(fontNamed: scene.fontName)
    lastScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    lastScore.position = CGPoint(x: -scorecard.size.width * 0.25, y: -scorecard.size.height * 0.2)
    lastScore.zPosition = Layer.UI.rawValue
    lastScore.text = "\(scene.score/2)"
    scorecard.addChild(lastScore)
    
    let bestScoreLabel = SKLabelNode(fontNamed: scene.fontName)
    bestScoreLabel.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    bestScoreLabel.position = CGPoint(x: scorecard.size.width * 0.25, y: -scorecard.size.height * 0.2)
    bestScoreLabel.zPosition = Layer.UI.rawValue
    bestScoreLabel.text = "\(bestScore()/2)"
    scorecard.addChild(bestScoreLabel)
    
    let gameOver = SKSpriteNode(imageNamed: "GameOver")
    gameOver.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2 + scorecard.size.height/2 + scene.margin + gameOver.size.height/2)
    gameOver.zPosition = Layer.UI.rawValue
    scene.worldNode.addChild(gameOver)
    
    let okButton = SKSpriteNode(imageNamed: "Button")
    okButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height/2 - scorecard.size.height/2 - scene.margin - okButton.size.height/2)
    okButton.zPosition = Layer.UI.rawValue
    scene.worldNode.addChild(okButton)
    
    let ok = SKSpriteNode(imageNamed: "OK")
    ok.position = CGPoint.zero
    ok.zPosition = Layer.UI.rawValue
    okButton.addChild(ok)
    
    let shareButton = SKSpriteNode(imageNamed: "Button")
    shareButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height/2 - scorecard.size.height/2 - scene.margin - shareButton.size.height/2)
    shareButton.zPosition = Layer.UI.rawValue
    scene.worldNode.addChild(shareButton)
    
    let share = SKSpriteNode(imageNamed: "Share")
    share.position = CGPoint.zero
    share.zPosition = Layer.UI.rawValue
    shareButton.addChild(share)
    
    // Juice
    gameOver.setScale(0)
    gameOver.alpha = 0
    let group = SKAction.group([
      SKAction.fadeInWithDuration(animationDelay),
      SKAction.scaleTo(1.0, duration: animationDelay)
      ])
    group.timingMode = .EaseInEaseOut
    gameOver.runAction(SKAction.sequence([
      SKAction.waitForDuration(animationDelay),
      group
      ]))
    
    scorecard.position = CGPoint(x: scene.size.width * 0.5, y: -scorecard.size.height/2)
    let moveTo = SKAction.moveTo(CGPoint(x: scene.size.width/2, y: scene.size.height/2), duration: animationDelay)
    moveTo.timingMode = .EaseInEaseOut
    scorecard.runAction(SKAction.sequence([
      SKAction.waitForDuration(animationDelay * 2),
      moveTo
      ]))
    
    okButton.alpha = 0
    shareButton.alpha = 0
    let fadeIn = SKAction.sequence([
      SKAction.waitForDuration(animationDelay * 3),
      SKAction.fadeInWithDuration(animationDelay)
      ])
    okButton.runAction(fadeIn)
    shareButton.runAction(fadeIn)
    
    let pops = SKAction.sequence([
      SKAction.waitForDuration(animationDelay),
      scene.popAction,
      SKAction.waitForDuration(animationDelay),
      scene.popAction,
      SKAction.waitForDuration(animationDelay),
      scene.popAction
      ])
    scene.runAction(pops)
    
    // At the time of this recording, links were not supported so hide the buttons on tvOS
    #if os(tvOS)
    
      // Bounce button
      let scaleUp = SKAction.scaleTo(1.02, duration: 0.75)
      scaleUp.timingMode = .EaseInEaseOut
      let scaleDown = SKAction.scaleTo(0.98, duration: 0.75)
      scaleDown.timingMode = .EaseInEaseOut
    
      okButton.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2 + -scorecard.size.height)
      shareButton.hidden = true
    
      okButton.runAction(SKAction.repeatActionForever(SKAction.sequence([
            scaleUp, scaleDown
        ])))
    #endif
  }
}