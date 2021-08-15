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

    @IBOutlet weak var dropdownImage: UIImageView!
    @IBOutlet weak var banButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dropdownBaseView: UIView!
    @IBOutlet weak var dropdownLabel: UILabel!
    @IBOutlet var mainBaseView: UIView!
    @IBOutlet weak var baseView: UIView!
    
    let dropDown = DropDown()
    let banReason = ["욕설 및 비방", "불쾌한 게시글", "불쾌한 닉네임"]
    
    lazy var dataManager: DetailPostViewDataManager = DetailPostViewDataManager(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDropdown()
        configDesign()
        
    }
}

//MARK: -기본 UI함수
extension BanPopUPViewController {
   
    func setDropdown() {
        dropdownLabel.text = "사유를 선택 해주세요"
        mainBaseView.backgroundColor = .clear
        
        dropDown.anchorView = dropdownBaseView
        dropDown.dataSource = banReason
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            print("selected item: \(item) at index: \(index)")
            dropdownImage.image = UIImage(named: "gray_drop_down")
            self.dropdownLabel.text = banReason[index]
        }
        
        dropDown.cancelAction = { [unowned self] in
            dropdownImage.image = UIImage(named: "gray_drop_down")
        }

        dropDown.willShowAction = { [unowned self] in
            dropdownImage.image = UIImage(named: "gray_drop_up")
        }
        
    }
    
    func configDesign() {
        banButton.layer.cornerRadius = 3
        cancelButton.layer.cornerRadius = 3
        baseView.layer.cornerRadius = 3
        baseView.layer.borderWidth = 1.5
        baseView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        baseView.backgroundColor = .white
    }
}

//MARK: -스토리보드 Action 함수
extension BanPopUPViewController {
    
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
            okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            let userID = UserDefaults.standard.string(forKey: "userID")!
            let content = dropdownLabel.text!
            
            let param = BanArticleRequest(curUser: userID, article_no: getPostNumber, content: content)
            dataManager.postBanArticleCount(param, viewController: self)
        }
    }
}

//MARK: -DataManager 연결 함수
extension BanPopUPViewController: DetailPostView {
    func reloadPost() {}
    
    func updateTableView() {}
    
    func successPost() {}
    
    func stopRefreshControl() {}
    
    func popView(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {_ in
            self.dismiss(animated: false, completion: nil)
        })
        okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}
