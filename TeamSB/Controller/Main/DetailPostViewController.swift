//
//  DetailPostViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/26.
//

import UIKit
import Alamofire
import IQKeyboardManager


protocol WhenDismissDetailView: AnyObject {
    func update()
}

class DetailPostViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var showCountLabel: UILabel!
    
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var getPostNumber: Int = 0
    var getTitle: String = ""
    var getCategory: String = ""
    var getTime: String = ""
    var getUserID: String = ""
    var getNickname: String = ""
    var getContents: String = ""
    var getShowCount: Int = 0
    
    weak var delegate: UpdateData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsTextView.isEditable = false
       
        
        print(">> 게시글 작성자 ID = \(getUserID)...닉네임 = \(getNickname)")
        print(">> \(getPostNumber) 게시글의 현재 조회수는 \(getShowCount)")
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        checkWriter()
        setData()
        setDesign()
        
        postAccessArticle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "게시글"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.update()
    }
    
    func setData() {
        titleLabel.text = getTitle
        categoryLabel.text = getCategory
        timeLabel.text = getTime
        nicknameLabel.text = getNickname
        contentsTextView.text = getContents
        showCountLabel.text = "\(getShowCount)"
    }
    
    func setDesign() {
        titleLabel.backgroundColor = UIColor.SBColor.SB_LightYellow
        categoryLabel.backgroundColor = UIColor.SBColor.SB_LightYellow
        timeLabel.backgroundColor = UIColor.SBColor.SB_LightYellow
        nicknameLabel.backgroundColor = UIColor.SBColor.SB_LightYellow
        
    }
    
    func postAccessArticle() {
        let URL = "http://13.209.10.30:3000/accessArticle"
        let PARAM: Parameters = [
            "no": getPostNumber
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON{(response) in
           
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 게시글 조회수 +1 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        
                        
                    } else {
                        let message = jsonObj.object(forKey: "message") as! String
                        
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
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
    
    
    @objc func editPost() {
        print(">> 게시글을 수정합니다.")
    }
    
    @objc func deletePost() {
        print(">> 게시글을 삭제버튼 클릭")
        let alert = UIAlertController(title: "삭제하시겠어요?", message: "", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: {_ in
            print("게시글 삭제 취소")
        })
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[self] _ in
            //print(">> 게시글 삭제")
            postDeleteArticle()
        })
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func postDeleteArticle() {
        let userID = UserDefaults.standard.string(forKey: "userID")
        let currentNO = getPostNumber
        
        let URL = "http://13.209.10.30:3000/deleteArticle"
        let PARAM: Parameters = [
            "curUser": userID!,
            "no": currentNO
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        alamo.responseJSON{(response) in
            
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 게시글 삭제 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        let message = jsonObj.object(forKey: "message") as! String
                        
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
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
    
    

    func showBarItem() {
        let delete = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deletePost))
        delete.tintColor = .black
        let edit = UIBarButtonItem(image: UIImage(systemName: "wand.and.rays"), style: .plain, target: self, action: #selector(editPost))
        edit.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        edit.tintColor = .black
        
        
        navigationItem.rightBarButtonItems = [delete, edit]
    }
    
    func checkWriter() {
        let userid = UserDefaults.standard.string(forKey: "userID")
        if getUserID == userid {
            print(">> 작성자가 접근하여 수정과 삭제가 모두 가능합니다")
            showBarItem()
        } else {
            print("일반 유저가 접근하여 읽기만 가능")
        }
    }

}
