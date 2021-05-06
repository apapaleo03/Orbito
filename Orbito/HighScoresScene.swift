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
    var highScoreLabel: SKLabelNode!
    
    

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 9.0/255, green: 69.0/255, blue: 84.0/255, alpha: 1)
        
        backButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        backButton.text = "Back"
        backButton.fontColor = .white
        backButton.position = CGPoint(x: -(self.size.width/2 - 140), y:self.size.height/2-97 )
        backButton.name = "back"
        self.addChild(backButton)
        
        let highScore = defaults.integer(forKey: "highScore")
        if highScore != 0 {
            highScoreLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
            highScoreLabel.text = "\(highScore)"
            highScoreLabel.fontColor = .white
            highScoreLabel.position = CGPoint(x: 0, y: 0)
            highScoreLabel.name = "highScore"
            self.addChild(highScoreLabel)
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
