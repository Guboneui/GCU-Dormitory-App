//
//  NickNameViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/02.
//

import UIKit
import Alamofire

class NickNameViewController: UIViewController {
    
    

    @IBOutlet weak var nickNameBaseView: UIView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var checkNicknameButton: UIButton!
    @IBOutlet weak var goHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesign()
        
        resignForKeyboardNotification()
        //다른 공간 클릭 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    func configureDesign() {
        
        nickNameBaseView.layer.borderWidth = 1
        nickNameBaseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
        
        checkNicknameButton.layer.borderWidth = 1
        checkNicknameButton.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
    }
    
    

    
    @IBAction func checkNicknameAction(_ sender: Any) {
        
        
        
        
        if nickNameTextField.text == "" {
            let alert = UIAlertController(title: "닉네입을 입력하세요", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else if nickNameTextField.text!.count < 2 {
            let alert = UIAlertController(title: "닉네임은 2글자 이상", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else if nickNameTextField.text!.count > 8 {
            let alert = UIAlertController(title: "닉네임은 8자 이하", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            //Todo: 닉네임 중복 여부를 판단해서 값을 저장해야함
        }
        
        
    }
    
    
    
    @IBAction func goHomeAction(_ sender: Any) {
        
        
        let URL = "http://13.209.10.30:3000/join"
        
        let PARAM: Parameters = [
            "id": UserDefaults.standard.string(forKey: "userID")!,
            "nickname": nickNameTextField.text!
        ]
        
        print(PARAM)
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON{(response) in
            print(response)
            print(response.result)
            
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print("성공시")
                    print(">> \(URL)")
                    
                    print(jsonObj)
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        
                        let userNickName = jsonObj.object(forKey: "nickname")
                        UserDefaults.standard.set(userNickName, forKey: "userNickName")
                        
                        
                        
                        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "HomeNavigationVC")
                
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        let errorCode = jsonObj.object(forKey: "code")
                        let errorMessage = jsonObj.object(forKey: "message")
                        
                        if errorCode as! Int == 301 {
                            print("301 ERROR 닉네임 설정")
                            print(errorMessage!)
                        } else if errorCode as! Int == 302 {
                            print("302 ERROR 닉네임 설정")
                            print(errorMessage!)
                            let alert = UIAlertController(title: "\(errorMessage!)", message: "", preferredStyle: .alert)
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
    
    

}
