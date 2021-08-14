//
//  ChangeNicknameViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/07.
//

import UIKit

protocol ChangeNickNameDelegate: AnyObject {
    func changeNicknameLabel(text: String?)
}

class ChangeNicknameViewController: UIViewController{
    
    

    
    lazy var dataManager: SettingDataManager = SettingDataManager(view: self)
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var configButton: UIButton!
    
    weak var delegate: ChangeNickNameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDesign()
        
    }
    
    

   
}

//MARK: -기본 UI 함수
extension ChangeNicknameViewController {
    func configDesign() {
        cancelButton.layer.cornerRadius = 8
        configButton.layer.cornerRadius = 8
    }
}

//MARK: -스토리보드 액션 함수 정리
extension ChangeNicknameViewController {
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func configButtonAction(_ sender: Any) {
        let id = UserDefaults.standard.string(forKey: "userID")!
        let nickname = nicknameTextField.text!
        let param = ChangeUserNicknameRequest(curId: id, nickname: nickname)
        dataManager.postChangeNickname(param, viewController: self)
    }
    
}


extension ChangeNicknameViewController: SettingView {
    func dismissProfileView() {
        
    }
    
    func successChangeNickname() {
        let alert = UIAlertController(title: "닉네임 변경 성공", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: { [self] _ in
            self.dismiss(animated: true, completion: nil)
            delegate?.changeNicknameLabel(text: nicknameTextField.text)
            
        })
        okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func settingNickname(nickname: String) {
        print(">>")
    }
}
