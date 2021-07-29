//  LoginViewController.swift
//  TeamSB
//  Created by 구본의 on 2021/07/02.

import UIKit
import Alamofire
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idBaseView: UIView!
    @IBOutlet weak var pwBaseView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var autoLoginButton: UIButton!
    @IBOutlet weak var idTextView: UITextField!
    @IBOutlet weak var pwTextView: UITextField!
    
    var loading: NVActivityIndicatorView!
    var autoLoginState: Bool = false
    lazy var dataManager: LoginDataManager = LoginDataManager(view: self)

    override func loadView() {
        super.loadView()
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesign()
        setAutoLoginImage()
    }
}

//MARK: -기본 UI 함수 정리
extension LoginViewController {
    func setLoading() {
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
}

//MARK: -스토리보드 Action 함수 정리
extension LoginViewController {
    @IBAction func loginAction(_ sender: Any) {
        guard let id = idTextView.text?.trim, id.isExists else {
            self.presentAlert(title: "아이디를 입력 해주세요.")
            return
        }
        guard let pw = pwTextView.text?.trim, pw.isExists else {
            self.presentAlert(title: "비밀번호를 입력 해주세요.")
            return
        }
        loading.startAnimating()
        let param = LoginRequest(userId: id, password: pw)
        dataManager.postLogin(param, viewController: self)
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

//MARK: -DataManager 함수
extension LoginViewController: LoginView {
    
    ///닉네임이 존재하지 않은 경우 닉네임 화면으로 이동
    func goNicknameView() {
        let nicknameVC = storyboard?.instantiateViewController(withIdentifier: "NickNameViewController") as! NickNameViewController
        navigationController?.pushViewController(nicknameVC, animated: true)
    }
    
    ///닉네임이 이미 존재하는 사용자의 경우 홈화면으로 이동
    func goMainView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = storyBoard.instantiateViewController(identifier: "MainVC")
        
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true, completion: nil)
    }
    
    ///자동 로그인 여부 저장
    func checkAutoLogin() {
        if self.autoLoginState == true {
            print(">> 자동로그인 활성화")
            UserDefaults.standard.set(autoLoginState, forKey: "autoLoginState")
            
        } else {
            print(">> 자동로그인 비활성화")
            UserDefaults.standard.set(autoLoginState, forKey: "autoLoginState")
        }
    }
    
    ///로그인 시 유저 아이디 및 닉네임 존재 여부 확인
    func addUserInfo(nicknameExist: Bool) {
        let userID = idTextView.text!
        UserDefaults.standard.set(userID, forKey: "userID")
        UserDefaults.standard.set(nicknameExist, forKey: "userNicknameExist")
    }
    
    ///서버 통신 에러 메세지 알림
    func showAlert(message: String) {
        self.presentAlert(title: message)
    }
    
    ///서버 연결 성공 시 로딩 바 동작 멈추기
    func stopLoading() {
        self.loading.stopAnimating()
    }
    
}
