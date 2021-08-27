//
//  OpenSourceViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/19.
//

import UIKit
import ExpyTableView
import SafariServices

class OpenSourceViewController: UIViewController {

    
    var openSourceName: [String] = ["Alamofire", "FSCalendar", "DropDown", "IQKeyboardManager", "NVActivityIndicatorView", "SnapKit", "ExpyTableView", "MIT License"]
    var openSourceLink: [String] = [
        "https://github.com/Alamofire/Alamofire",
        "https://github.com/WenchaoD/FSCalendar",
        "https://github.com/AssistoLab/DropDown",
        "https://github.com/hackiftekhar/IQKeyboardManager",
        "https://github.com/ninjaprox/NVActivityIndicatorView",
        "https://github.com/SnapKit/SnapKit",
        "https://github.com/okhanokbay/ExpyTableView",
        "https://opensource.org/licenses/MIT"
    ]
    var openSourceInfo: [String] = [
        "MIT License",
        "MIT License",
        "MIT License",
        "MIT License",
        "MIT License",
        "MIT License",
        "MIT License",
        """
        Copyright <YEAR> <COPYRIGHT HOLDER>

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
        """
        
    ]
    
    
    @IBOutlet weak var mainTableView: ExpyTableView!
    var backButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "OpenSourceTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenSourceTableViewCell")
        mainTableView.register(UINib(nibName: "OpenSourceSubTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenSourceSubTableViewCell")
        mainTableView.separatorStyle = .none
        
        backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "오픈소스"
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
   

}


extension OpenSourceViewController: ExpyTableViewDelegate, ExpyTableViewDataSource {

    //델리게이트
    //열리고 닫히고 상태가 변경될 떄
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        switch state {
        case .willExpand:
            break
        case .willCollapse:
            break
        case .didExpand:
            break
        case .didCollapse:
            break
        }
    }
    
    
    //데이터 소스
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    //헤더뷰 (펼치는 섹션)
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenSourceTableViewCell") as! OpenSourceTableViewCell
        
        cell.selectionStyle = .none
        
        let data = openSourceName[section]
        cell.titleLabel.text = data
      
        
        
        return cell
    }
    
    //각 섹션에 들어갈 로우의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenSourceSubTableViewCell") as! OpenSourceSubTableViewCell
        let info = openSourceInfo[indexPath.section]
        let link = openSourceLink[indexPath.section]
        
        cell.linkButton.setTitle(link, for: .normal)
        cell.contentsLabel.text = info
        cell.selectionStyle = .none
        
        let userText = cell.linkButton.currentTitle!
        let textRange = NSRange(location: 0, length: userText.count)
        let attributedText = NSMutableAttributedString(string: userText)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        cell.linkButton.titleLabel!.attributedText = attributedText
        
        cell.selectionStyle = .none
        
        
        
        cell.linkButton.addTarget(self, action: #selector(accessLink(button: )), for: .touchUpInside)
        
        
       
        return cell
    }
    
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return openSourceName.count
    }
    
    
    @objc func accessLink(button: UIButton) {
        let userPrivateUrl = URL(string: button.currentTitle!)
        let userPrivateSafariView: SFSafariViewController = SFSafariViewController(url: userPrivateUrl! as URL)
        self.present(userPrivateSafariView, animated: true, completion: nil)
    }
    
}
