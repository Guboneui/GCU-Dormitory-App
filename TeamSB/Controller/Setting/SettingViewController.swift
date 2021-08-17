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

//Setting 화면 Todo
//1. 프로필(닉네임, 자신이 쓴 글 개수, 닉네임 수정, ...)
//2. 기본 설정 로그아웃 -> 구현 완료
//3. 게시글 수정 -> 별도 화면 필요(자신이 쓴 게시글 목록 보여주고, 게시글 수정할 수 있도록 구성 필요)
//4. 설정 메인 창 필요(이미지, ... 드롭다운 필요할 수도)

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
        checkNotificationState()
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        getUserInfo()
        getProfileImage()
        
        
        if UserDefaults.standard.bool(forKey: "alertAccess") == true {
            fcmSwitch.isOn = true
        } else {
            fcmSwitch.isOn = false
        }
        
     
        
        let isRegistered = UIApplication.shared.isRegisteredForRemoteNotifications
//        if(isRegistered) {
//            //
//            //_ = SweetAlert().showAlert("title_regist".localized, subTitle: "알림 수신이 설정되어 있습니다", style: AlertStyle.warning) return
//            print("알림이 활성화 되어있습니")
//        } else {
//           // _ = SweetAlert().showAlert("title_regist".localized, subTitle: "알림 수신 설정을 활성화 하세요", style: AlertStyle.warning) return
//            print("알림을 활성화 하세요")
//        }
        
        
        

    
    }
    
    
    func checkNotificationState() {
        
       
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [self] settings in
            
            DispatchQueue.main.async {
                if settings.alertSetting == .enabled {
                    print("활성화")
                    
//                    if UserDefaults.standard.bool(forKey: "alertAccess") == true {
                        UserDefaults.standard.set(true, forKey: "alertAccess")
                        fcmSwitch.isOn = true
//                    } else {
//                        UserDefaults.standard.set(false, forKey: "alertAccess")
//                        fcmSwitch.isOn = false
//                    }
//
                    
                } else {
                    print("비활성화")
                    UserDefaults.standard.set(false, forKey: "alertAccess")
                    fcmSwitch.isOn = false
                }
            }

        }

    }
   
    
    func getProfileImage() {
        let imageString = UserDefaults.standard.string(forKey: "userProfileImage") ?? ""
        let userProfileImage = imageString.toImage()
        profileImage.image = userProfileImage
    }
    
    func getUserInfo() {
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = GetUserInfoRequest(id: id)
        dataManager.postSearch(param, viewController: self)
        
    }
    
    func configDesign() {
        
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
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewViewController") as! EditProfileViewViewController
        vc.mainDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func fcmSwitchAction(_ sender: UISwitch) {
       
        
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [self] settings in
            
            DispatchQueue.main.async {
                if settings.alertSetting == .enabled {
                    print("활성화")
                    self.isON = !UserDefaults.standard.bool(forKey: "alertAccess")
                    UserDefaults.standard.set(fcmSwitch.isOn, forKey: "alertAccess")
                    print(UserDefaults.standard.bool(forKey: "alertAccess"))
            
                    if isON == false {
                        //let param = RemoveFcmTokenRequest(curUser: UserDefaults.standard.string(forKey: "userID")!)
                        //dataManager.removeFcmToken(param, viewController: self)
                        print("꺼짐")
                        UIApplication.shared.unregisterForRemoteNotifications()
                    } else {
                        print("켜짐")
                        UIApplication.shared.registerForRemoteNotifications()
                       // FirebaseApp.configure()
                        //Messaging.messaging().delegate = self
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
        
        
        
        
        
        
        
        
        
        
        
        
//        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//        }
//        print(1)
//        self.isON = !self.isON
//        UserDefaults.standard.set(fcmSwitch.isOn, forKey: "alertAccess")
//        print(UserDefaults.standard.bool(forKey: "alertAccess"))
//
//        if isON == false {
//            //let param = RemoveFcmTokenRequest(curUser: UserDefaults.standard.string(forKey: "userID")!)
//            //dataManager.removeFcmToken(param, viewController: self)
//            print("꺼짐")
//            UIApplication.shared.unregisterForRemoteNotifications()
//        } else {
//            print("켜짐")
//            UIApplication.shared.registerForRemoteNotifications()
//           // FirebaseApp.configure()
//            //Messaging.messaging().delegate = self
//        }
        
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
        
        
        
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//
//        let photoRef = storageRef.child("\(UserDefaults.standard.string(forKey: "userID"))").child
//
//        guard let imageData = newImage?.jpegData(compressionQuality: 0.5) else {
//            print("업로드 실패")
//            return
//        }
//
//        photoRef.putData(imageData, metadata: nil, completion: { _, error in
//            guard error == nil else {
//                print("업로드 실패2")
//                print(error)
//                return
//            }
//            photoRef.downloadURL(completion: { [self] url, error in
//                guard let url = url, error == nil else {
//                    return
//                }
//
//                let urlString = url.absoluteString
//                print(urlString)
////                self.presenter.executeUserProfile(profileImg: urlString, nickname: UserDefaults.standard.string(forKey: UserDefaultKey.nickname) ?? "")
//
////                WEKITLog.debug("Download URL: \(urlString)")
//            })
//
//        })
//
//
//
//
//
        
        
        
        
        
        
        //print(">> 바뀐 프로필 이미지 \(String(describing: newImage))")
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        var editImage = newImage?.resize(newWidth: 300)
        let jpgImage = editImage?.jpegData(compressionQuality: 0.5)
//        var editImage = newImage?.resize(newWidth: 100)
//
//        editImage = newImage?.downSample1(scale: 0.25)
        //let changeImageString = editImage?.toPngString()
        
        let jpgString = jpgImage?.base64EncodedString(options: .lineLength64Characters)
        
        UserDefaults.standard.set(jpgString, forKey: "userProfileImage")
        
        let param = ChangeProfileImageRequest(curId: id, profile_image: jpgString!)
        //dataManager.postChangeProfileImage(param, viewController: self)
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

//
//extension SettingViewController: UISceneDelegate {
//    func sceneDidBecomeActive(_ scene: UIScene) {
//        print(1)
//    }
//}
