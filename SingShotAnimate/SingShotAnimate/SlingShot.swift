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
        slingShotView.updatePath(leftContr: beginLeftContr, rightContr: beginRightContr)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            beginPoint = gesture.location(in: view)
        case .changed:
            let currentPoint = gesture.location(in: view)
            if let begin = beginPoint {
                changeLine(begin: begin, current: currentPoint)
            }
        case .ended:
            slingShotView.updatePath(leftContr: beginLeftContr, rightContr: beginRightContr)
        default:
            ()
        }
    }
    
    func changeLine(begin: CGPoint, current: CGPoint) {
        let leftContrY = (current.y - begin.y) / 2 + beginY + yContrDevi(diffY: (current.y - begin.y))
        let leftContrX = UIScreen.main.bounds.width / 3
        
        let rightContrY = leftContrY
        let rightContrX = UIScreen.main.bounds.width - leftContrX
        
        slingShotView.updatePath(leftContr: CGPoint(x: leftContrX, y: leftContrY), rightContr: CGPoint(x: rightContrX, y: rightContrY))
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
    
    func updatePath(leftContr: CGPoint, rightContr: CGPoint) {
        shapeLayer.path = getPath(leftContr: leftContr, rightContr: rightContr)
    }
    
    private func getPath(leftContr: CGPoint, rightContr: CGPoint) -> CGPath {
        let beginPoint: CGPoint = CGPoint(x: 0, y: beginY)
        let endPoint: CGPoint = CGPoint(x: UIScreen.main.bounds.width, y: beginY)

        let path = UIBezierPath.init()
        path.move(to: beginPoint)
        path.addCurve(to: endPoint, controlPoint1: leftContr, controlPoint2: rightContr)
        path.lineWidth = 2
        return path.cgPath
    }
}
