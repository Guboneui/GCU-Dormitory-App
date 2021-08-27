//
//  EditProfileViewViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/15.
//

import UIKit
import Photos

protocol DismissSelfView: AnyObject {
    func dismissSelf()
}

protocol ChangeProfileImage: AnyObject {
    func changeProfile(image: String)
}

class EditProfileViewViewController: UIViewController {
    

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var getAlbumButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var configButton: UIButton!
    
    weak var delegate: DismissSelfView?
    weak var mainDelegate: ChangeProfileImage?
    
    lazy var dataManager: SettingDataManager = SettingDataManager(view: self)
    var newImage: UIImage? = nil // update 할 이미지
    let picker = UIImagePickerController()
    var jpgString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "userProfileImage") == nil || UserDefaults.standard.string(forKey: "userProfileImage") == "" {
            print(">> 기본 프로필 이미지 적용")
            profileImage.image = UIImage(named: "default_profileImage")
        } else {
            let imageString = UserDefaults.standard.string(forKey: "userProfileImage") ?? ""
            let userProfileImage = imageString.toImage()
            profileImage.image = userProfileImage
            
        }
        
        

        configDesign()
    }
    
    func configDesign() {
        baseView.layer.borderWidth = 1.5
        baseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderWidth = 0.3
        profileImage.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        getAlbumButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 3
        configButton.layer.cornerRadius = 3
        
    }
    
    @IBAction func getAlbumButtonAction(_ sender: Any) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        print("status is \(status), value is \(status.rawValue)")

        if status != PHAuthorizationStatus.authorized {
            print("not authorizedAlways")

            let alert = UIAlertController(title: "권한", message: "프로필 설절을 위해 '사진' 접근 권한이 필요합니다.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let okButton = UIAlertAction(title: "설정", style: .default, handler: {(action) -> Void in
               print("UserAgree")
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
        
        else {
            self.picker.sourceType = .photoLibrary // 방식 선택. 앨범에서 가져오는걸로 선택.
            self.picker.allowsEditing = true // 수정가능하게 할지 선택. 하지만 false
            self.picker.delegate = self
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func configButtonAction(_ sender: Any) {
        
        delegate = self
        
        
        if profileImage.image == UIImage(named: "default_profileImage") {
            let id = UserDefaults.standard.string(forKey: "userID")!
            let param = ChangeProfileImageRequest(curId: id, profile_image: "")
            dataManager.postChangeProfileImage(param, viewController: self)
        } else {
            
            let id = UserDefaults.standard.string(forKey: "userID")!
            let editImage = newImage?.resize(newWidth: 200)
            let jpgImage = editImage?.jpegData(compressionQuality: 0.25)

            
            jpgString = (jpgImage?.base64EncodedString(options: .lineLength64Characters))!
            
            
            
            let param = ChangeProfileImageRequest(curId: id, profile_image: jpgString)
            dataManager.postChangeProfileImage(param, viewController: self)
            picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        }
        
        
        
    }
    
}


extension EditProfileViewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        self.profileImage.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
}


extension EditProfileViewViewController: SettingView {
    func dismissProfileView() {
        let alert = UIAlertController(title: "프로필 이미지 변경 성공", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: { [self] _ in
            UserDefaults.standard.set(jpgString, forKey: "userProfileImage")
            delegate?.dismissSelf()
            
            let image = UserDefaults.standard.string(forKey: "userProfileImage")!
            mainDelegate?.changeProfile(image: image)
        })
        okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func settingNickname(nickname: String) {
    }
    
    func successChangeNickname() {
    }
    
}

extension EditProfileViewViewController: DismissSelfView {
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
