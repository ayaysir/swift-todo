//
//  TableViewController.swift
//  Table
//
//  Created by yoonbumtae on 2020/02/14.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

func sendPost(paramText: String, urlString: String) {
    
    // paramText를 데이터 형태로 변환
    let paramData = paramText.data(using: .utf8)

    // URL 객체 정의
    let url = URL(string: urlString)

    // URL Request 객체 정의
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.httpBody = paramData

    // HTTP 메시지 헤더
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")

    // URLSession 객체를 통해 전송, 응답값 처리
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // 서버가 응답이 없거나 통신이 실패
        if let e = error {
          NSLog("An error has occured: \(e.localizedDescription)")
          return
        }

        // 응답 처리 로직
        DispatchQueue.main.async() {
            // 서버로부터 응답된 스트링 표시
            let outputStr = String(data: data!, encoding: String.Encoding.utf8)
            print("result: \(outputStr!)")
        }
      
    }
    // POST 전송
    task.resume()
}
struct Todo: Codable {
    let id: Int
    let icon: String
    let title: String
    let detail: String
    let regDate: String
    let modDate: String
}

var itemsFromJSON = [Todo]()
let itemsImageFile = ["cart.png", "clock.png", "pencil.png"]

class TableViewController: UITableViewController {

    @IBOutlet var tblListView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // ** 서버에서 목록 가져오기
        do {
            let url = URL(string: "http://localhost:8080/todo/get")
            let response = try String(contentsOf: url!)
            //print(response)
            
            let json = response.data(using: .utf8)
            
            let decoded = try JSONDecoder().decode([Todo].self, from: json!)
            itemsFromJSON = decoded
            //print(itemsFromJSON)
            
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
        
        
        // 상단 왼쪽에 Edit 버튼 생성
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 테이블 행의 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print(itemsFromJSON.count)
        return itemsFromJSON.count
    }
    
    // 각 행에 내용 삽입
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = itemsFromJSON[(indexPath as NSIndexPath).row].title
        cell.imageView?.image = UIImage(named: itemsFromJSON[ (indexPath as NSIndexPath).row ].icon + ".png" )

        return cell
    }
    
    // 행 삭제
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // ** 서버에 삭제 명령 보내기
            let id = itemsFromJSON[(indexPath as NSIndexPath).row].id
            let paramText = "id=\(id)"
            
            sendPost(paramText: paramText, urlString: "http://localhost:8080/todo/delete")
            
            itemsFromJSON.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade) // 삭제 애니메이션

        } else if editingStyle == .insert {
        }
    }
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }

    // 순서 바꾸기
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = itemsFromJSON[(sourceIndexPath as NSIndexPath).row]

        itemsFromJSON.remove(at: (sourceIndexPath as NSIndexPath).row)

        itemsFromJSON.insert(itemToMove, at: (destinationIndexPath as NSIndexPath).row)

    }
    
    // 메인 페이지로 되돌아왔을 때 새로고침
    override func viewWillAppear(_ animated: Bool) {
        tblListView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sgDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tblListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            detailView.receiveItem(itemsFromJSON[(indexPath! as NSIndexPath).row])
        }
    }
    

}
