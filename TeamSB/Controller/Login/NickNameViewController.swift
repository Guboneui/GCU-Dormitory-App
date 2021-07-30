//  NickNameViewController.swift
//  TeamSB
//  Created by 구본의 on 2021/07/02.

import UIKit
import Alamofire
import NVActivityIndicatorView

class NickNameViewController: UIViewController {
    
    @IBOutlet weak var nickNameBaseView: UIView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var checkNicknameButton: UIButton!
    @IBOutlet weak var goHomeButton: UIButton!
    
    var loading: NVActivityIndicatorView!
    lazy var dataManager: NicknameDataManager = NicknameDataManager(view: self)

    override func loadView() {
        super.loadView()
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesign()
    }
}

//MARK: - 기본 UI 함수 정리
extension NickNameViewController {
    
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
        nickNameBaseView.layer.borderWidth = 1
        nickNameBaseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
        
        checkNicknameButton.layer.borderWidth = 1
        checkNicknameButton.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        
        goHomeButton.isEnabled = false
    }
}

//MARK: -스토리보드 Action 함수
extension NickNameViewController {
    @IBAction func checkNicknameAction(_ sender: Any) {
        if nickNameTextField.text == "" {
            self.presentAlert(title: "닉네임을 입력하세요")
            
        } else if nickNameTextField.text!.count < 2 {
            self.presentAlert(title: "닉네임은 2글자 이상이어야합니다.")
            
        } else if nickNameTextField.text!.count > 8 {
            self.presentAlert(title: "닉네임은 8자 이하이어야합니다.")
            
        } else {
            loading.startAnimating()
            
            let nickname = nickNameTextField.text!
            let param = NicknameCheckRequest(nickname: nickname)
            dataManager.postNicknameCheck(param, viewController: self)
        }
    }
    
    @IBAction func goHomeAction(_ sender: Any) {
        loading.startAnimating()
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        let nickname = nickNameTextField.text!
        
        let param = NicknameSetRequest(curId: id, nickname: nickname)
        dataManager.postNicknameSet(param, viewController: self)
    }
    
}

//MARK: -DataManager 함수
extension NickNameViewController: NicknameView {
    
    func showAlert(message: String) {
        self.presentAlert(title: message)
    }
    
    func stopLoading() {
        self.loading.stopAnimating()
    }
    
    ///메인 화면으로 RootView변경
    func setMainView() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = storyBoard.instantiateViewController(identifier: "MainVC")
        
        self.changeRootViewController(homeVC)
    }
    
    ///유저 닉네임 및 닉네임 존재 여부 디바이스 저장
    func setUserNickname() {
        let nickname = nickNameTextField.text!
        UserDefaults.standard.setValue(nickname, forKey: "userNickname")
        UserDefaults.standard.set(true, forKey: "userNicknameExist")
    }
    
    func useButton() {
        goHomeButton.isEnabled = true
    }
    
    func showAlertDismissKeyboard(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {_ in
            self.view.endEditing(true)
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
