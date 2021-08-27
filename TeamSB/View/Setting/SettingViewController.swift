//
//  SettingViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire
import Firebase
import FirebaseCore
import FirebaseMessaging
import SafariServices


class SettingViewController: UIViewController, UISceneDelegate {
    
    var backButton: UIBarButtonItem!
    
    @IBOutlet weak var fcmSwitch: UISwitch!
    @IBOutlet weak var profileBaseView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstBaseView: UIView!
    @IBOutlet weak var secondBaseView: UIView!
    @IBOutlet weak var thirdBaseView: UIView!
    @IBOutlet weak var fourthBaseView: UIView!
    @IBOutlet weak var fifthBaseView: UIView!
    @IBOutlet weak var sixthBaseView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var photoPencilBaseView: UIView!
    @IBOutlet weak var photoPencilImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var topGuideLineView: UIView!
    @IBOutlet weak var logoutBaseView: UIView!
    
    
    var getNickname = ""
    let picker = UIImagePickerController()
    
    var isON = UserDefaults.standard.bool(forKey: "alertAccess")

    lazy var dataManager: SettingDataManager = SettingDataManager(view: self)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configDesign()
        //checkNotificationState()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
       
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
   
        checkNotificationState()

    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }

   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "설정"
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        getUserInfo()
        getProfileImage()
        
        print("설정화면에 접속 했을 때 알림 권한 상태입니다.\(UserDefaults.standard.bool(forKey: "alertAccess"))")
        print("true라면 스위치가 켜져 있어야 하며, false라면 스위치가 꺼져 있어야 합니다.")
        
        fcmSwitch.isOn = UserDefaults.standard.bool(forKey: "alertAccess")
        let isRegistered = UIApplication.shared.isRegisteredForRemoteNotifications

    }
    
    
    func checkNotificationState() {
        print("설정화면으로 이동했다가 다시 돌아온 상태입니다.")
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [self] settings in
            
            DispatchQueue.main.async {
                if settings.alertSetting == .enabled {
                    print("설정 에서 알림을 활성화 하였습니다.")
                    UserDefaults.standard.set(true, forKey: "alertAccess")
                    fcmSwitch.isOn = true
                    UIApplication.shared.registerForRemoteNotifications()

                    
                } else {
                    print("설정에서 알림을 활성화 하지 않았거나, 비활성화로 바꾼 상태입니다.")
                    UserDefaults.standard.set(false, forKey: "alertAccess")
                    fcmSwitch.isOn = false
                }
            }

        }

    }
   
    
    func getProfileImage() {
        
        if UserDefaults.standard.string(forKey: "userProfileImage")  == "" || UserDefaults.standard.string(forKey: "userProfileImage") == nil {
            profileImage.image = UIImage(named: "default_profileImage")
        } else {
            let imageString = UserDefaults.standard.string(forKey: "userProfileImage") ?? ""
            let userProfileImage = imageString.toImage()
            profileImage.image = userProfileImage
        }
    }
    
    func getUserInfo() {
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = GetUserInfoRequest(id: id)
        dataManager.postSearch(param, viewController: self)
        
    }
    
    func configDesign() {
        
        fcmSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        topGuideLineView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topGuideLineView.layer.shadowOpacity = 0.15
        
        
        emailLabel.text = UserDefaults.standard.string(forKey: "userID")! + "@gachon.ac.kr"
        
        backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        
        photoPencilBaseView.layer.cornerRadius = photoPencilBaseView.frame.height / 2
        photoPencilBaseView.layer.borderWidth = 2.5
        photoPencilBaseView.layer.borderColor = UIColor.white.cgColor
        
       // photoPencilImage.layer.cornerRadius = photoPencilImage.frame.height / 2
       
        profileBaseView.layer.cornerRadius = 10
        profileBaseView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        profileBaseView.layer.borderWidth = 1
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderWidth = 0.3
        profileImage.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        
        nicknameLabel.text = getNickname
    
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        
        firstBaseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        firstBaseView.layer.borderWidth = 1
        firstBaseView.layer.cornerRadius = 3
        
        secondBaseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        secondBaseView.layer.borderWidth = 1
        secondBaseView.layer.cornerRadius = 3
        
        thirdBaseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        thirdBaseView.layer.borderWidth = 1
        thirdBaseView.layer.cornerRadius = 3
        
        fourthBaseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        fourthBaseView.layer.borderWidth = 1
        fourthBaseView.layer.cornerRadius = 3
        
        fifthBaseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        fifthBaseView.layer.borderWidth = 1
        fifthBaseView.layer.cornerRadius = 3
        
        sixthBaseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        sixthBaseView.layer.borderWidth = 1
        sixthBaseView.layer.cornerRadius = 3
        
        logoutBaseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        logoutBaseView.layer.borderWidth = 1
        logoutBaseView.layer.cornerRadius = 3
        
        
        
    }
    
    
    @IBAction func changeNicknameButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChangeNicknameViewController") as! ChangeNicknameViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func changeProfileImageButtonAction(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "프로필", message: "프로필 수정", preferredStyle: .actionSheet)
        let deleteButton = UIAlertAction(title: "프로필 삭제", style: .default, handler: {[self] _ in
            let id = UserDefaults.standard.string(forKey: "userID")!
            let param = DeleteUserProfileImageRequest(curId: id)
            dataManager.removeUserProfile(param, viewController: self)
        })
        let editButton = UIAlertAction(title: "프로필 변경", style: .default, handler: { [self] _ in
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewViewController") as! EditProfileViewViewController
            vc.mainDelegate = self
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        editButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        deleteButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        cancelButton.setValue(UIColor(displayP3Red: 255/255, green: 63/255, blue: 63/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(editButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func fcmSwitchAction(_ sender: UISwitch) {
        print("스위치가 눌렸습니다.")
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [self] settings in
            
            DispatchQueue.main.async {
                if settings.alertSetting == .enabled {
                    print("전체 알림 권한이 활성화되어있습니다.")
                    print("현재 알림 권한 상태입니다.\(UserDefaults.standard.bool(forKey: "alertAccess"))")
                    self.isON = !UserDefaults.standard.bool(forKey: "alertAccess")
                    UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "alertAccess"), forKey: "alertAccess")
                    print("스위치가 클릭된 이후 알림 권한 상태입니다.\(UserDefaults.standard.bool(forKey: "alertAccess"))")
            
                    if isON == false {
                        
                        print("설정값이 꺼짐 상태이기 때문에 알림을 거부합니다. 하지만 전체 알림 권한은 활성화 되어 있습니다.")
                        UIApplication.shared.unregisterForRemoteNotifications()
                    } else {
                        print("설정값이 켜짐 상태이기 때문에 알림을 허용합니다.")
                        UIApplication.shared.registerForRemoteNotifications()
                     
                    }
                            
                } else {
                    print("비활성화")
                    let alert = UIAlertController(title: "알림을 허용 해주세요", message: "권한을 허용해주셔야 댓글, 공지사항에 대한 알림을 받으실 수 있어요", preferredStyle: .alert)
                    let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    let okButton = UIAlertAction(title: "확인", style: .default, handler: { _ in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    })
                    okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
                    cancelButton.setValue(UIColor(displayP3Red: 255/255, green: 63/255, blue: 63/255, alpha: 1), forKey: "titleTextColor")
                    alert.addAction(cancelButton)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func appGuideButtonAction(_ sender: UIButton) {
        print(">> 튜토리얼과 같은 화면이 나옵니다.")
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let tutorialVC = storyBoard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        tutorialVC.getAppGuide = true
        tutorialVC.modalPresentationStyle = .fullScreen
        self.present(tutorialVC, animated: true, completion: nil)
    }
    
    @IBAction func appIntroButtonAction(_ sender: UIButton) {
        print(">> 앱 소개 화면 페이지로 로딩됩니다.")
        let appIntroUrl = URL(string: "https://summer-echidna-7ed.notion.site/8ddb4bc158204cca9c579712101650af")
        let appIntroSafariView: SFSafariViewController = SFSafariViewController(url: appIntroUrl! as URL)
        self.present(appIntroSafariView, animated: true, completion: nil)
    }
    
    @IBAction func appFeedbackButton(_ sender: Any) {
        print(">> 앱 피드백 화면으로 넘어갑니다.")
        let alert = UIAlertController(title: "의견 및 후기를 남겨주세요.", message: "", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[self] _ in
            guard let text = alert.textFields![0].text?.trim, text.isExists else {
                self.presentAlert(title: "의견 및 후기를 입력 해주세요.")
                return
            }
            
            let id = UserDefaults.standard.string(forKey: "userID")!
            let param = FeedbackReqeust(curUser: id, text: text)
            dataManager.postFeedback(param, viewController: self)
            
            print(alert.textFields![0].text!)
        })
        
        okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        cancelButton.setValue(UIColor(displayP3Red: 255/255, green: 63/255, blue: 63/255, alpha: 1), forKey: "titleTextColor")
        
        alert.addTextField { (feedbackTextField) in
            feedbackTextField.placeholder = "저희에게 큰 힘이 됩니다😍"
            feedbackTextField.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func userPrivateButtonAction(_ sender: UIButton) {
        print(">> 개인정보 처리방침 페이지로 이동합니다.")
        let userPrivateUrl = URL(string: "https://summer-echidna-7ed.notion.site/f9a75cbef96d4863bf2bfa9af64e0998")
        let userPrivateSafariView: SFSafariViewController = SFSafariViewController(url: userPrivateUrl! as URL)
        self.present(userPrivateSafariView, animated: true, completion: nil)
    }
    
    @IBAction func openSourceButtonAction(_ sender: UIButton) {
        print(">> 오픈 소스 화면이 로드 됩니다.")
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OpenSourceViewController") as! OpenSourceViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
}

//MARK: -스토리보드 액션 함수
extension SettingViewController {
    @IBAction func logOutAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "로그아웃 하시겠어요?", message: "", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: { [self]_ in
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(identifier: "LoginNavigationVC")
            
            let param = RemoveFcmTokenRequest(curUser: UserDefaults.standard.string(forKey: "userID")!)
            dataManager.removeFcmToken(param, viewController: self)
            UserDefaults.standard.set(nil, forKey: "userID")
            UserDefaults.standard.set(nil, forKey: "userNicknameExist")
            UserDefaults.standard.set(nil, forKey: "userNickname")
            UserDefaults.standard.set(false, forKey: "autoLoginState")
            
            self.changeRootViewController(loginVC)
            
        })
        
        
        okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        cancelButton.setValue(UIColor(displayP3Red: 255/255, green: 63/255, blue: 63/255, alpha: 1), forKey: "titleTextColor")
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingViewController: SettingView {
    func dismissProfileView() {
        
    }
    
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

        let id = UserDefaults.standard.string(forKey: "userID")!
        var editImage = newImage?.resize(newWidth: 200)
        let jpgImage = editImage?.jpegData(compressionQuality: 0.25)

        let jpgString = jpgImage?.base64EncodedString(options: .lineLength64Characters)
        
        UserDefaults.standard.set(jpgString, forKey: "userProfileImage")
        
        let param = ChangeProfileImageRequest(curId: id, profile_image: jpgString!)
        
        self.profileImage.image = UIImage(data: jpgImage!) // 받아온 이미지를 update
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

extension SettingViewController: ChangeProfileImage {
    func changeProfile(image: String) {
        let imageString = image
        let userProfileImage = imageString.toImage()
        profileImage.image = userProfileImage
    }
}


extension SettingViewController: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
        
        
    Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print("^^FCM registration token: \(token)")
        UserDefaults.standard.set(token, forKey: "FCMToken")
        //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
        }
        }
    }

}
