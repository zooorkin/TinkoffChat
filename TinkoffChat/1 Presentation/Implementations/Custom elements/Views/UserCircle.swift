//
//  UserCircle.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable class UserCircle: UIView {

    
    var view: UIView!

    @IBOutlet var profileImageView: RoundImage!
    @IBOutlet var whiteCircleView: CircleView!
    @IBOutlet var onlineCircleView: CircleView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserCircle", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setOnline(){
        self.profileImageView.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        self.onlineCircleView.backgroundColor = DesignConstants.pink
        self.whiteCircleView.backgroundColor = UIColor.white
    }
    
    func setOffline(){
        self.profileImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.onlineCircleView.backgroundColor = UIColor.clear
        self.whiteCircleView.backgroundColor = UIColor.clear
    }

}
