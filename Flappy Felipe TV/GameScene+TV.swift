

import SpriteKit

extension GameScene: TVControlsScene {
  func setupTVControls() {
    let tap = UITapGestureRecognizer(target: self,
      action: "didTapOnRemote:")
    view!.addGestureRecognizer(tap)
  }
  
  func didTapOnRemote(tap: UITapGestureRecognizer) {
    switch gameState.currentState {
    case is MainMenuState:
      restartGame(TutorialState)
    case is TutorialState:
      gameState.enterState(PlayingState)
    case is PlayingState:
      player.movementComponent.applyImpulse(lastUpdateTimeInterval)
    case is GameOverState:
      restartGame(TutorialState)
    default:
      break
    }
  }
}