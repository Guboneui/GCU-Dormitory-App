//
//  LoginViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/02.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    var autoLoginState: Bool = false

    @IBOutlet weak var idBaseView: UIView!
    @IBOutlet weak var pwBaseView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var autoLoginButton: UIButton!
    @IBOutlet weak var idTextView: UITextField!
    @IBOutlet weak var pwTextView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(self.idBaseView.frame.origin.y)
        print(self.pwBaseView.frame.origin.y)
        print(view.frame.origin.y)
        
        
        
        configureDesign()
        setAutoLoginImage()
        
        resignForKeyboardNotification()
        //다른 공간 클릭 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    
    func configureDesign() {
        
        idBaseView.layer.borderWidth = 1
        idBaseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
        
        pwBaseView.layer.borderWidth = 1
        pwBaseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        
    }
    
    
    func setAutoLoginImage() {
        if UserDefaults.standard.bool(forKey: "autoLoginState") == false {
            let unchecked = UIImage(systemName: "square")
            autoLoginButton.setImage(unchecked, for: .normal)
        
        } else {
            let checked = UIImage(systemName: "checkmark.square.fill")
            autoLoginButton.setImage(checked, for: .normal)
            
        }
        
    }
    
    
    @objc func dismissKeyboard() {  //키보드 숨김처리
        view.endEditing(true)
    }
    
    func resignForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = 0
        let bottom = view.frame.origin.y
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardReactangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardReactangle.height
            self.view.frame.origin.y = bottom - keyboardHeight / 2 + 50
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    
    
    @IBAction func loginAction(_ sender: Any) {
        if idTextView.text == "starku2249" && pwTextView.text == "ku@@2249" {
            print("로그인 성공")
            print(autoLoginState)
            
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "NickNameViewController") as! NickNameViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if idTextView.text == "" {
            let alert = UIAlertController(title: "ID를 입력 해주세요.", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else if pwTextView.text == "" {
            let alert = UIAlertController(title: "PW를 입력 해주세요.", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "ID가 존재하지 않습니다.", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func autoLoginAction(_ sender: Any) {
        
        if autoLoginState == false {
            let checked = UIImage(systemName: "checkmark.square.fill")
            autoLoginButton.setImage(checked, for: .normal)
            autoLoginState = true
            UserDefaults.standard.set(autoLoginState, forKey: "autoLoginState")
        } else {
            let unchecked = UIImage(systemName: "square")
            autoLoginButton.setImage(unchecked, for: .normal)
            autoLoginState = false
            UserDefaults.standard.set(autoLoginState, forKey: "autoLoginState")
        }
    }
    
   
}
