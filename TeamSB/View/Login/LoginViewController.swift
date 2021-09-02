//  LoginViewController.swift
//  TeamSB
//  Created by 구본의 on 2021/07/02.

import UIKit
import Alamofire
import NVActivityIndicatorView
import IQKeyboardManager
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var loginBaseView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var autoLoginButton: UIButton!
    @IBOutlet weak var idTextView: UITextField!
    @IBOutlet weak var pwTextView: UITextField!
    
    var loading: NVActivityIndicatorView!
    
    var application: UIApplication!
    var autoLoginState: Bool = false
    lazy var dataManager: LoginDataManager = LoginDataManager(view: self)
    //lazy var viewModel: LoginViewModel = LoginViewModel()

    override func loadView() {
        super.loadView()
        idTextView.delegate = self
        pwTextView.delegate = self
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesign()
        setAutoLoginImage()
        askNotification()
        //viewModelMethod()
    }
}

//MARK: -기본 UI 함수 정리
extension LoginViewController {
    func askNotification() {
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { didAllow, Error in
                print(didAllow)
                UserDefaults.standard.set(didAllow, forKey: "alertAccess")
            }

          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /// 앱이 foreground  상태일 때 Push 받으면 alert를 띄워준다
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
      }
    
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
        idTextView.returnKeyType = .next
        pwTextView.returnKeyType = .done
        
        loginBaseView.layer.cornerRadius = 5
        loginBaseView.layer.borderWidth = 1
        loginBaseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        
        
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
        //loading.startAnimating()
        CustomLoader.instance.showLoader()
        let param = LoginRequest(userId: id, password: pw)
        dataManager.postLogin(param, viewController: self)
        //viewModel.delegate = self
        //viewModel.postLogin(param)
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

//extension LoginViewController {
//    func viewModelMethod() {
//        viewModel.goNicknameView = { [self] in
//            let nicknameVC = storyboard?.instantiateViewController(withIdentifier: "NickNameViewController") as! NickNameViewController
//            navigationController?.pushViewController(nicknameVC, animated: true)
//        }
//
//        viewModel.goMainView = { [self] in
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//            let homeVC = storyBoard.instantiateViewController(identifier: "MainVC")
//
//            homeVC.modalPresentationStyle = .fullScreen
//            self.present(homeVC, animated: true, completion: nil)
//        }
//
//        viewModel.checkAutoLogin = { [self] in
//            if self.autoLoginState == true {
//                print(">> 자동로그인 활성화")
//                UserDefaults.standard.set(autoLoginState, forKey: "autoLoginState")
//
//            } else {
//                print(">> 자동로그인 비활성화")
//                UserDefaults.standard.set(autoLoginState, forKey: "autoLoginState")
//            }
//        }
//
//        viewModel.addUserInfo = { [self] nicknameExist in
//            let userID = idTextView.text!
//            UserDefaults.standard.set(userID, forKey: "userID")
//            UserDefaults.standard.set(nicknameExist, forKey: "userNicknameExist")
//        }
//
//        viewModel.showAlert = { [self] message in
//            presentAlert(title: message)
//        }
//
//        viewModel.stopLoading = {
//            CustomLoader.instance.hideLoader()
//        }
//    }
//}

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
        //self.loading.stopAnimating()
        CustomLoader.instance.hideLoader()
    }
    
}





extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == idTextView {
      pwTextView.becomeFirstResponder()
    } else {
      pwTextView.resignFirstResponder()
    }
    return true
  }
}

