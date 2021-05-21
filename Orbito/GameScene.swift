//
//  GameScene.swift
//  Orbito
//
//  Created by Andrea Papaleo on 4/30/21.
//

import SpriteKit
import GameplayKit
import Foundation

extension SKSpriteNode {
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ball : SKShapeNode?
    var staticNodes : Int?
    var history : [TouchInfo]?
    var touchedNode: SKShapeNode?
    var scoreBoardArray = UserDefaults.standard.object(forKey: "scoreboard") as? [Int] ?? []
    var w : CGFloat?
    let difficulty = UserDefaults.standard.string(forKey: "difficulty") ?? "easy"
    let gravity = SKFieldNode.radialGravityField()
    let gravityCategory : UInt32 = 0x1 << 0
    var currentlyTouched : Bool?
    var gameOverBox: SKSpriteNode!
    var mainMenuButton: SKLabelNode!
    var restartButton: SKLabelNode!
    var isGameOver = false
    var ballCount = 0
    var ballsLeft = 10
    var aimLine : SKShapeNode?
    var pathToDraw : CGMutablePath!
    
    
    var ballsLabel: SKLabelNode!
    var ballsValueLabel: SKLabelNode!
    var balls = 10 {
        didSet {
            ballsValueLabel.text = "\(balls)"
        }
    }

    
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
        self.view?.isMultipleTouchEnabled = false
        let background = SKSpriteNode(imageNamed: "orbitoBackground.jpeg")
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: self.size)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        w = (self.size.width + self.size.height) * 0.01
        
        // Define gravity
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx:0, dy:0)
        let gravityVector = vector_float3(0,-1,0)
        let gravityNode = SKFieldNode.linearGravityField(withVector: gravityVector)
        gravityNode.strength = 0
        addChild(gravityNode)
        
        self.gravity.strength = 10
        self.gravity.categoryBitMask = self.gravityCategory
        self.gravity.falloff = 0
        
        
        // Create point at which ball orbits
        createAnchor(at: CGPoint(x:0,y:0))
        
        
      
        // Create orbiting ball
        defineBall()
        
        
        createHighScoreLabels(x: -(self.size.width/2-140), y: self.size.height/2-97)
        createScoreLabels(x: -(self.size.width/10), y : self.size.height/2-97)
        createMultiplierLabels(x: self.size.width/2-140, y: self.size.height/2-97)
        createBallsLabels(x: (self.size.width/10), y: self.size.height/2-97)
        
        gameOverBox = SKSpriteNode(color: .black, size: CGSize(width: self.size.width*0.7,height: self.size.height*0.3))
        gameOverBox.position = CGPoint(x:0, y:0)
        gameOverBox.drawBorder(color: .white, width: 3)
        gameOverBox.isHidden = true
        self.addChild(gameOverBox)
        
        mainMenuButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        mainMenuButton.fontColor = .white
        mainMenuButton.fontSize = 30
        mainMenuButton.position = CGPoint(x: 0, y: -40)
        mainMenuButton.text = "Main Menu"
        mainMenuButton.name = "mainMenu"
        gameOverBox.addChild(mainMenuButton)
        
        restartButton = SKLabelNode(fontNamed: "Baskerville-Bold")
        restartButton.fontColor = .white
        restartButton.fontSize = 30
        restartButton.position = CGPoint(x: 0, y: 40)
        restartButton.text = "Restart"
        restartButton.name = "restart"
        gameOverBox.addChild(restartButton)
        
        
        self.staticNodes = self.children.count
        
    }
    
    func createAnchor(at pos: CGPoint){
        // Create point at which ball orbits
        
        let anchorPoint = SKShapeNode.init(circleOfRadius: self.w!/2)
        anchorPoint.physicsBody = SKPhysicsBody(circleOfRadius: self.w!/2)
        anchorPoint.physicsBody!.contactTestBitMask = anchorPoint.physicsBody!.collisionBitMask
        anchorPoint.physicsBody?.isDynamic = false
        anchorPoint.name = "anchor"
        anchorPoint.position = pos
        anchorPoint.addChild(self.gravity)
        self.addChild(anchorPoint)
    }
    
    func createTracker(at pos: CGPoint, called name: String, colored color: UIColor){
        // Create point at which ball orbits
        
        let tracker = SKShapeNode.init(circleOfRadius: self.w!/4)
        tracker.name = name
        tracker.position = pos
        tracker.strokeColor = color
        tracker.fillColor = color
        self.addChild(tracker)
    }
    
    func defineBall()  {
        self.ball = SKShapeNode.init(circleOfRadius: self.w!)
        self.ball?.lineWidth = 2.5
        self.ball?.physicsBody?.restitution = 0.4
        self.ball?.physicsBody?.mass = 1
        self.ball?.physicsBody?.fieldBitMask = gravityCategory
        self.ball?.name = "ball"
    }
    func createBall(at pos: CGPoint){
        if let ball = self.ball?.copy() as? SKShapeNode {
            ball.physicsBody?.velocity = CGVector(dx:0,dy:0)
            ball.physicsBody?.isDynamic = false
            ball.position = pos
            ball.strokeColor = RandomColor()
            ball.name = "protoball"
            self.addChild(ball)
            
        }
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
    
    func createBallsLabels(x: CGFloat, y: CGFloat){
        ballsLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        ballsLabel.fontColor = .white
        ballsLabel.fontSize = 24
        ballsLabel.position = CGPoint(x: x, y: y + 20)
        ballsLabel.text = "Balls Left"
        self.addChild(ballsLabel)
        
        ballsValueLabel = SKLabelNode(fontNamed: "Baskerville-Bold")
        ballsValueLabel.fontColor = .white
        ballsValueLabel.fontSize = 24
        ballsValueLabel.position = CGPoint(x: x, y: y - 20)
        ballsValueLabel.text = "\(balls)"
        self.addChild(ballsValueLabel)
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
    
    
    
    func startScorer() {
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
    }
    
    func showGameOver() {
        for child in self.children{
            if child.name == "protoball"{
                destroy(ball: child)
            }
        }
        let wait = SKAction.wait(forDuration: 1)
        let appear = SKAction.unhide()
        let sequence = SKAction.sequence([wait,appear])
        gameOverBox.run(sequence)
    }
    
    func speedBasedVelocity() -> CGVector {
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
                    let dt = CGFloat(touchInfo.time - previousTouch.time)
                    
                    
                    vx += dx / dt
                    vy += dy / dt
                }
                previousTouchInfo = touchInfo
            }
            let count = CGFloat(numElts-1)
            
            return CGVector(dx: -vx/count,dy: -vy/count)
        }
        return CGVector(dx: 0, dy: 0)
    }
    
    func distanceBasedVelocity() -> CGVector {
        if let history = self.history, history.count > 1 {
            var vx: CGFloat = 0.0
            var vy: CGFloat = 0.0
            let firstTouch = history.first
            let lastTouch = history.last
            let dx = lastTouch!.location.x - firstTouch!.location.x
            let dy = lastTouch!.location.y - firstTouch!.location.y
            vx = dx * 5
            vy = dy * 5
            return CGVector(dx: vx, dy: vy)
        }
        return CGVector(dx: 0, dy: 0)
    }
    
    func touchDown(atPoint pos : CGPoint, atTime time : TimeInterval) {
       
        self.currentlyTouched = true
        createBall(at: pos)
        
        var thisNode: SKShapeNode?
        self.history = [TouchInfo(location: pos, time: time)]
        for node in nodes(at: pos) {
            if node.name == "protoball" {
                thisNode = node as? SKShapeNode
            }
        }
        self.touchedNode = thisNode
        
        aimLine = SKShapeNode()
        
        pathToDraw = CGMutablePath()
        
        pathToDraw.move(to: pos)
        pathToDraw.addLine(to: pos)
        aimLine!.path = pathToDraw
        aimLine!.strokeColor = SKColor.white
        aimLine!.lineWidth = 3
        aimLine!.name = "aimLine"
       
        addChild(aimLine!)
        
    }
    
    func touchMoved(toPoint pos : CGPoint, atTime time: TimeInterval) {
        //self.touchedNode?.position = pos
        //print(pos)
        self.history?.insert(TouchInfo(location: pos, time: time), at: 0)
        if let history = self.history, history.count > 1{
            
            let firstTouch = history.first!.location
            
            let lastTouch = history.last!.location
            
            let x = lastTouch.x - (firstTouch.x - lastTouch.x)
            let y = lastTouch.y - (firstTouch.y - lastTouch.y)
            
            pathToDraw = CGMutablePath()
            
            pathToDraw.move(to: history.last!.location)
            pathToDraw.addLine(to: CGPoint(x: x,y: y))
            self.aimLine!.path = pathToDraw
        }
        
        
        
    }
    
    
    func touchUp(atPoint pos : CGPoint,  last touche: TimeInterval) {
        
        startScorer()

        self.touchedNode?.physicsBody?.isDynamic = true
        self.touchedNode?.physicsBody = SKPhysicsBody(circleOfRadius: self.w! )
        self.touchedNode?.physicsBody!.contactTestBitMask = (self.touchedNode?.physicsBody!.collisionBitMask)!
        self.touchedNode?.name = "ball \(ballCount)"
        
        let velocity: CGVector
        if self.difficulty == "easy" {
            velocity = distanceBasedVelocity()
        }else {
            velocity = speedBasedVelocity()
        }
        self.touchedNode?.physicsBody?.velocity = velocity
        self.history = nil
        self.touchedNode = nil
        ballCount += 1
        balls -= 1
        self.aimLine?.removeFromParent()
        
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let t = touches.first!
        let pos = t.location(in: self)
        let node = self.atPoint(pos)
        if node.name == "mainMenu"{
            if let view = view {
                let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 1)
                let scene = SKScene(fileNamed: "MenuScene")
                scene?.scaleMode = .aspectFill
                view.presentScene(scene!, transition: transition)
            }
            
        }else{
            if gameOverBox.isHidden{
                if !isGameOver && ballCount < 10{
                    self.touchDown(atPoint: t.location(in: self), atTime: t.timestamp)
                }
            }
                
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver{
            for t in touches { self.touchMoved(toPoint: t.location(in: self), atTime: t.timestamp) }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first!
        let pos = t.location(in: self)
        let node = self.atPoint(pos)
        if node.name == "restart"{
            self.ballCount = 0
            self.ballsLeft = 10
            self.balls = 10
            gameOverBox.isHidden = true
            self.isGameOver = false
        }else{
            if gameOverBox.isHidden{
                if !isGameOver && ballCount < 10{
                    for t in touches { self.touchUp(atPoint: t.location(in: self), last:t.timestamp) }
                }
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self),last:t.timestamp) }
    }
    
    
    fileprivate func track() {
        let nodes = self.children
        var ballNames : [String] = []
        var trackerNames: [String] = []
        var ballNumbers: [String] = []
        var trackerNumbers: [String] = []
        let width = self.size.width / 2
        let height = self.size.height / 2
        for child in nodes{
            if let name = child.name {
                if name.contains("ball"){
                    if (abs(child.position.x) > width - 75) || (abs(child.position.y) > height - 75) {
                        ballNames.append(name)
                        ballNumbers.append(name.components(separatedBy: " ")[1])
                    }
                }
                if name.contains("tracker"){
                    trackerNames.append(name)
                    trackerNumbers.append(name.components(separatedBy: " ")[1])
                }
            }
        }
        
        for tracker in trackerNumbers{
            if !ballNumbers.contains(tracker){
                self.childNode(withName: "tracker \(tracker)")?.removeFromParent()
            }
        }
        
        for name in ballNames{
            if let ball = self.childNode(withName: name) as? SKShapeNode{
                let number = name.components(separatedBy: " ")[1]
                let color = ball.strokeColor
                let trackerName = "tracker \(number)"
                if trackerNames.contains(trackerName){
                    let tracker = self.childNode(withName: trackerName) as! SKShapeNode
                    tracker.position = mapToEdge(point: ball.position, screenSize: self.size)
                    
                }
                else
                {
                    createTracker(at: mapToEdge(point: ball.position, screenSize: self.size), called: trackerName, colored: color)
                    
                }
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if difficulty == "easy"{
            track()
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        
        if object.name == "anchor" || object.name!.contains("ball") {
            
            if let fireParticles = SKEmitterNode(fileNamed: "secondaryImpact") {
                fireParticles.position = CGPoint(x: (ball.position.x + object.position.x)/2, y: (ball.position.y + object.position.y)/2)
                addChild(fireParticles)
            }
            if object.name!.contains("ball"){
                ballsLeft -= 2
                multiplierValue -= 2
                ball.removeFromParent()
                object.removeFromParent()
            }else{
                ballsLeft -= 1
                multiplierValue -= 1
                ball.removeFromParent()
            }
            
            if ballsLeft == 0{
                if action(forKey: "timer") != nil {removeAction(forKey: "timer")}
                
                if self.score > self.highScoreValue{
                    self.highScoreValue = self.score
                    self.scoreBoardArray.append(self.highScoreValue)
                    if self.scoreBoardArray.count > 10{
                        self.scoreBoardArray.removeFirst()
                    }
                    UserDefaults.standard.set(self.scoreBoardArray, forKey: "scoreboard")
                }
                self.score = 0
                self.multiplierValue = 0
                
                /*for child in self.children{
                    if child.name == "ball"{
                        destroy(ball: child)
                    }
                }*/
                
                self.isGameOver = true
                showGameOver()
            }
        }
        
    }
    
    func destroy(ball:SKNode){
        /*
        if let fireParticles = SKEmitterNode(fileNamed: "secondaryImpact") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }*/
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name!.contains("ball") {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name!.contains("ball") {
            collisionBetween(ball:nodeB, object: nodeA)
        }
    }
    
}
