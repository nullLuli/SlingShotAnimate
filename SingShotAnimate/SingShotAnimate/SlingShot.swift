//
//  SlingShot.swift
//  swiftLearn
//
//  Created by nullLuli on 2019/7/2.
//  Copyright © 2019 nullLuli. All rights reserved.
//

import Foundation
import UIKit

class SlingShotController: UIViewController {
    //view
    let slingShotView: SlingShotView = SlingShotView()
    
    //数据
    var beginPoint: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: beginY)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(slingShotView)
        slingShotView.frame = view.bounds
        slingShotView.backgroundColor = UIColor.white
        let path = getPathFromContr(leftContr: beginLeftContr, rightContr: beginRightContr)
        slingShotView.shapeLayer.path = path
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let currentPoint = gesture.location(in: view)
            let (leftContr, rightContr) = getContr(with: beginPoint, end: currentPoint)
            let path = getPathFromContr(leftContr: leftContr, rightContr: rightContr)
            slingShotView.shapeLayer.path = path
        case .ended:
            slingShotView.shapeLayer.path = getPathFromContr(leftContr: beginLeftContr, rightContr: beginRightContr)

            let currentPoint = gesture.location(in: view)
            animateSlingBack(end: currentPoint)
        default:
            ()
        }
    }
    
    func animateSlingBack(end: CGPoint) {
        let path1 = getKeyPath(with: beginPoint, end: end, precent: 1)
        let path2 = getKeyPath(with: beginPoint, end: end, precent: 0.4)
        let path3 = getKeyPath(with: beginPoint, end: end, precent: -0.2)
        let path4 = getKeyPath(with: beginPoint, end: end, precent: 0.1)
        let path5 = getKeyPath(with: beginPoint, end: end, precent: 0)
        
        let animate = CAKeyframeAnimation(keyPath: "path")
        animate.values = [path1, path2, path3, path4, path5]
        animate.isRemovedOnCompletion = true
        animate.duration = 1
        slingShotView.shapeLayer.add(animate, forKey: nil)
    }
    
    func getKeyPath(with begin: CGPoint, end: CGPoint, precent: CGFloat) -> CGPath {
        let newY = (end.y - begin.y) * precent + begin.y
        let newPoint = CGPoint(x: end.x, y: newY)
        let (leftContr, rightContr) = getContr(with: begin, end: newPoint)
        return getPathFromContr(leftContr: leftContr, rightContr: rightContr)
    }
    
    func getContr(with begin: CGPoint, end: CGPoint) -> (CGPoint, CGPoint) {
        let leftContrY = (end.y - begin.y) / 2 + begin.y + yContrDevi(diffY: (end.y - begin.y))
        let leftContrX = UIScreen.main.bounds.width / 3
        
        let rightContrY = leftContrY
        let rightContrX = UIScreen.main.bounds.width - leftContrX
        
        return (CGPoint(x: leftContrX, y: leftContrY), CGPoint(x: rightContrX, y: rightContrY))
    }
    
    func getPathFromContr(leftContr: CGPoint, rightContr: CGPoint) -> CGPath {
        let beginPoint: CGPoint = CGPoint(x: 0, y: beginY)
        let endPoint: CGPoint = CGPoint(x: UIScreen.main.bounds.width, y: beginY)
        
        let path = UIBezierPath.init()
        path.move(to: beginPoint)
        path.addCurve(to: endPoint, controlPoint1: leftContr, controlPoint2: rightContr)
        path.lineWidth = 2
        return path.cgPath
    }

    func yContrDevi(diffY: CGFloat) -> CGFloat {
        if diffY > 1 || diffY < -1 {
            let result: CGFloat = (1 / diffY) * -1 + 2 * diffY / abs(diffY)
            return result
        }
        return diffY
    }
}

let beginY: CGFloat = 400
let beginLeftContr = CGPoint(x: UIScreen.main.bounds.width / 3, y: beginY)
let beginRightContr = CGPoint(x: UIScreen.main.bounds.width * 2 / 3, y: beginY)

class SlingShotView: UIView {
    
    let shapeLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(shapeLayer)
        shapeLayer.frame = bounds
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
