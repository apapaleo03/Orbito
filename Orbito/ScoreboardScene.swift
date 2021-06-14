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
    var scoreboardValue: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
    var scoreboardLabel: SKLabelNode!
    
    
    
    

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "orbitoBackground.jpeg")
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: self.size)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        backButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        backButton.text = "Back"
        backButton.fontColor = .white
        backButton.position = CGPoint(x: -(self.size.width/2 - 140), y:self.size.height/2-97 )
        backButton.name = "back"
        self.addChild(backButton)
        
        scoreboardLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreboardLabel.text = "Scoreboard"
        scoreboardLabel.fontColor = .white
        scoreboardLabel.fontSize = 40
        scoreboardLabel.position = CGPoint(x: 0, y:350 )
        scoreboardLabel.name = "scoreboard"
        self.addChild(scoreboardLabel)
        
        
        
        let highScores = defaults.object(forKey: "scoreboard") as? [Int] ?? []
        var start = 230
        for score in highScores.reversed(){
            displayScore(at: CGPoint(x: 0, y: start), score: score)
            start -= 60
        }
        
    }
    
    func displayScore(at pos: CGPoint, score value: Int?){
        if let scoreLabel = scoreboardValue.copy() as? SKLabelNode{
            scoreLabel.text = "\(value!)"
            scoreLabel.fontColor = .white
            scoreLabel.position = pos
            self.addChild(scoreLabel)
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
