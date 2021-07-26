//
//  LoginViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/02.
//

import UIKit
import Alamofire


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
        
        
        if idTextView.text == "" || idTextView.text == nil {
            let alert = UIAlertController(title: "ID를 입력 해주세요", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        } else if pwTextView.text == "" || pwTextView.text == nil {
            let alert = UIAlertController(title: "PW를 입력 해주세요", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            print(">> 로그인 액션")
            let inputID: String = idTextView.text ?? ""
            let inputPW: String = pwTextView.text ?? ""
            
            print("사용자 입력 아이디: \(inputID)")
            print("사용자 입력 비번: \(inputPW)")
            
            let URL = "http://13.209.10.30:3000/login"
            
            let PARAM: Parameters = [
                "id": inputID,
                "password": inputPW
            ]
            
        
            
            let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
            
            alamo.responseJSON{ [self] (response) in
                //print(response)
                //print(response.result)
                
                switch response.result {
                case .success(let value):
                    if let jsonObj = value as? NSDictionary {
                        print(">>로그인 API 성공")
                        print(">> \(URL)")
                        
                        let result = jsonObj.object(forKey: "check") as! Bool
                        
                        if result == true {
                            if self.autoLoginState == true {
                                print(">> 오토로그인 o")
                                UserDefaults.standard.set(autoLoginState, forKey: "autoLoginState")
                                
                            } else {
                                print(">> 오토로그인 x")
                                UserDefaults.standard.set(autoLoginState, forKey: "autoLoginState")
                            }
                            
                            let existNickname = jsonObj.object(forKey: "nickname") as! Bool
                            
                            if existNickname == false {
                                let nicknameVC = storyboard?.instantiateViewController(withIdentifier: "NickNameViewController") as! NickNameViewController
                                navigationController?.pushViewController(nicknameVC, animated: true)
                            } else {
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                let homeVC = storyBoard.instantiateViewController(identifier: "MainVC")
                        
                                homeVC.modalPresentationStyle = .fullScreen
                                self.present(homeVC, animated: true, completion: nil)
                            }
                            
                            
                            UserDefaults.standard.set(jsonObj.object(forKey: "id") as! String, forKey: "userID")
                            UserDefaults.standard.set(jsonObj.object(forKey: "nickname"), forKey: "userNicknameExist")
                            

                            
                            
                            
                        } else {
                            let code = jsonObj.object(forKey: "code") as! Int
                            
                            if code == 301 {
                                let errorMessage = jsonObj.object(forKey: "message") as! String
                                let alert = UIAlertController(title: errorMessage, message: "", preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert, animated: true, completion: nil)
                            } else if code == 302 {
                                let errorMessage = jsonObj.object(forKey: "message") as! String
                                let alert = UIAlertController(title: errorMessage, message: "", preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert, animated: true, completion: nil)
                            } else if code == 303 {
                                let errorMessage = jsonObj.object(forKey: "message") as! String
                                let alert = UIAlertController(title: errorMessage, message: "", preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: "확인되지 않은 에러", message: "", preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        
                        
                        
                        
                    }
                case .failure(let error) :
                    if let jsonObj = error as? NSDictionary {
                        print("서버통신 실패")
                        print(error)
                    }
                }
                
        }
        
        
        
        
        
        
        
            
            
            
        }
        
        
        
    }
    
    
    
    @IBAction func autoLoginAction(_ sender: Any) {
        
        if autoLoginState == false {
            let checked = UIImage(systemName: "checkmark.square.fill")
            autoLoginButton.setImage(checked, for: .normal)
            autoLoginState = true
        } else {
            let unchecked = UIImage(systemName: "square")
            autoLoginButton.setImage(unchecked, for: .normal)
            autoLoginState = false
        }
    }
    
   
}
