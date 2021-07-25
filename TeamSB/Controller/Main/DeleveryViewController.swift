//
//  DelevaryViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

class DeleveryViewController: UIViewController {

    var currentPage = 0
    var isLoadedAllData = false
    var saveData = [Any]()
    
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDelivary(page: currentPage)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        let mainTableViewNib = UINib(nibName: "DeleveryTableViewCell", bundle: nil)
        mainTableView.register(mainTableViewNib, forCellReuseIdentifier: "DeleveryTableViewCell")
        
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        
       
    }
    
    

    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        saveData.removeAll()
        mainTableView.reloadData()
        getDelivary(page: currentPage)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "배달"
        self.tabBarController?.tabBar.isHidden = true
        let goWriteView = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
        goWriteView.tintColor = .black
        let ass = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        ass.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        ass.tintColor = .black
        
        
        navigationItem.rightBarButtonItems = [goWriteView, ass]
        
        
        
    }
    
    func getDelivary(page: Int) {
        
        currentPage += 1
        
        guard
            isLoadedAllData == false
        else {
            return
        }
        
        
        
        let URL = "http://13.209.10.30:3000/home/delivery?page=\(currentPage)"
        let alamo = AF.request(URL, method: .get, parameters: nil).validate(statusCode: 200...500)
        
        alamo.responseJSON { [self] (response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 배달 게시글 API 호출 성공")
                    
                    mainTableView.refreshControl?.endRefreshing()
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        guard content.count > 0 else {
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(saveData.count)")
                            self.isLoadedAllData = true
                            return
                        }
                        
                        
                        for i in 0..<content.count {
                            saveData.append(content[i])
                        }
                        print(">> \(URL)")
                        print(">> 읽어온 게시글의 개수: \(content.count), 현재 페이지\(page+1)")
                        mainTableView.reloadData()
                    }
                  
                }
            case .failure(let error):
                if let jsonObj = error as? NSDictionary {
                    print("서버통신 실패")
                    print(error)
                }
                
            }
            
        }
    }
    
    
    @objc func goWriteView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}


extension DeleveryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeleveryTableViewCell", for: indexPath) as! DeleveryTableViewCell
        
        let data = saveData[indexPath.row] as! NSDictionary
        
        cell.titleLabel.text = data["title"] as? String
        cell.timeLabel.text = data["timeStamp"] as? String
        cell .contentsLabel.text = data["text"] as? String
        
        var hashString = ""
        
        let hashData = data["hash"] as! NSArray
        
        for i in 0..<hashData.count {
            hashString += "#" + "\(hashData[i] as! String) "
        }
        
        
        
        
        return cell
    }
    
    
}

extension DeleveryViewController: UpdateData {
    func update() {
        currentPage = 0
        isLoadedAllData = false
        saveData = []
        getDelivary(page: currentPage)
    }
    
    
}
