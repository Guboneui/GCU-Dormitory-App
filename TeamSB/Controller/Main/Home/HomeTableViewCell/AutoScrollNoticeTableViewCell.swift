//
//  AutoScrollNoticeTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/07.
//

import UIKit

class AutoScrollNoticeTableViewCell: UITableViewCell {

    var nowPage = 0
    @IBOutlet weak var mainCollectionView: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var notice: [String] = [
        "1. 글 작성 관련 주의사항 들어가는 곳 입니다.",
        "2. 글 작성 관련 주의사항 들어가는 곳 입니다.",
        "3. 글 작성 관련 주의사항 들어가는 곳 입니다."
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(UINib(nibName: "AutoScrollNoticeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AutoScrollNoticeCollectionViewCell")
        
        bannerTimer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 2초마다 실행되는 타이머
    func bannerTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            self.bannerMove()
        }
    }
    // 배너 움직이는 매서드
    func bannerMove() {
        // 현재페이지가 마지막 페이지일 경우
        if nowPage == notice.count-1 {
        // 맨 처음 페이지로 돌아감
            mainCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .bottom, animated: true)
            nowPage = 0
            return
        }
        // 다음 페이지로 전환
        nowPage += 1
        mainCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .bottom, animated: true)
    }
    
}

extension AutoScrollNoticeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notice.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AutoScrollNoticeCollectionViewCell", for: indexPath) as! AutoScrollNoticeCollectionViewCell
        
        cell.noticeLabel.text = notice[indexPath.row]
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    
}

extension AutoScrollNoticeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            
            let itemsPerRow: CGFloat = 1
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            let itemsPerColumn: CGFloat = 1
            let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
            
            let cellWidth = (width - widthPadding) / itemsPerRow
            let cellHeight = (height - heightPadding) / itemsPerColumn
            
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
            func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
          return sectionInsets
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return sectionInsets.left
        }
}
