//
//  SettingsScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 5/4/21.
//

import SpriteKit

class HighScoresScene: SKScene {

    let defaults = UserDefaults.standard
    var backButton: SKLabelNode!
    var highScoreLabel: SKLabelNode = SKLabelNode(fontNamed: "Baskerville-Bold")
    var highScoreText: SKLabelNode!
    
    

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 9.0/255, green: 69.0/255, blue: 84.0/255, alpha: 1)
        
        backButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        backButton.text = "Back"
        backButton.fontColor = .white
        backButton.position = CGPoint(x: -(self.size.width/2 - 140), y:self.size.height/2-97 )
        backButton.name = "back"
        self.addChild(backButton)
        
        highScoreText = SKLabelNode(fontNamed: "Baskerville-Bold")
        highScoreText.text = "High Scores"
        highScoreText.fontColor = .white
        highScoreText.fontSize = 40
        highScoreText.position = CGPoint(x: 0, y:350 )
        highScoreText.name = "highscore"
        self.addChild(highScoreText)
        
        
        
        let highScores = defaults.object(forKey: "highScores") as? [Int] ?? []
        print(highScores)
        var start = 230
        for score in highScores.reversed(){
            displayScore(at: CGPoint(x: 0, y: start), score: score)
            start -= 60
        }
        
    }
    
    func displayScore(at pos: CGPoint, score value: Int?){
        if let scoreLabel = highScoreLabel.copy() as? SKLabelNode{
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
