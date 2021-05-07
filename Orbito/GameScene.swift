//
//  GameScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 4/30/21.
//

import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ball : SKShapeNode?
    var staticNodes : Int?
    var history : [TouchInfo]?
    var touchedNode: SKShapeNode?
    var scoreBoardArray = UserDefaults.standard.object(forKey: "scoreboard") as? [Int] ?? []
    
    struct TouchInfo {
        var location: CGPoint
        var time: TimeInterval
    }

    
    var scoreLabel: SKLabelNode!
    var scoreValueLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreValueLabel.text = "\(score)"
        }
    }
    
    
    var highScoreLabel: SKLabelNode!
    var highScoreValueLabel: SKLabelNode!
    var highScoreValue = 0 {
        didSet {
            highScoreValueLabel.text = "\(highScoreValue)"
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
        print(self.size)
        self.backgroundColor = UIColor(red: 9.0/255, green: 69.0/255, blue: 84.0/255, alpha: 1)
        
        
        // Define gravity
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
        let anchorPoint = createAnchor(at: CGPoint(x:0,y:0))
        anchorPoint.addChild(gravity)
        self.addChild(anchorPoint)
        
      
        // Create orbiting ball
        defineBall()
        self.ball?.physicsBody?.fieldBitMask = gravityCategory
        
        createHighScoreLabels(x: -(self.size.width/2-140), y: self.size.height/2-97)
        createScoreLabels(x: 0, y : self.size.height/2-97)
        createMultiplierLabels(x: self.size.width/2-140, y: self.size.height/2-97)
        
        
        self.staticNodes = self.children.count
        
    }
    
    func createAnchor(at pos: CGPoint) -> SKShapeNode{
        // Create point at which ball orbits
        let w = (self.size.width + self.size.height) * 0.01
        
        let anchorPoint = SKShapeNode.init(circleOfRadius: w/2)
        anchorPoint.physicsBody = SKPhysicsBody(circleOfRadius: w/2)
        anchorPoint.physicsBody!.contactTestBitMask = anchorPoint.physicsBody!.collisionBitMask
        anchorPoint.physicsBody?.isDynamic = false
        anchorPoint.name = "anchor"
        anchorPoint.position = pos
        return anchorPoint
    }
    
    func defineBall()  {
        let w = (self.size.width + self.size.height) * 0.01
        self.ball = SKShapeNode.init(circleOfRadius: w)
        self.ball?.lineWidth = 2.5
        self.ball?.physicsBody = SKPhysicsBody(circleOfRadius: w )
        self.ball?.physicsBody!.contactTestBitMask = (self.ball?.physicsBody!.collisionBitMask)!
        self.ball?.physicsBody?.restitution = 0.4
        self.ball?.physicsBody?.mass = 1
        self.ball?.name = "ball"
    }
    
    func createScoreLabels(x: CGFloat, y: CGFloat){
        scoreLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: x, y: y + 20)
        scoreLabel.text = "Score"
        self.addChild(scoreLabel)
        
        scoreValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        scoreValueLabel.fontColor = .white
        scoreValueLabel.fontSize = 24
        scoreValueLabel.position = CGPoint(x: x, y: y - 20)
        scoreValueLabel.text = "\(score)"
        self.addChild(scoreValueLabel)
    }
    
    func createHighScoreLabels(x: CGFloat, y: CGFloat){
        highScoreLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        highScoreLabel.fontColor = .white
        highScoreLabel.fontSize = 24
        highScoreLabel.position = CGPoint(x: x, y: y + 20)
        highScoreLabel.text = "High Score"
        highScoreLabel.name = "highscore"
        self.addChild(highScoreLabel)
        
        highScoreValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        highScoreValueLabel.fontColor = .white
        highScoreValueLabel.fontSize = 24
        highScoreValueLabel.position = CGPoint(x: x, y: y - 20)
        if !scoreBoardArray.isEmpty{
            self.highScoreValue = scoreBoardArray.last!
        }
        highScoreValueLabel.text = "\(highScoreValue)"
        self.addChild(highScoreValueLabel)
    }
    
    func createMultiplierLabels(x: CGFloat, y: CGFloat){
        multiplierLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        multiplierLabel.fontColor = .white
        multiplierLabel.fontSize = 24
        multiplierLabel.position = CGPoint(x: x, y: y + 20)
        multiplierLabel.text = "Multiplier"
        self.addChild(multiplierLabel)
        
        multiplierValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        multiplierValueLabel.fontColor = .white
        multiplierValueLabel.fontSize = 24
        multiplierValueLabel.position = CGPoint(x: x, y: y - 20)
        multiplierValueLabel.text = "\(multiplierValue)"
        self.addChild(multiplierValueLabel)
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
        
        
        let wait = SKAction.wait(forDuration: 0.1)
        let block = SKAction.run({
            [unowned self] in
            self.score += Int(0.1 * Double(self.multiplierValue * 10))
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
            /*
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
             */
            let firstTouch = history.first
            let lastTouch = history.last
            let dx = lastTouch!.location.x - firstTouch!.location.x
            let dy = lastTouch!.location.y - firstTouch!.location.y
            vx = dx * 5
            vy = dy * 5
            self.touchedNode?.physicsBody?.velocity = CGVector(dx: vx, dy: vy)
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
                let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 1)
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
            
            if self.score > self.highScoreValue{
                self.highScoreValue = self.score
                //let highScoreObject = HighScore(player: "Player", score: self.highScoreValue, dateOfScore: NSDate.init())
                //let encodedData = try NSKeyedArchiver.archivedData(withRootObject: highScoreObject, requiringSecureCoding: false)
                self.scoreBoardArray.append(self.highScoreValue)
                if self.scoreBoardArray.count > 10{
                    self.scoreBoardArray.removeFirst()
                }
                print(self.scoreBoardArray)
                UserDefaults.standard.set(self.scoreBoardArray, forKey: "scoreboard")
            }
            self.score = 0
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
