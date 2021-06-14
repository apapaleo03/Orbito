//
//  TestScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 5/28/21.
//

import Foundation

import SpriteKit

class TestScene: SKScene, UITextFieldDelegate {

    let defaults = UserDefaults.standard
    var backButton: SKLabelNode!
    
    let gameOver = SKLabelNode(fontNamed: "Baskerville-Bold")
    let submitScoreText = SKLabelNode(fontNamed: "Baskerville-Bold")
    let submitScoreTextShadow = SKLabelNode(fontNamed: "Baskerville-Bold")
    var highScoreText: UITextField!
    
    
    
    

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
        
        highScoreText = UITextField(frame: CGRect(x: view.bounds.width/2 - 160 ,y: view.bounds.height / 2 + 20, width:320, height:40))
        //view.addSubview(highScoreText)
        highScoreText.delegate = self
        
        highScoreText.borderStyle = .roundedRect
        highScoreText.textColor = .black
        highScoreText.placeholder = "Enter your name here"
        highScoreText.backgroundColor = .white
        highScoreText.autocorrectionType = .yes
        
        highScoreText.clearButtonMode = .whileEditing
        highScoreText.autocapitalizationType = .allCharacters
        self.view!.addSubview(highScoreText)
        
        submitScoreText.fontSize = 22
        submitScoreText.position = CGPoint(x: 0, y: 0)
        
        submitScoreText.text = "your text will show here"
        addChild(submitScoreText)
        
        
       
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitScoreText.text = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)

            if node.name == "back" {
                if let view = view {
                    highScoreText.removeFromSuperview()
                    let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 1)
                    let scene = SKScene(fileNamed: "MenuScene")
                    scene?.scaleMode = .aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
        }
    }
}
