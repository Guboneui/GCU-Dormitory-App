//
//  NickNameViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/02.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class NickNameViewController: UIViewController {
    
    @IBOutlet weak var nickNameBaseView: UIView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var checkNicknameButton: UIButton!
    @IBOutlet weak var goHomeButton: UIButton!
    
    var loading: NVActivityIndicatorView!

    override func loadView() {
        super.loadView()
        
        loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: UIColor.SBColor.SB_BaseYellow, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 60),
            loading.heightAnchor.constraint(equalToConstant: 60),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDesign()
    }

//MARK: - 기본 UI 함수 정리
    func configureDesign() {
        nickNameBaseView.layer.borderWidth = 1
        nickNameBaseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
        
        checkNicknameButton.layer.borderWidth = 1
        checkNicknameButton.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        
        goHomeButton.isEnabled = false
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
            loading.startAnimating()
            
            let sendNickname = nickNameTextField.text!
            postNicknameCheck(nickname: sendNickname)
            
        }
    }
    
    @IBAction func goHomeAction(_ sender: Any) {
        loading.startAnimating()
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        let nickname = nickNameTextField.text!
        postAddNickname(id: id, nickname: nickname)
        
    }
    
//MARK: - API 함수 정리
    
    func postNicknameCheck(nickname: String) {
        let URL = "http://13.209.10.30:3000/nicknameCheck"
        let PARAM: Parameters = [
            "nickname": nickname
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON { [self] (response) in
            //print(response.result)
            
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 닉네임 중복 체크 API 호출 성공")
                    loading.stopAnimating()
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    
                    if result == true {
                        print(">> nickname Check Success")
                        print(">> 사용 가능한 닉네임입니다.")
                        
                        let message = jsonObj.object(forKey: "message") as! String
                        
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: { _ in
                            goHomeButton.isEnabled = true
                            
                        })
                        
                        alert.addAction(cancelButton)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        let errorCode = jsonObj.object(forKey: "code") as! Int
                        let errorMessage = jsonObj.object(forKey: "message") as! String
                        
                        if errorCode == 301 {
                            let alert = UIAlertController(title: "\(errorMessage)", message: "", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                if let jsonObj = error as? NSDictionary {
                    print("서버통신 실패")
                    print(jsonObj)
                }
            }
        }
    }
    
    
    func postAddNickname(id: String, nickname: String) {
        let URL = "http://13.209.10.30:3000/nicknameSet"
        
        let PARAM: Parameters = [
            "id": id,
            "nickname": nickname
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON{ [self](response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 닉네임 추가 api 호출 성공")
                    loading.stopAnimating()
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        
                        let alert = UIAlertController(title: "시작하시겠어요?", message: "", preferredStyle: .alert)
                        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: {_ in
                            
                            UserDefaults.standard.set(true, forKey: "userNicknameExist")
                            
                            let nickname = self.nickNameTextField.text!
                            UserDefaults.standard.setValue(nickname, forKey: "userNickname")
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                            let homeVC = storyBoard.instantiateViewController(identifier: "MainVC")
                            
                            homeVC.modalPresentationStyle = .fullScreen
                            self.present(homeVC, animated: true, completion: nil)
                            
                        })
                        alert.addAction(cancelButton)
                        alert.addAction(okButton)
                        
                        self.present(alert, animated: true, completion: nil)
                        
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
                            
                        } else if errorCode as! Int == 304{
                            print("304 ERROR 닉네임 설정")
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
                    print(jsonObj)
                }
            }
        }
    }
    
    
}
