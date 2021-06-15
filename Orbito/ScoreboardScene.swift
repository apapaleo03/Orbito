//
//  SettingsScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 5/4/21.
//

import SpriteKit

class ScoreboardScene: SKScene {

    let defaults = UserDefaults.standard
    var backButton: SKLabelNode!
    var scoreboardValue: SKLabelNode = SKLabelNode(fontNamed: gameFont)
    var scoreboardName: SKLabelNode = SKLabelNode(fontNamed: gameFont)
    var scoreboardLabel: SKLabelNode!
    
    
    
    

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "orbitoBackground.jpeg")
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: self.size)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        backButton = SKLabelNode(fontNamed: gameFont)
        backButton.text = "Back"
        backButton.fontColor = .white
        backButton.position = CGPoint(x: -(self.size.width/2 - 140), y:self.size.height/2-97 )
        backButton.name = "back"
        self.addChild(backButton)
        
        scoreboardLabel = SKLabelNode(fontNamed: gameFont)
        scoreboardLabel.text = "Scoreboard"
        scoreboardLabel.fontColor = .white
        scoreboardLabel.fontSize = 42
        scoreboardLabel.position = CGPoint(x: 0, y:350 )
        scoreboardLabel.name = "scoreboard"
        self.addChild(scoreboardLabel)
        
        
        
        if let highScores = loadScoreBoard(){
            var start: CGFloat = 230
            for score in highScores.entries.reversed(){
                displayScore(at: start, score: score)
                start -= 120
            }
        }
        
    }
    
    func displayScore(at y: CGFloat, score value: Score?){
        if let scoreLabel = scoreboardValue.copy() as? SKLabelNode{
            scoreLabel.text = "\(value!.score)"
            scoreLabel.fontColor = .white
            scoreLabel.position = CGPoint(x:60,y:y)
            self.addChild(scoreLabel)
        }
        if let scoreName = scoreboardName.copy() as? SKLabelNode{
            scoreName.text = value?.name
            scoreName.fontColor = .white
            scoreName.position = CGPoint(x:-60,y:y)
            self.addChild(scoreName)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)

            if node.name == "back" {
                if let view = view {
                    let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 1)
                    let scene = SKScene(fileNamed: "MenuScene")
                    scene?.scaleMode = .aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
        }
    }
}
