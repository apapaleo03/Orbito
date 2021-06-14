//
//  MenuScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 5/1/21.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {

    var playButtonLabel : SKLabelNode!
    var scoreboardButton : SKLabelNode!
    var settingsButton : SKLabelNode!
    var testButton : SKLabelNode!

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "orbitoBackground.jpeg")
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: self.size)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        playButtonLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        playButtonLabel.text = "Play"
        playButtonLabel.fontColor = .white
        playButtonLabel.position = CGPoint(x: 0, y: 80)
        playButtonLabel.name = "play"
        self.addChild(playButtonLabel)
        
        scoreboardButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreboardButton.text = "Scoreboard"
        scoreboardButton.fontColor = .white
        scoreboardButton.position = CGPoint(x: 0, y: 0)
        scoreboardButton.name = "scoreboard"
        self.addChild(scoreboardButton)
        
        settingsButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        settingsButton.text = "Settings"
        settingsButton.fontColor = .white
        settingsButton.position = CGPoint(x: 0, y: -80)
        settingsButton.name = "settings"
        self.addChild(settingsButton)
        
        
        testButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        testButton.text = "Test"
        testButton.fontColor = .white
        testButton.position = CGPoint(x: 0, y: -160)
        testButton.name = "test"
        self.addChild(testButton)
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
            }else if node.name == "scoreboard" {
                if let view = view {
                    let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    let scene = SKScene(fileNamed: "ScoreboardScene")
                    scene?.scaleMode = .aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }else if node.name == "test" {
                if let view = view {
                    let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    let scene = SKScene(fileNamed: "TestScene")
                    scene?.scaleMode = .aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
        }
    }
}
