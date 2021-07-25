//
//  DetailPostViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/26.
//

import UIKit
import Alamofire
import IQKeyboardManager

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsTextView.isEditable = false
       
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        checkWriter()
        setData()
        setDesign()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "게시글"
        
        
    }
    
    @objc func editPost() {
        print(">> 게시글을 수정합니다.")
    }
    
    @objc func deletePost() {
        print(">> 게시글을 삭제합니다.")
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
            print("글쓴이")
            showBarItem()
        } else {
            print("읽기만 가능")
        }
    }

}
