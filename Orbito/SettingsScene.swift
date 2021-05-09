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
    
    var difficultyMode = UserDefaults.standard.string(forKey: "difficulty") ?? "easy"
    

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 9.0/255, green: 69.0/255, blue: 84.0/255, alpha: 1)
        
        
        addDiffucultyButton(at: CGPoint(x: -120, y: 80), difficulty: "Easy")
        addDiffucultyButton(at: CGPoint(x: 0, y: 80), difficulty: "Medium")
        addDiffucultyButton(at: CGPoint(x: 120, y: 80), difficulty: "Hard")
        
        backButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        backButton.text = "Back"
        backButton.fontColor = .white
        backButton.position = CGPoint(x: 0, y: 40)
        backButton.name = "back"
        self.addChild(backButton)
        
        resetButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        resetButton.text = "Reset"
        resetButton.fontColor = .white
        resetButton.position = CGPoint(x: 0, y: -40)
        resetButton.name = "reset"
        self.addChild(resetButton)
    }
    
    func addDiffucultyButton(at pos: CGPoint, difficulty level: String){
        let difficultyButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        difficultyButton.text = level
        difficultyButton.position = pos
        difficultyButton.name = level.lowercased()
        difficultyButton.color = .brown
        /*if self.difficultyMode == level.lowercased(){
            difficultyButton.color = .darkGray
        }else{
            difficultyButton.color = .darkGray
        }*/
        
        self.addChild(difficultyButton)
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
                let thisNode = node as! SKLabelNode
                thisNode.color = .darkGray
            }
        }
    }
}
