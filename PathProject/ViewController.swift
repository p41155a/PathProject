//
//  ViewController.swift
//  PathProject
//
//  Created by Yoojin Park on 2020/08/20.
//  Copyright © 2020 Yoojin Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var view1: View1!
    @IBOutlet weak var view2: View2!
    @IBOutlet weak var view4: View4!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.draw(CGRect.init())
        view2.draw(CGRect.init())
    }
}

class View1: UIView {
    // 그냥 선만 그을 것이라면 UIBezierPath만 사용 가능
    // 이 draw 함수 내에서만 그려지는 이유 궁금
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        UIColor.systemRed.set()
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 30, y: 100))
        path.addLine(to: CGPoint(x: 40, y: 50))
//        path.close()
        // 위 주석 풀면 첫 위치와 마지막 위치 이어줌
        path.lineWidth = 5
//        path.lineCapStyle = .round
//        path.lineJoinStyle = .round
        
        let pattern: [CGFloat] = [6,4]
        path.setLineDash(pattern, count: pattern.count, phase: 0)
        
        path.stroke()
    }
}

class View2: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: self.frame.width/2, y: 30))
        path.addLine(to: CGPoint(x: self.frame.width/2 - sqrt(2700), y: 120))
        path.addLine(to: CGPoint(x: self.frame.width/2 + sqrt(2700), y: 120))
        path.close()
        
        UIColor.black.set()
        path.stroke()
        
        UIColor.yellow.set()
        path.fill()
        
        // 원 그리는법 1
        let circlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: self.frame.width/2-30, y: 60), size: CGSize(width: 60, height: 60)), cornerRadius: 30)
        UIColor.black.set()
        circlePath.stroke()
        UIColor.green.setFill()
        circlePath.fill()
        
        // 원 그리는법 2
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: 90), radius: 30, startAngle: 0, endAngle: (135 * .pi) / 180, clockwise: true)
//        UIColor.black.set()
//        circlePath.stroke()
    }
}
class View3: UIView {
    override func draw(_ rect: CGRect) {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        layer.path = path.cgPath
        layer.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(layer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3
        animation.repeatCount = HUGE
        layer.add(animation, forKey: "scoreAnimation")
    }
}

class View4: UIView {
    let circleSpacing: CGFloat = 2
    let circleSize: CGFloat = 30
    let currentTime = CACurrentMediaTime()
    let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
    // 각 원의 애니메이션 시작시간
//    let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.8, 0.18, 1.08) // 베지어곡선을 이용한 커스텀
    let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    //CAMediaTimingFunction : 애니메이션의 속도를 타이밍 곡선으로 정의하는 함수입니다.
    let animation = CAKeyframeAnimation(keyPath: "transform.scale")
    let colorKeyframeAnimation = CAKeyframeAnimation(keyPath: "fillColor")

    override func draw(_ rect: CGRect) {
        
        animation.keyTimes = [0, 0.3, 1]
        // keyTimes의 시간 축은 항상 0.0~1
        animation.timingFunctions = [timingFunction, timingFunction]
        //쪼갠 keyFrame마다 동작하는 애니메이션의 option을 지정
        animation.values = [1, 0.3, 1, 0.3, 1, 0.3, 1]
        animation.duration = 2
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        for i in 0 ..< 3 {
            let path: UIBezierPath = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: circleSize / 2, y: circleSize / 2),
                        radius: circleSize / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: false)
            
            let circle: CAShapeLayer = CAShapeLayer()
            circle.path = path.cgPath
            circle.backgroundColor = nil
            switch i {
            case 0:
                circle.fillColor = UIColor.purple.cgColor
            case 1:
                circle.fillColor = UIColor.red.cgColor
            case 2:
                circle.fillColor = UIColor.orange.cgColor
            default:
                circle.fillColor = UIColor.red.cgColor
            }
            
            let frame = CGRect(x: circleSize * CGFloat(i) + circleSpacing * CGFloat(i), y: 0, width: circleSize, height: circleSize)
            circle.frame = frame

            animation.beginTime = currentTime + beginTimes[i]
            
            circle.add(animation, forKey: "animation1")
            circle.add(colorKeyframeAnimation, forKey: "animation2")
            self.layer.addSublayer(circle)
        }
    }
}
