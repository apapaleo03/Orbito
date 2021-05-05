//
//  MenuScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 5/1/21.
//

import SpriteKit

class MenuScene: SKScene {

    var playButtonLabel : SKLabelNode!
    var highScoreButton : SKLabelNode!
    var settingsButton : SKLabelNode!

    override func didMove(to view: SKView) {
        
        playButtonLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        playButtonLabel.text = "Play"
        playButtonLabel.fontColor = .white
        playButtonLabel.position = CGPoint(x: 0, y: 80)
        playButtonLabel.name = "play"
        self.addChild(playButtonLabel)
        
        highScoreButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        highScoreButton.text = "High Score"
        highScoreButton.fontColor = .white
        highScoreButton.position = CGPoint(x: 0, y: 0)
        highScoreButton.name = "highscore"
        self.addChild(highScoreButton)
        
        settingsButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        settingsButton.text = "Settings"
        settingsButton.fontColor = .white
        settingsButton.position = CGPoint(x: 0, y: -80)
        settingsButton.name = "settings"
        self.addChild(settingsButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)

            if node.name == "play" {
                if let view = view {
                    let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    let scene = SKScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }else if node.name == "settings" {
                if let view = view {
                    let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    let scene = SKScene(fileNamed: "SettingsScene")
                    scene?.scaleMode = .aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }else if node.name == "highscore" {
                if let view = view {
                    let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    let scene = SKScene(fileNamed: "HighScoresScene")
                    scene?.scaleMode = .aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
        }
    }
}
