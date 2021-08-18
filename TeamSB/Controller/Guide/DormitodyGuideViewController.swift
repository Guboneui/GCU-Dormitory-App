//
//  DormitodyGuideViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/19.
//

import UIKit
import ExpyTableView

class DormitoryGuideViewController: UIViewController {

    
    @IBOutlet weak var topGuideLine: UIView!
    @IBOutlet weak var mainTableView: ExpyTableView!
    var backButton: UIBarButtonItem!
    
    var guideList: [GuideList] = []
    lazy var dataManager: DormitoryGuideDataManager = DormitoryGuideDataManager(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()

        dataManager.getGuide(viewController: self)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.register(UINib(nibName: "DormitoryGuideTableViewCell", bundle: nil), forCellReuseIdentifier: "DormitoryGuideTableViewCell")
        mainTableView.register(UINib(nibName: "DormitoryGuideSubTableViewCell", bundle: nil), forCellReuseIdentifier: "DormitoryGuideSubTableViewCell")
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        
        topGuideLine.layer.shadowOffset = CGSize(width: 0, height: 2)
        topGuideLine.layer.shadowOpacity = 0.2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "가이드"
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshData() {
        print(">> 상단 새로고침")
        
        
        
        
        guideList.removeAll()
        mainTableView.reloadData()
        dataManager.getGuide(viewController: self)
    }
    
}

extension DormitoryGuideViewController: ExpyTableViewDelegate, ExpyTableViewDataSource {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DormitoryGuideTableViewCell") as! DormitoryGuideTableViewCell
        
        cell.selectionStyle = .none
        
        let data = guideList[section]
        cell.titleLabel.text = data.title
      
        return cell
    }
    
    //각 섹션에 들어갈 로우의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DormitoryGuideSubTableViewCell") as! DormitoryGuideSubTableViewCell
        let data = guideList[indexPath.section]
        cell.subTitleLabel.text = data.title
        cell.contentsLabel.text = data.content
        cell.selectionStyle = .none
        
        
        
        
       
        return cell
    }
    
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return guideList.count
    }
    
}

extension DormitoryGuideViewController: DormitoryView {
    func reloadTableView() {
        self.mainTableView.reloadData()
    }
    
    
}
