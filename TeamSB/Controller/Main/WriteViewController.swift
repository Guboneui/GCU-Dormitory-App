//
//  WriteViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import DropDown

class WriteViewController: UIViewController {
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var dropdownBaseView: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var guideLineView: UIView!
    @IBOutlet weak var contentsTextView: UITextView!
    
    let dropDown = DropDown()
    let categoryArray = ["배달", "택배", "택시", "빨래"]
    
    var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        resignForKeyboardNotification()
        //다른 공간 클릭 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
        
        guideLineView.backgroundColor = UIColor.SBColor.SB_DarkGray
        
        categoryTitle.text = "카테고리"
        dropDown.anchorView = dropdownBaseView
        dropDown.dataSource = categoryArray
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            print("selected item: \(item) at index: \(index)")
            self.categoryTitle.text = categoryArray[index]
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "글쓰기"
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissKeyboard() {  //키보드 숨김처리
        view.endEditing(true)
    }
    
    func resignForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = 0
        let bottom = view.frame.origin.y
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardReactangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardReactangle.height
            self.view.frame.origin.y = bottom - keyboardHeight / 2 + 50
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
   
}
