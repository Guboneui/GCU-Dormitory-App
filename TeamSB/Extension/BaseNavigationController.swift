//
//  BaseNavigationController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/26.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    private var duringTransition = false
    private var disabledPopVCs = [WriteViewController.self, EditViewController.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringTransition = true
        
        super.pushViewController(viewController, animated: animated)
    }
    
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.duringTransition = false
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer,
              let topVC = topViewController else {
            return true // default value
        }
        
        return viewControllers.count > 1 && duringTransition == false && isPopGestureEnable(topVC)
    }
    
    private func isPopGestureEnable(_ topVC: UIViewController) -> Bool {
        for vc in disabledPopVCs {
            if String(describing: type(of: topVC)) == String(describing: vc) {
                return false
            }
        }
        return true
    }
}
