//
//  UIViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/29.
//

import UIKit
import SnapKit
import Foundation

extension UIViewController {
    
    // MARK: 취소와 확인이 뜨는 UIAlertController
    func presentAlert(title: String, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionDone = UIAlertAction(title: "확인", style: .default, handler: handler)
        actionDone.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(actionDone)
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: 커스텀 UIAction이 뜨는 UIAlertController
    func presentAlert(title: String, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      with actions: UIAlertAction ...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UIWindow의 rootViewController를 변경하여 화면전환
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    // MARK: 커스텀 하단 경고창
    func presentBottomAlert(message: String, target: ConstraintRelatableTarget? = nil, offset: Double? = -12) {
        let alertSuperview = UIView()
        alertSuperview.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        alertSuperview.layer.cornerRadius = 10
        alertSuperview.isHidden = true
    
        let alertLabel = UILabel()
        //alertLabel.font = UIFont(name: .system, size: <#T##CGFloat#>)
        alertLabel.textColor = .white
        
        self.view.addSubview(alertSuperview)
        alertSuperview.snp.makeConstraints { make in
            make.bottom.equalTo(target ?? self.view.safeAreaLayoutGuide).offset(-12)
            make.centerX.equalToSuperview()
        }
        
        alertSuperview.addSubview(alertLabel)
        alertLabel.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
        }
        
        alertLabel.text = message
        alertSuperview.alpha = 1.0
        alertSuperview.isHidden = false
        UIView.animate(
            withDuration: 2.0,
            delay: 1.0,
            options: .curveEaseIn,
            animations: { alertSuperview.alpha = 0 },
            completion: { _ in
                alertSuperview.removeFromSuperview()
            }
        )
    }
}
