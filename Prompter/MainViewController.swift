//
//  MainViewController.swift
//  Prompter
//
//  Created by phatthanaphong on 10/10/17.
//  Copyright © 2017 phatthanaphong. All rights reserved.
//

import UIKit
import SwiftyPlistManager

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
    
    var menuTableView: UITableView!
    
    var fileName:String?
    var collap = false
    var textName:String?
    var userID:Int?
    var menuItem:[String] = ["โหมดในการแสดง promter", "รูปแบบการแสดง prompter", "แบบอักษร", "ขนาดอักษร", "ความเร็วของ prompter", "ระยะระหว่างบรรทัด","รูปแบบ pointer", "ความเร็วของ prompter"]
    var imageName:[String] = ["computer", "circle", "social",  "text",  "gigsaw","computer", "circle", "social"]
    var currentFileName:String?
    
    let topViewColor = UIColor(red: 0, green: 102/255, blue: 102/255, alpha: 1)
    
    override func viewDidLoad() {
        
        if let text = self.textName{
            self.nameLabel.text = text
        }
        super.viewDidLoad()
        self.leftView.layer.borderWidth = 1;
        self.leftView.layer.borderColor = UIColor.lightGray.cgColor
        self.collapseButton.layer.backgroundColor = UIColor.gray.cgColor
        self.settingButton.layer.backgroundColor = UIColor.gray.cgColor
        self.playButton.layer.backgroundColor = UIColor.gray.cgColor
        self.previewButton.layer.backgroundColor = UIColor.gray.cgColor
        self.topView.layer.backgroundColor = self.topViewColor.cgColor
        self.settingButton.layer.cornerRadius = 10;
        self.collapseButton.layer.cornerRadius = 10;
        self.playButton.layer.cornerRadius = 10;
        self.previewButton.layer.cornerRadius = 10;
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
            //self.menuConstrain.constant = self.collap ? 1024 : 784
            //print(self.menuConstrain.constant)
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
            let recieverVC = segue.destination as! TextTableViewController
            recieverVC.userID = self.userID
            recieverVC.textArea = self.textArea
            recieverVC.mainObject = self  // referencing file name of text between the views
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
            self.menuTableView.frame = CGRect(x: x, y:y, width: 320, height: 406)
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
        let popOverVC = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "previewPopup") as! PreviewViewController
        self.addChildViewController(popOverVC)
        popOverVC.previewButton = self.previewButton
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        let currentSting = self.textArea.text as String
        //print("text name is : ",fileName)
        //writing the file to the server
        //try text.write(to: fileURL, atomically: false, encoding: .utf8)
        //let text = "something"
        //print(self.fileName as Any)
        let fn = "\(fileName!)"
        //do{
            //try text.write(to:urlFile, atomically:true, encoding:.utf8)
            //let urlstr = try String(contentsOf: url)
            //print(currentSting)
            self.updateText(filename: fn, text: currentSting)
               
        //} catch let error as Error{
        //    print(currentSting)
            //print("the file cannot be written: \(urlFile)")
         //   print("erros is \(error.localizedDescription)")
        //}
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.menuItem.isEmpty){
            return 0
        }
        return self.menuItem.count
    }
    
    func updateText(filename: String, text:String)->Bool{
        let url = NSURL(string:"http://202.28.34.202/textpreppilot/web/api/updateText.php")
        let request = NSMutableURLRequest(url:url! as URL)
        request.httpMethod = "POST"
        
        let postString = "filename=\(filename)&text=\(text)"
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task =  URLSession.shared.dataTask(with: request as URLRequest) {data,response,error in
            guard error == nil && data != nil else{
                //self.displayMessgage(tileMsg: "Conection Failed", msg: "Cannot connect to the server, please check your connection")
                //print("it works");
                return
        }
        let httpStatus = response as! HTTPURLResponse
            //self.displayMessgage(tileMsg: "Login Failed", msg: "Either Username or Password is empty")
        if httpStatus.statusCode == 200 {
                if data!.count != 0{
                    do{
                        let responseString = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        let errorFlag = responseString["error"] as! Bool
                        
                        if errorFlag == false{
                            //let user = responseString["user"] as! NSDictionary
                            /*
                            DispatchQueue.main.async(execute: {
                                self.username.text = ""
                                self.password.text = ""
                                self.userName = "\(user["name"]!)"//"  \(user["lastname"]!)"
                                self.userID = (user["id"]! as! NSString).integerValue
                                self.performSegue(withIdentifier: "LoggedIn", sender:self)
                                
                            })*/
                            print("write file success")
                            return
                            
                        }
                        else{
                            print(responseString["message"] as! String)
                            /*
                            DispatchQueue.main.async(execute: {
                              
                                self.displayMessgage(tileMsg: "Login Failed", msg: "Invalid Username or Password")
                            })
                            */
                        }
                        
                    }
                    catch _ as NSError{
                        print("Error cannnot get response from the server")
                        //flag = false
                    }
                }
                else{
                    print("No data retrived from the sever")
                    //flag = false
                    
                }
        }
        else{
                print("Error http status code is ",httpStatus.statusCode )
                //flag = false
                return
            }
        }
        
        task.resume()
        
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.menuTableView.dequeueReusableCell(withIdentifier: "menuCell") as UITableViewCell!
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
      print("menu one")
    }
    
}
