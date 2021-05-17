<img src="https://user-images.githubusercontent.com/50395024/90870215-3a5d8200-e3d4-11ea-8ae1-6e34f091e9f1.gif" width=200>



## [swift] UIBezierPath로 직선 및 도형 그리기

[블로그 설명](https://youjean.tistory.com/23)



<img src="https://blog.kakaocdn.net/dn/c1KmXO/btqG3kcOvye/Gt7ZPJgX6J2iUWBoXudDU1/img.png" width=600>



<img src="https://blog.kakaocdn.net/dn/l7sLB/btqG6fojmER/uUOlngF3JxrSzQ4SZOU2B0/img.png" width=60>



```swift
class View1: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        UIColor.systemRed.set()
        path.move(to: CGPoint(x: 10, y: 10)) // 시작점
        path.addLine(to: CGPoint(x: 30, y: 100)) // 직선을 그림
        path.addLine(to: CGPoint(x: 40, y: 50))
        path.close() // 현재 지점에서 시작 지점까지 직선 세그먼트를 추가하여 하위 경로를 닫음
        path.lineWidth = 5
        path.stroke()
    }
}
```



이런 방식으로 도형을 그릴 수 있습니다.

이를 바탕으로 옵션을 추가하여 여러 형태를 만들게 되는 것입니다.



```swift
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
```





## [swift] CAShapeLayer / CABasicAnimation / CAKeyframeAnimation

[블로그 설명](https://youjean.tistory.com/24)



단순히 선만 긋는 것이라면 path.stroke()이거나 path.fill()를 통해 그리기가 가능하지만

애니메이션을 넣을 것이라면

**CALayer**이라는 것을 활용해야합니다.



##### **CALayer (CA = Core Animation) **

\- UIView 는 CALayer 형태의 Layer 를 하나 가지고 있다.

\- CALayer 는 뷰의 구성 요소로 UI 기능을 담당한다.

\- SubView 들은 layer 위에 얹혀진다.

\- layer 는 여러 sublayer 를 가질 수 있다.



**▶CALayer 를 상속받는 클래스**

**1.** CATextLayer: 텍스트를 그리기 위한 레이어

**2.** CAGradientLayer: Gradient 를 주기위한 레이어

**3.** CAShapeLayer: Shape 를 그리기위한 레이어



```swift
class View3: UIView {
    override func draw(_ rect: CGRect) {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        // path.stroke()가 없어지고 아래 소스가 생김
        layer.path = path.cgPath
        layer.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(layer)
    }
}
```



#### [coreAnimation](https://developer.apple.com/documentation/quartzcore)



<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbVx58G%2FbtqG2GNUpuw%2FenwJyZKFp2Bi9kabs3gvdk%2Fimg.png" width=600>



**CABasicAnimation:** layer의 기본적인 애니메이션을 처리 할때 사용

**CATransition:** layer의 전환 즉, 화면이 이동이 되어 없어지거나 새로이 나타날때 사용

**CAKeyframeAnimation:** 애니메이션을 keyFrame단위로 쪼개어 각각의 keyFrame마다 효과를 주거나 다른 애니메이션을 하도록 설정할수 있음

그냥 조금더 복잡한 애니메이션처리를 하는 클래스 라고 생각 하면 된다



이제 아까 그린 직선에 애니메이션을 주어 보자

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbwqtwL%2FbtqGYKp1epu%2FT1Dezkch8xqUxhYQMBqz90%2Fimg.gif">

```swift
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
```

