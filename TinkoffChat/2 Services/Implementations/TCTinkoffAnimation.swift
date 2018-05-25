//
//  TinkoffAnimation.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 24.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

class TCTinkoffAnimation {
    
    private var view: UIView!
    
    private func getTinkoff(in location: CGPoint) -> UIView {
        let tinkoff = UIImageView(image: #imageLiteral(resourceName: "tinkoff"))
        tinkoff.contentMode = .scaleAspectFit
        tinkoff.frame.size = CGSize(width: 64, height: 64)
        tinkoff.center = location
        return tinkoff
    }
    
    public func setView(view: UIView) {
        self.view = view
        view.isUserInteractionEnabled = true
        let circe = UIImageView(image: #imageLiteral(resourceName: "tinkoff"))
        circe.contentMode = .scaleAspectFit
        circe.frame = CGRect(x: 16, y: view.frame.height*0.7, width: 80, height: 80)
        circe.alpha = 0.5
        circe.layer.cornerRadius = 40
        circe.isUserInteractionEnabled = true
        view.addSubview(circe)
    }
    private var tinkoffs: [(UIView, Bool)] = []
    private var tinkoffsToDelete: [(UIView, Bool)] = []
    public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let tinkoff = getTinkoff(in: touch.location(in: view))
            UIView.animate(withDuration: 0.1){
                tinkoff.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            self.view.addSubview(tinkoff)
            tinkoffs.append((tinkoff, true))
        }
    }
    private func transformOthers(){
        for i in 0..<tinkoffs.count {
            if tinkoffs[i].1 == true {
                tinkoffs[i].1 = false
                UIView.animate(withDuration: 0.5){
                    self.tinkoffs[i].0.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
            }
        }
    }
    public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        transformOthers()
        if let touch = touches.first {
            let tinkoff = getTinkoff(in: touch.location(in: view))
            tinkoff.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.addSubview(tinkoff)
            tinkoffs.append((tinkoff, true))
        }
    }
    
    public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        transformOthers()
        tinkoffsToDelete = tinkoffs
        tinkoffs = []
        for i in 0..<tinkoffsToDelete.count {
            UIView.animate(withDuration: 0.2, delay: Double(i)*0.01, options: .curveLinear, animations: {
                if i < self.tinkoffsToDelete.count {
                    self.tinkoffsToDelete[i].0.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.tinkoffsToDelete[i].0.alpha = 0
                }
            }){
                (completed) in
                if i < self.tinkoffsToDelete.count {
                    self.tinkoffsToDelete[i].0.removeFromSuperview()
                }
            }
            
        }
    }
}
