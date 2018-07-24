//
//  MainViewController.swift
//  Prompter
//
//  Created by phatthanaphong on 10/10/17.
//  Copyright © 2017 phatthanaphong. All rights reserved.
//

import UIKit
import SwiftyPlistManager
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var collapseButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var leftConstrain: NSLayoutConstraint!
    @IBOutlet weak var rightConstrain: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    var menuTableView: UITableView!
    
    var fileName:String?
    var collap = false
    var textName:String?
    var userID:Int?
    var initURLText = String()
    var recieverVCofText = TextTableViewController()
    var saveFlag:Bool?
    //var menuItem:[String] = ["โหมดในการแสดง promter", "รูปแบบการแสดง prompter", "แบบอักษร", "ขนาดอักษร", "ความเร็วของ prompter", "ระยะระหว่างบรรทัด","รูปแบบ pointer", "ความเร็วของ prompter"]
    //var imageName:[String] = ["computer", "circle", "social",  "text",  "gigsaw","computer", "circle", "social"]
    
    var menuItem:[String] = ["โหมดในการแสดง promter", "รูปแบบการแสดง prompter"]
    var imageName:[String] = ["computer", "circle"]
    
    var currentFileName:String?
    
    let topViewColor = UIColor(red: 0, green: 102/255, blue: 102/255, alpha: 1)
    let buttonColor = UIColor(red: 0, green: 102/255, blue: 102/255, alpha: 1)
    
    override func viewDidLoad() {
        
        if let text = self.textName{
            self.nameLabel.text = text
        }
        super.viewDidLoad()
        
        guard let loadURL = SwiftyPlistManager.shared.fetchValue(for: "initURL", fromPlistWithName: "Data") else { return }
        self.initURLText = loadURL as! String
        
        self.leftView.layer.borderWidth = 1;
        self.leftView.layer.borderColor = UIColor.lightGray.cgColor
        self.collapseButton.layer.backgroundColor = UIColor.gray.cgColor
        self.settingButton.layer.backgroundColor = UIColor.gray.cgColor
        self.playButton.layer.backgroundColor = UIColor.gray.cgColor
        self.previewButton.layer.backgroundColor = UIColor.gray.cgColor
        self.saveButton.layer.backgroundColor = UIColor.gray.cgColor
        self.topView.layer.backgroundColor = self.topViewColor.cgColor
        self.settingButton.layer.cornerRadius = 10;
        self.collapseButton.layer.cornerRadius = 10;
        self.playButton.layer.cornerRadius = 10;
        self.previewButton.layer.cornerRadius = 10;
        self.saveButton.layer.cornerRadius = 10;
        self.topView.layer.backgroundColor = self.topViewColor.cgColor
        createMenuTableView()
    }

    func createMenuTableView(){
        //let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        //let displayWidth: CGFloat = self.view.frame.width
        //let displayHeight: CGFloat = self.view.frame.height
        
        self.menuTableView = UITableView(frame: .zero, style: .plain)
        self.menuTableView.separatorStyle = .singleLine
        self.menuTableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        self.menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        self.menuTableView.backgroundColor = UIColor.black
        self.menuTableView.layer.cornerRadius = 4
        
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        //self.view.addSubview(myTableView)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func collapseTapped(_ sender: Any) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.leftConstrain.constant = self.collap ? 0 : -self.leftView.frame.size.width
            self.rightConstrain.constant = self.collap ? 0 : self.leftView.frame.size.width

            self.view.layoutIfNeeded()
        }){ (success) in
            self.collap = self.collap ? false:true
        }
        if self.collap == false{
            self.collapseButton.layer.backgroundColor = topViewColor.cgColor
            self.collapseButton.setTitle(">>|", for: .normal)
        }
        else{
            self.collapseButton.layer.backgroundColor = UIColor.gray.cgColor
            self.collapseButton.setTitle("|<<", for: .normal)
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTextData"{
            recieverVCofText = segue.destination as! TextTableViewController
            recieverVCofText.userID = self.userID
            recieverVCofText.textArea = self.textArea
            recieverVCofText.saveBtn = self.saveButton
            recieverVCofText.mainObject = self  // referencing file name of text between the views
        }
    }
 
    let blackView = UIView()
   
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
  
    @IBAction func settingTapped(_ sender: Any) {
        blackView.backgroundColor = UIColor(white:0, alpha : 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(handleDismiss)))
        view.addSubview(blackView)
        view.addSubview(menuTableView)
        let x = CGFloat(700)
        let y = CGFloat(97)
        menuTableView.frame = CGRect(x: x, y: y, width: 314, height: 0)
        blackView.frame = view.frame
        blackView.alpha = 0
        
        //using spring for a nicer animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.menuTableView.frame = CGRect(x: x, y:y, width: 320, height: 100)
        }, completion: nil)
        
        //change the background color
        self.settingButton.layer.backgroundColor = topViewColor.cgColor
    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.menuTableView.frame = CGRect(x: 700, y:97, width: 320, height: 0)
        })
        self.settingButton.layer.backgroundColor = UIColor.gray.cgColor
    }
    
    @IBAction func previewTapped(_ sender: Any) {
        self.previewButton.layer.backgroundColor = topViewColor.cgColor
        
        if(self.textArea.text.isEmpty){
            self.previewButton.layer.backgroundColor = UIColor.gray.cgColor
            DispatchQueue.main.async(execute: {
                self.displayMessgage(tileMsg: "cannot preview", msg: "please select texts to preview")
            })

        }
        else{
            let popOverVC = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "previewPopup") as! PreviewViewController
            self.addChildViewController(popOverVC)
            popOverVC.currentText =  self.textArea.text as String
            popOverVC.previewButton = self.previewButton
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
        }
        
    }
    
    func  displayMessgage(tileMsg:String, msg:String){
        let alert = UIAlertController(title: tileMsg, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: {
            if(self.saveFlag == true){
                self.saveButton.layer.backgroundColor = UIColor.gray.cgColor
                self.saveFlag = false;
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.menuItem.isEmpty){
            return 0
        }
        return self.menuItem.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.menuTableView.dequeueReusableCell(withIdentifier: "menuCell") as UITableViewCell?)!
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.black
        cell.textLabel?.text = self.menuItem[indexPath.row]
        cell.textLabel?.textColor = UIColor.lightGray
        let imageName = self.imageName[indexPath.row]
        cell.imageView?.image = UIImage(named:imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
            actionForMenuOne()
        case 1:
            actionForMenuTwo()
        default:
            print("select one of the menu")
        }
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = .red
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = .clear
    }
    
    func  actionForMenuOne(){

        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.menuTableView.frame = CGRect(x: 700, y:97, width: 320, height: 0)
        })
        
        self.settingButton.layer.backgroundColor = UIColor.gray.cgColor

        let popOverVC = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "displayOption") as! DisplayOptionViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
    }
    
    func  actionForMenuTwo(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.menuTableView.frame = CGRect(x: 700, y:97, width: 320, height: 0)
        })
        
        self.settingButton.layer.backgroundColor = UIColor.gray.cgColor
        
        let popOverVC = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "playOption") as! PlayOptionViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
    }
    
    @IBAction func tabPlay(_ sender: Any) {
        //
        // this function is performed when tapping play
        //
        self.playButton.layer.backgroundColor = topViewColor.cgColor
        
        if(self.textArea.text.isEmpty){
            self.playButton.layer.backgroundColor = UIColor.gray.cgColor
            DispatchQueue.main.async(execute: {
                self.displayMessgage(tileMsg: "cannot preview", msg: "please select texts to play")
            })
        }
        else{
            let popOverVC = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "playViewController") as! PlayViewController
            self.addChildViewController(popOverVC)
            popOverVC.currentText =  self.textArea.text as String
            popOverVC.playButton = self.playButton
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
        }
        
    }
    

    @IBAction func doUpdate(_ sender: Any) {
        if(recieverVCofText.textArea?.text == ""){
            displayMessgage(tileMsg: "Warning", msg: "กรุณาเลือกข้อความ")
        }else{
            self.saveFlag = true
            self.saveButton.layer.backgroundColor = topViewColor.cgColor
            upDateStatus(textID: recieverVCofText.currentTextId, xmlfile: recieverVCofText.currentXml!)
            
        }
    }
    
    
    func upDateStatus(textID:String, xmlfile:String){
        let sv = UIViewController.displaySpinner(onView: self.view)
        let urlConvert = self.initURLText.trimmingCharacters(in: .whitespacesAndNewlines)+":9003/convertJson"
        let h = self.initURLText.substring(from: 7, to: self.initURLText.count)
        Alamofire.request(urlConvert, method: .post, parameters: ["id":textID, "xmlfile":xmlfile, "host":h],encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                guard let ans = json["ans"] as? String else {
                    print("Could not get time from JSON")
                    return
                }
                print(ans)
                self.recieverVCofText.textArea?.text = "";
                self.displayMessgage(tileMsg: "บันทึกวีดีโอ", msg: "ทำการบันทึกวีดีโอเรียบร้อยแล้ว")
                self.recieverVCofText.retrieveDataFromSever();
                self.recieverVCofText.tableView.reloadData()
                UIViewController.removeSpinner(spinner: sv)
                
            case .failure(let error):
                print(error)
            }
        }
    }
 
}

//
// class extension 
//
extension String {
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }
    
    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}


