//
//  SettingsScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 5/4/21.
//

import SpriteKit

class SettingsScene: SKScene {

    var backButton : SKLabelNode!
    var resetButton: SKLabelNode!
    var easyButton: SKLabelNode!
    var mediumButton: SKLabelNode!
    var hardButton: SKLabelNode!
    var difficultyLabel: SKLabelNode!
    var underline: SKSpriteNode!
    var easyLine: SKShapeNode!
    var mediumLine: SKShapeNode!
    var hardLine: SKShapeNode!
    var pathToDraw : CGMutablePath!
    
    var difficultyMode = UserDefaults.standard.string(forKey: "difficulty") ?? "easy"
    

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "orbitoBackground.jpeg")
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: self.size)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        
        
        difficultyLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        difficultyLabel.text = "Difficulty"
        difficultyLabel.fontColor = .white
        difficultyLabel.position = CGPoint(x: 0, y: 120)
        difficultyLabel.name = "difficulty"
        self.addChild(difficultyLabel)
        
        easyButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        easyButton.position = CGPoint(x: -120, y: 80)
        easyButton.text = "Easy"
        easyButton.name = "easy"
        easyButton.color = .gray
        //setColor(of: easyButton, using: difficultyMode)
        self.addChild(easyButton)
        
        easyLine = SKShapeNode()
        
        pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: -120 - 30.0, y: 75))
        pathToDraw.addLine(to: CGPoint(x: -120 + 30, y: 75))
        easyLine.path = pathToDraw
        easyLine.strokeColor = SKColor.white
        easyLine.lineWidth = 3
        if difficultyMode == "easy"{
            easyLine.isHidden = false
        }else{
            easyLine.isHidden = true
        }
        addChild(easyLine)
        
        mediumButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        mediumButton.position = CGPoint(x: 0, y: 80)
        mediumButton.text = "Medium"
        mediumButton.name = "medium"
        setColor(of: mediumButton, using: difficultyMode)
        self.addChild(mediumButton)
        
        mediumLine = SKShapeNode()
        pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: 0-60, y: 75))
        pathToDraw.addLine(to: CGPoint(x: 0+60, y: 75))
        mediumLine.path = pathToDraw
        mediumLine.strokeColor = SKColor.white
        mediumLine.lineWidth = 3
        print(difficultyMode)
        if difficultyMode == "medium"{
            mediumLine.isHidden = false
        }else{
            mediumLine.isHidden = true
        }
        addChild(mediumLine)
        
        hardButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        hardButton.position = CGPoint(x: 120, y: 80)
        hardButton.text = "Hard"
        hardButton.name = "hard"
        setColor(of: hardButton, using: difficultyMode)
        self.addChild(hardButton)
        
        hardLine = SKShapeNode()
        pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: 120-35, y: 75))
        pathToDraw.addLine(to: CGPoint(x: 120+35, y: 75))
        hardLine.path = pathToDraw
        hardLine.strokeColor = SKColor.white
        hardLine.lineWidth = 3
        if difficultyMode == "hard"{
            hardLine.isHidden = false
        }else{
            hardLine.isHidden = true
        }
        addChild(hardLine)
        
        
        backButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        backButton.text = "Back"
        backButton.fontColor = .white
        backButton.position = CGPoint(x: -(self.size.width/2 - 140), y:self.size.height/2-97 )
        backButton.name = "back"
        self.addChild(backButton)
        
        resetButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        resetButton.text = "Reset"
        resetButton.fontColor = .white
        resetButton.position = CGPoint(x: 0, y: -40)
        resetButton.name = "reset"
        self.addChild(resetButton)
    }
    
    
    func setColor(of label: SKLabelNode ,using difficulty: String){
        if label.name == difficulty{
            label.color = .white
        }else{
            label.color = .gray
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
            }else if node.name == "reset"{
                UserDefaults.standard.removeObject(forKey: "scoreboard")
            }else if node.name == "easy" || node.name == "medium" || node.name == "hard" {
                self.difficultyMode = node.name!
                UserDefaults.standard.set(node.name!, forKey: "difficulty")
                if difficultyMode == "easy"{
                    easyLine.isHidden = false
                    mediumLine.isHidden = true
                    hardLine.isHidden = true
                }else if difficultyMode == "medium"{
                    easyLine.isHidden = true
                    mediumLine.isHidden = false
                    hardLine.isHidden = true
                }else if difficultyMode == "hard"{
                    easyLine.isHidden = true
                    mediumLine.isHidden = true
                    hardLine.isHidden = false
                }
            }
        }
    }
}
