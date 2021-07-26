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

    
    var serverContentDataArray: [Any] = []
    
    
    @IBOutlet weak var mainTableView: UITableView!
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
        
        
       
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.estimatedRowHeight = 130
        mainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        let mainPostTableViewNib = UINib(nibName: "MainPostTableViewCell", bundle: nil)
        mainTableView.register(mainPostTableViewNib, forCellReuseIdentifier: "MainPostTableViewCell")
        
        let mainCommentsTableViewNib = UINib(nibName: "MainCommentsTableViewCell", bundle: nil)
        mainTableView.register(mainCommentsTableViewNib, forCellReuseIdentifier: "MainCommentsTableViewCell")
        
        
        
        
        
        print(">> 게시글 작성자 ID = \(getUserID)...닉네임 = \(getNickname)")
        print(">> \(getPostNumber) 게시글의 현재 조회수는 \(getShowCount)")
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        


        postAccessArticle()
        postComment()
        checkWriter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "게시글"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.update()
    }
    

    
    func postAccessArticle() {  //게시글 조회수 더하는 API
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
    
    func postDeleteArticle() {  //게시글 삭제 API
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
    
    
    func postComment() {
        
        serverContentDataArray.removeAll()
        let userID = UserDefaults.standard.string(forKey: "userID")
        let currentNO = getPostNumber
        
        let URL = "http://13.209.10.30:3000/reply/list"
        let PARAM: Parameters = [
            "curUser": userID!,
            "article_no": currentNO
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON{ [self](response) in
            
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 현재 게시글의 댓글 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        
                        
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        for i in 0..<content.count {
                            serverContentDataArray.append(content[i])
                        }
                        
                        
                        mainTableView.reloadData()
                        

                        
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
    

    func showAdminBarItem() {
        let delete = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deletePost))
        delete.tintColor = .black
        let edit = UIBarButtonItem(image: UIImage(systemName: "wand.and.rays"), style: .plain, target: self, action: #selector(editPost))
        edit.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        edit.tintColor = .black
        
        
        navigationItem.rightBarButtonItems = [delete, edit]
    }
    
    func showUserBarItem() {
        let ban = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(showBanAlert))
        ban.tintColor = .black
        
        navigationItem.rightBarButtonItem = ban
    }
    
    func checkWriter() {
        let userid = UserDefaults.standard.string(forKey: "userID")
        if getUserID == userid {
            print(">> 작성자가 접근하여 수정과 삭제가 모두 가능합니다")
            showAdminBarItem()
        } else {
            print("일반 유저가 접근하여 읽기만 가능")
            showUserBarItem()
        }
    }
    
    @objc func showBanAlert() {
        let alert = UIAlertController(title: "게시글 신고", message: "", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[self] _ in

            let vc = storyboard?.instantiateViewController(withIdentifier: "BanPopUPViewController") as! BanPopUPViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.getPostNumber = getPostNumber
            
            self.present(vc, animated: false, completion: nil)
            
            
        })
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        
        
        self.view.endEditing(true)
        
        
        if messageTextField.text == "" || messageTextField.text == nil {
            
            
        } else {
            let message = messageTextField.text!
            postReplyWrite(comment: message)
            messageTextField.text = ""
            mainTableView.setContentOffset(CGPoint(x: 0, y: mainTableView.contentSize.height), animated: true)
        }
        
    }
    
    func postReplyWrite(comment: String) {
        let userID = UserDefaults.standard.string(forKey: "userID")
        let currentNO = getPostNumber
        
        let URL = "http://13.209.10.30:3000/reply/write"
        let PARAM: Parameters = [
            "article_no": currentNO,
            "content": comment,
            "curUser": userID!,
            
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON{ [self](response) in
            
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 댓글 추가 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        
                        
                        postComment()
                        
                        
                        
                        
                        
                        
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
    
    

}


extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            
            
            print(serverContentDataArray.count)
            
            return serverContentDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainPostTableViewCell", for: indexPath) as! MainPostTableViewCell
            
            cell.titleLabel.text = getTitle
            
            
            
            
            
            
            
            cell.categoryLabel.text = getCategory
            cell.timeLabel.text = getTime
            cell.adminLabel.text = getNickname
            cell.contentsTextView.text = getContents
            cell.contentsTextView.isEditable = false
            
            
            return cell
            
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCommentsTableViewCell", for: indexPath) as! MainCommentsTableViewCell
            
            let data = serverContentDataArray[indexPath.row] as! NSDictionary
            
            
            cell.nicknameLabel.text = data["userNickname"] as? String
            cell.commentLabel.text = data["content"] as? String
            
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        mainTableView.scrollToRow(at: [1, 0], at: .bottom, animated: true)
//    }
    
    
}
