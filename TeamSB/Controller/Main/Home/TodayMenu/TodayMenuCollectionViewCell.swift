//
//  TodayMenuCollectionViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/05.
//

import UIKit

class TodayMenuCollectionViewCell: UICollectionViewCell {
    
    
    let kkk: [String] = ["미역국", "쌀밥", "청경채무침", "우유", "제육볶음", "ㅁㅁㄴㅇㄹㅁㅇㄹㅁㄴㅇㄹㅁㅇㄴㄹㅁㅇㄹㄴㅁㅇㄹㅁㅇㄴㄹㅁㅇㄹㅁㅇㄹㅁㄹㅁㄹㅇㅁㄴㄹㅁㅇㄹㅁㄹㅁㅇㄴㅁㅇㄹㅁㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㅇㄹㅁㄹ", "ㅁ"]

    @IBOutlet weak var menuTypeLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.estimatedRowHeight = 20
        menuTableView.rowHeight = UITableView.automaticDimension
        let menuTableViewNib = UINib(nibName: "DetailMenuTableViewCell", bundle: nil)
        menuTableView.register(menuTableViewNib, forCellReuseIdentifier: "DetailMenuTableViewCell")
    }

}

extension TodayMenuCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMenuTableViewCell") as! DetailMenuTableViewCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = kkk[indexPath.row]
        
        return cell
    }
    
    
}
