//
//  DetailViewController.swift
//  Table
//
//  Created by yoonbumtae on 2020/02/14.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var receivedItem: Todo?

    @IBOutlet var lblItem: UILabel!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblItem.text = receivedItem!.title
        imgIcon.image = UIImage(named: receivedItem!.icon + ".png")
        lblDetail.text = receivedItem!.detail
    }
    
    func receiveItem(_ item: Todo) {
        receivedItem = item
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
