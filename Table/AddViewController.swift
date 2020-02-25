//
//  AddViewController.swift
//  Table
//
//  Created by yoonbumtae on 2020/02/14.
//  Copyright © 2020 BGSMM. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    let PICKER_VIEW_COLUMN = 1
    let PICKER_VIEW_HEIGHT:CGFloat = 50
    var imageArray = [UIImage?]()
    var imgCurrentSelectedIndex: Int = 0

    @IBOutlet var txtAddItem: UITextField!
    @IBOutlet var txtAddDetail: UITextField!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for i in 0 ..< itemsImageFile.count {
            let image = UIImage(named: itemsImageFile[i])
            imageArray.append(image)
        }
        
        imgView.image = UIImage(named: itemsImageFile[0])
    }
    @IBAction func btnAddItem(_ sender: Any) {
        
        let iconStrIndex = itemsImageFile[imgCurrentSelectedIndex].count - 4
        let iconStr = itemsImageFile[imgCurrentSelectedIndex].prefix(iconStrIndex)
        // print(iconStrIndex, iconStr)
        
        let item = Todo(id: 0, icon: String(iconStr), title: txtAddItem.text!, detail: txtAddDetail.text!, regDate: "", modDate: "")
        itemsFromJSON.append(item)
        txtAddItem.text = ""
        txtAddDetail.text = ""
        _ = navigationController?.popViewController(animated: true)
        
        // ** 서버에 새로운 todo 추가
        let title = item.title
        let detail = item.detail
        let icon = item.icon
        let paramText = "icon=\(icon)&title=\(title)&detail=\(detail)"
        
        sendPost(paramText: paramText, urlString: "http://localhost:8080/todo/insert")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsImageFile.count
    }
    
    // returns height of row for each component.
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return PICKER_VIEW_HEIGHT
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView(image:imageArray[row])
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        return imageView
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//           return itemsImageFile[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imgView.image = imageArray[row]
        imgCurrentSelectedIndex = row
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
