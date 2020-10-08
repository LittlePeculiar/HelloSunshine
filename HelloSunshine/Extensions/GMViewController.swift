//
//  GMViewController.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import UIKit

extension UIViewController {
    func embed(viewController VC:UIViewController, inView view:UIView) {
        VC.willMove(toParent: self)
        VC.view.frame = view.bounds
        VC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(VC.view)
        self.addChild(VC)
        VC.didMove(toParent: self)
    }
}
