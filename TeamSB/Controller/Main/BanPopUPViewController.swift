//
//  BanPopUPViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/27.
//

import UIKit
import DropDown
import Alamofire

class BanPopUPViewController: UIViewController {

    
    var getPostNumber: Int = 0
    
    
    @IBOutlet weak var dropdownBaseView: UIView!
    @IBOutlet weak var dropdownLabel: UILabel!
    @IBOutlet var mainBaseView: UIView!
    
    
    let dropDown = DropDown()
    let banReason = ["욕설 및 비방", "불쾌한 게시글", "불쾌한 닉네임"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownLabel.text = "사유를 선택 해주세요"
        mainBaseView.backgroundColor = .clear
        
        dropDown.anchorView = dropdownBaseView
        dropDown.dataSource = banReason
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            print("selected item: \(item) at index: \(index)")
            self.dropdownLabel.text = banReason[index]
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissViewButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dropdownButtonAction(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func banButtonAction(_ sender: Any) {
        print(">> 신고하기 버튼 클릭")
        
        if dropdownLabel.text == "사유를 선택 해주세요" || dropdownLabel.text == nil {
            let alert = UIAlertController(title: "사유를 선택 해주세요", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            postBanArticle()
        }
        
        
        
    }
    
    
    func postBanArticle() {
        let userID = UserDefaults.standard.string(forKey: "userID")
        let currentNO = getPostNumber

        let URL = "http://13.209.10.30:3000/report"
        let PARAM: Parameters = [
            "curUser": userID!,
            "article_no": currentNO,
            "content": dropdownLabel.text!
        ]

        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        alamo.responseJSON{(response) in

            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 게시글 신고 API 호출 성공")

                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        
                        let alert = UIAlertController(title: "신고가 완료되었습니다", message: "", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[self] _ in
                            self.dismiss(animated: false, completion: nil)
                        })
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        

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
