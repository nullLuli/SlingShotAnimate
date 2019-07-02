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
    var beginPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(slingShotView)
        slingShotView.frame = view.bounds
        slingShotView.backgroundColor = UIColor.white
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            beginPoint = gesture.location(in: view)
//            debugPrint("begin: \(gesture.location(in: view))")
        case .changed:
            let currentPoint = gesture.location(in: view)
            if let begin = beginPoint {
                changeLine(begin: begin, current: currentPoint)
            }
//            debugPrint("changed: \(gesture.location(in: view))")
        case .possible:
            ()
//            debugPrint("possible: \(gesture.location(in: view))")
        default:
            ()
        }
    }
    
    func changeLine(begin: CGPoint, current: CGPoint) {
        let leftContr1Y = (current.y - begin.y) / 3 + beginY - yDeviation
        let leftContr1X = UIScreen.main.bounds.width / 6
        
        let leftContr2Y = (current.y - begin.y) * 2 / 3 + beginY - yDeviation
        let leftContr2X = UIScreen.main.bounds.width / 3
        
        let rightContr2Y = leftContr2Y
        let rightContr2X = UIScreen.main.bounds.width - leftContr2X
        
        let rightContr1Y = leftContr1Y
        let rightContr1X = UIScreen.main.bounds.width - leftContr1X
        
        let movePoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: beginY + current.y - begin.y)
        
        slingShotView.leftContr1 = CGPoint(x: leftContr1X, y: leftContr1Y)
        slingShotView.leftContr2 = CGPoint(x: leftContr2X, y: leftContr2Y)
        slingShotView.rightContr2 = CGPoint(x: rightContr2X, y: rightContr2Y)
        slingShotView.rightContr1 = CGPoint(x: rightContr1X, y: rightContr1Y)
        slingShotView.movePoint = movePoint
        
        slingShotView.setNeedsDisplay()
    }
}

let beginY: CGFloat = 100
let yDeviation: CGFloat = 50

class SlingShotView: UIView {
    var leftContr1: CGPoint = CGPoint.zero
    var leftContr2: CGPoint = CGPoint.zero
    var rightContr2: CGPoint = CGPoint.zero
    var rightContr1: CGPoint = CGPoint.zero
    var movePoint: CGPoint?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.black.setStroke()
        
        let beginPoint: CGPoint = CGPoint(x: 0, y: beginY)
        let endPoint: CGPoint = CGPoint(x: UIScreen.main.bounds.width, y: beginY)
        
        let path = UIBezierPath.init()
        path.move(to: beginPoint)
        if let movePoint = movePoint {
            path.addCurve(to: movePoint, controlPoint1: leftContr1, controlPoint2: leftContr2)
            path.addCurve(to: endPoint, controlPoint1: rightContr2, controlPoint2: rightContr1)
        } else {
            path.addLine(to: endPoint)
        }
        path.lineWidth = 2
        
        path.stroke()
        
        let leftContrPath = UIBezierPath(rect: CGRect(origin: leftContr1, size: CGSize(width: 2, height: 2)))
        leftContrPath.stroke()
        
        let leftContrPath2 = UIBezierPath(rect: CGRect(origin: leftContr2, size: CGSize(width: 2, height: 2)))
        leftContrPath2.stroke()
    }
}
