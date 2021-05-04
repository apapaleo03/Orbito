//
//  GameScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 4/30/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ball : SKShapeNode?
    var staticNodes : Int?
    
    struct TouchInfo {
        var location: CGPoint
        var time: TimeInterval
    }
    var history : [TouchInfo]?
    var touchedNode: SKShapeNode?
    var scores: [Double] = [0.0]
    var previousTime: Double = 0.0
    
    var timerLabel: SKLabelNode!
    var timerValueLabel: SKLabelNode!
    var timerValue = 0.0 {
        didSet {
            timerValueLabel.text = "\(timerValue.roundToPlaces(places: 1))"
        }
    }
    
    var highScoreLabel: SKLabelNode!
    var highScoreValueLabel: SKLabelNode!
    var highScoreValue = 0.0 {
        didSet {
            highScoreValueLabel.text = "\(highScoreValue.roundToPlaces(places: 1))"
        }
    }
    
    var multiplierLabel: SKLabelNode!
    var multiplierValueLabel: SKLabelNode!
    var multiplierValue: Int = 0 {
        didSet {
            multiplierValueLabel.text = "\(multiplierValue)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(red: 9.0/255, green: 69.0/255, blue: 84.0/255, alpha: 1)
        
       
        
        
        // Define gravity
        //physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx:0, dy:0)
        let gravityVector = vector_float3(0,-1,0)
        let gravityNode = SKFieldNode.linearGravityField(withVector: gravityVector)
        gravityNode.strength = 0
        addChild(gravityNode)
        
        let gravityCategory : UInt32 = 0x1 << 0
        let gravity = SKFieldNode.radialGravityField()
        gravity.strength = 10
        gravity.categoryBitMask = gravityCategory
        gravity.falloff = 0
        
        
        // Create point at which ball orbits
        let w = (self.size.width + self.size.height) * 0.01
        
        let anchorPoint = SKShapeNode.init(circleOfRadius: w/2)
        anchorPoint.physicsBody = SKPhysicsBody(circleOfRadius: w/2)
        anchorPoint.physicsBody!.contactTestBitMask = anchorPoint.physicsBody!.collisionBitMask
        anchorPoint.physicsBody?.isDynamic = false
        anchorPoint.name = "anchor"
        anchorPoint.addChild(gravity)
        self.addChild(anchorPoint)
        
      
        // Create orbiting ball
        
        self.ball = SKShapeNode.init(circleOfRadius: w)
        self.ball?.position = CGPoint(x:0,y:10)
        self.ball?.lineWidth = 2.5
        
        self.ball?.physicsBody = SKPhysicsBody(circleOfRadius: w )
        self.ball?.physicsBody!.contactTestBitMask = (self.ball?.physicsBody!.collisionBitMask)!
        self.ball?.physicsBody?.restitution = 0.4
        self.ball?.physicsBody?.mass = 1
        self.ball?.physicsBody?.fieldBitMask = gravityCategory
        //self.ball?.addChild(gravity.copy() as! SKFieldNode)
        self.ball?.name = "ball"
        print(self.size.width)
        
        
        
        timerLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: 0, y: 530)
        timerLabel.text = "Timer"
        self.addChild(timerLabel)
        
        timerValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        timerValueLabel.fontColor = .white
        timerValueLabel.position = CGPoint(x: 0, y: 485)
        timerValueLabel.text = "\(timerValue)"
        self.addChild(timerValueLabel)
        
        
        highScoreLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        highScoreLabel.fontColor = .white
        highScoreLabel.position = CGPoint(x: -290, y: 530)
        highScoreLabel.text = "High Score"
        highScoreLabel.name = "highscore"
        self.addChild(highScoreLabel)
        
        highScoreValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        highScoreValueLabel.fontColor = .white
        highScoreValueLabel.position = CGPoint(x: -300, y: 485)
        highScoreValueLabel.text = "\(highScoreValue)"
        self.addChild(highScoreValueLabel)
        
        multiplierLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        multiplierLabel.fontColor = .white
        multiplierLabel.position = CGPoint(x: 300, y: 530)
        multiplierLabel.text = "Multiplier"
        self.addChild(multiplierLabel)
        
        multiplierValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        multiplierValueLabel.fontColor = .white
        multiplierValueLabel.position = CGPoint(x: 300, y: 485)
        multiplierValueLabel.text = "\(multiplierValue)"
        self.addChild(multiplierValueLabel)
        
        self.staticNodes = self.children.count
        
    }
    
    
    
    func touchDown(atPoint pos : CGPoint, atTime time : TimeInterval) {
        if let ball = self.ball?.copy() as? SKShapeNode {
            ball.physicsBody?.velocity = CGVector(dx:0,dy:0)
            ball.physicsBody?.isDynamic = false
            ball.position = pos
            ball.strokeColor = RandomColor()
            self.addChild(ball)
            var thisNode: SKShapeNode?
            self.history = [TouchInfo(location: pos, time: time)]
            for node in nodes(at: pos) {
                if node.name == "ball" {
                    thisNode = node as? SKShapeNode
                }
            }
            self.touchedNode = thisNode
        }
        
    }
    
    func touchMoved(toPoint pos : CGPoint, atTime time: TimeInterval) {
        //self.touchedNode?.position = pos
        self.history?.insert(TouchInfo(location: pos, time: time), at: 0)
    }
    
    func touchUp(atPoint pos : CGPoint,  last touch: TimeInterval) {
        
        self.scores.insert((timerValue - self.previousTime) * Double(self.multiplierValue) * 10, at: 0)
        self.previousTime = self.timerValue
        
        let wait = SKAction.wait(forDuration: 0.1)
        let block = SKAction.run({
            [unowned self] in
            self.timerValue += 0.1
        })
        let sequence = SKAction.sequence([wait,block])
        if action(forKey: "timer") == nil {
            run(SKAction.repeatForever(sequence), withKey: "timer")
        }
        
        
        self.multiplierValue += 1
        
        
        self.touchedNode?.physicsBody?.isDynamic = true
        if let history = self.history, history.count > 1 {
            var vx: CGFloat = 0.0
            var vy: CGFloat = 0.0
            var previousTouchInfo: TouchInfo?
            
            let maxIterations = 3
            let numElts: Int = min(history.count, maxIterations)
            for index in 0..<numElts {
                let touchInfo = history[index]
                let location = touchInfo.location
                if let previousTouch = previousTouchInfo {
                    let dx = location.x - previousTouch.location.x
                    let dy = location.y - previousTouch.location.y
                    //let dt = CGFloat(touchInfo.time - previousTouch.time)
                    
                    
                    vx += dx / 0.016
                    vy += dy / 0.016
                }
                previousTouchInfo = touchInfo
            }
            let count = CGFloat(numElts-1)
            let velocity = CGVector(dx: vx/count,dy: vy/count)
            self.touchedNode?.physicsBody?.velocity = velocity
        }
        self.history = nil
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first!
        let pos = t.location(in: self)
        let node = self.atPoint(pos)
        if node.name != "highscore"{
            self.touchDown(atPoint: t.location(in: self), atTime: t.timestamp)
        }else{
            if let view = view {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene = SKScene(fileNamed: "MenuScene")
                scene?.scaleMode = .aspectFill
                view.presentScene(scene!, transition: transition)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self), atTime: t.timestamp) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchUp(atPoint: t.location(in: self), last:t.timestamp) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self),last:t.timestamp) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let nodes = self.children
        if nodes.count - self.staticNodes! >= 10 {
            let width = self.size.width
            let height = self.size.height
            var outOfScene = 0
            for child in nodes{
                if child.name == "ball" {
                    if abs(child.position.x) > width || abs(child.position.y) > height {
                        outOfScene += 1
                    }
                }
                if outOfScene >= 10 {
                    collisionBetween(ball: child, object: child)
                    return
                }
            }
        }
        
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "anchor" || object.name == "ball"{
            if action(forKey: "timer") != nil {removeAction(forKey: "timer")}
            self.scores.insert((timerValue - self.previousTime) * Double(self.multiplierValue) * 10, at: 0)
            let currentScore = self.scores.reduce(0,+)
            self.scores = [0.0]
            if currentScore > self.highScoreValue{
                self.highScoreValue = currentScore
            }
            self.timerValue = 0.0
            self.multiplierValue = 0
            for child in self.children{
                if child.name == "ball"{
                    destroy(ball: child)
                }
            }
        }
    }
    
    func destroy(ball:SKNode){
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball:nodeB, object: nodeA)
        }
    }
    
}
