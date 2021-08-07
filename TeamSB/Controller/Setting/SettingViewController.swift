//
//  SettingViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

//Setting 화면 Todo
//1. 프로필(닉네임, 자신이 쓴 글 개수, 닉네임 수정, ...)
//2. 기본 설정 로그아웃 -> 구현 완료
//3. 게시글 수정 -> 별도 화면 필요(자신이 쓴 게시글 목록 보여주고, 게시글 수정할 수 있도록 구성 필요)
//4. 설정 메인 창 필요(이미지, ... 드롭다운 필요할 수도)

class SettingViewController: UIViewController {
    
    var backButton: UIBarButtonItem!
    
    @IBOutlet weak var profileBaseView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var firstBaseView: UIView!
    @IBOutlet weak var secondBaseView: UIView!
    @IBOutlet weak var thirdBaseView: UIView!
    @IBOutlet weak var fourthBaseView: UIView!
    @IBOutlet weak var fifthBaseView: UIView!
    @IBOutlet weak var sixthBaseView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var getNickname = ""
    let picker = UIImagePickerController()
    

    lazy var dataManager: SettingDataManager = SettingDataManager(view: self)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileImage()
        configDesign()
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "설정"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        getUserInfo()
    }
    
    func getProfileImage() {
        let imageString = UserDefaults.standard.string(forKey: "userProfileImage")!
        let userProfileImage = imageString.toImage()
        profileImage.image = userProfileImage
    }
    
    func getUserInfo() {
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = GetUserInfoRequest(id: id)
        dataManager.postSearch(param, viewController: self)
        
    }
    
    func configDesign() {
        
        backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        
        profileBaseView.layer.cornerRadius = 10
        profileBaseView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        profileBaseView.layer.borderWidth = 1
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        
        nicknameLabel.text = getNickname
        
        logOutButton.layer.cornerRadius = 10
        
        changeProfileButton.layer.cornerRadius = 8
        changeProfileButton.layer.borderWidth = 1
        changeProfileButton.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        
        firstBaseView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        firstBaseView.layer.borderWidth = 1
        
        secondBaseView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        secondBaseView.layer.borderWidth = 1
        
        thirdBaseView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        thirdBaseView.layer.borderWidth = 1
        
        fourthBaseView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        fourthBaseView.layer.borderWidth = 1
        
        fifthBaseView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        fifthBaseView.layer.borderWidth = 1
        
        sixthBaseView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        sixthBaseView.layer.borderWidth = 1
        
    }
    
    
    @IBAction func changeProfile(_ sender: Any) {
        print(">> 프로필 변경 버튼이 눌렸습니다")
        let alert = UIAlertController(title: "프로필 변경", message: "무엇을 변경하시겠어요?", preferredStyle: .actionSheet)
        let profileImageChange = UIAlertAction(title: "프로필 사진 변경", style: .default, handler: {_ in
           
            self.picker.sourceType = .photoLibrary // 방식 선택. 앨범에서 가져오는걸로 선택.
            self.picker.allowsEditing = true // 수정가능하게 할지 선택. 하지만 false
            self.picker.delegate = self
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true)
            
           
            
        })
        
        let profileNicknameChange = UIAlertAction(title: "닉네임 변경", style: .default, handler: { [self] _ in
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ChangeNicknameViewController") as! ChangeNicknameViewController
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            
            
            
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(profileImageChange)
        alert.addAction(profileNicknameChange)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    
}

//MARK: -스토리보드 액션 함수
extension SettingViewController {
    @IBAction func logOutAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "로그아웃 하시겠어요?", message: "", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {_ in
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(identifier: "LoginNavigationVC")
            
            UserDefaults.standard.set(nil, forKey: "userID")
            UserDefaults.standard.set(nil, forKey: "userNicknameExist")
            UserDefaults.standard.set(nil, forKey: "userNickname")
            UserDefaults.standard.set(false, forKey: "autoLoginState")
            
            self.changeRootViewController(loginVC)
            
        })
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingViewController: SettingView {
    func successChangeNickname() {
        
    }
    
    func settingNickname(nickname: String) {
        nicknameLabel.text = nickname
    }
    
    
}


extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        print(">> 바뀐 프로필 이미지 \(String(describing: newImage))")
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        let changeImageString = newImage?.toPngString()
        
        UserDefaults.standard.set(changeImageString, forKey: "userProfileImage")
        
        let param = ChangeProfileImageRequest(curId: id, profile_image: changeImageString!)
        dataManager.postChangeProfileImage(param, viewController: self)
        self.profileImage.image = newImage // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        
    }
}

extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}



extension SettingViewController: ChangeNickNameDelegate {
    func changeNicknameLabel(text: String?) {
        self.nicknameLabel.text = text!
    }
    
    
}
