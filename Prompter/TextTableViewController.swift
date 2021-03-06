//
//  TextTableViewController.swift
//  Prompter
//
//  Created by phatthanaphong on 10/11/17.
//  Copyright © 2017 phatthanaphong. All rights reserved.
//

import UIKit
import SwiftyPlistManager
import SWXMLHash

class Item {
    var sentence = "";
    var tag = "";
}

extension String {
    // charAt(at:) returns a character at an integer (zero-based) position.
    // example:
    // let str = "hello"
    // var second = str.charAt(at: 1)
    //  -> "e"
    func charAt(at: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: at)
        return self[charIndex]
    }
}

class TextTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    
    var userID:Int?
    var fileNameList = [String]()
    var textArea:UITextView?
    var textData:NSDictionary?
    var titleText = [String]()
    var detailText = [String]()
    var xmlText = [String]()
    var mainObject: MainViewController?
    var initURLText = String()
    var xmlString = String()
    var timeList = [String()]
    var textId = [String()]
    var saveBtn:UIButton!
    var currentTextId = String()
    var currentXml:String?
    
    @IBOutlet weak var unrecorded: UIButton!
    @IBOutlet weak var recorded: UIButton!
    @IBOutlet weak var all: UIButton!
    //@IBOutlet weak var deleteButton: UIButton!
    //@IBOutlet weak var addButton: UIButton!
    
    
    let buttonColor = UIColor(red: 0, green: 102/255, blue: 102/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.unrecorded.backgroundColor = self.buttonColor
        self.unrecorded.layer.cornerRadius = 10
        self.recorded.layer.cornerRadius = 10
        self.all.layer.cornerRadius = 10
  
        
        guard let loadURL = SwiftyPlistManager.shared.fetchValue(for: "initURL", fromPlistWithName: "Data") else { return }
        self.initURLText = loadURL as! String
    
        retrieveDataFromSever()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveDataFromSever(){
        
        self.titleText.removeAll()
        self.detailText.removeAll()
        self.fileNameList.removeAll()
        self.xmlText.removeAll()
        self.textId.removeAll()
        //self.tableView.reloadData()
        
        let url = NSURL(string:self.initURLText.trimmingCharacters(in: .whitespacesAndNewlines)+":8080/iosgetText.php")
        let request = NSMutableURLRequest(url:url! as URL)
        request.httpMethod = "POST"
        let postString = "userid=\(self.userID!)"
        //print("this is the posting string : \(postString)")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task =  URLSession.shared.dataTask(with: request as URLRequest) {data,response,error in
            guard error == nil && data != nil else{
                self.displayMessgage(tileMsg: "Conection Failed", msg: "Cannot connect to the server, please check your connection")
                return
            }
            
            let httpStatus = response as! HTTPURLResponse
            if httpStatus.statusCode == 200 {
                if data!.count != 0{
                    do{
                        let responseString = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        let errorFlag = responseString["error"] as! Bool
                        
                        if errorFlag == false{
                            DispatchQueue.main.async(execute: {
                                self.textData = responseString
                                for (key, value) in self.textData!{
                                    if key as! String == "error"{
                                        continue
                                    }
                                    
                                    let d = value as! NSDictionary
                                    //let status = d["t_status"] as! String
                                    //if(status == "0"){
                                    self.titleText.append(d["t_topic"]! as! String)
                                    self.detailText.append(d["t_detail"]! as! String)
                                    self.fileNameList.append(d["t_text"]! as! String)
                                    self.xmlText.append(d["t_xml"]! as! String)
                                    self.textId.append(d["t_id"]! as! String)
                                    self.displayUnrecored()
                                }
                                
                            })
                            
                        }
                        else{
                            print(responseString["message"] as! String)
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
            }
        }
        task.resume()
    }
    
    func  displayMessgage(tileMsg:String, msg:String){
        let alert = UIAlertController(title: tileMsg, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTextData"{
            let recieverVC = segue.destination as! TextTableViewController
            recieverVC.userID = self.userID
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.titleText.isEmpty){
            return 0
        }
        return self.titleText.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell.textLabel?.text = self.titleText[indexPath.row]
        cell.detailTextLabel?.text = self.detailText[indexPath.row]
        return cell
    }

    @IBAction func unrecordedTapped(_ sender: Any) {
        displayUnrecored()
    }
    
    func displayUnrecored(){
        self.saveBtn.isEnabled = true
        self.unrecorded.backgroundColor = self.buttonColor
        self.recorded.backgroundColor = UIColor.darkGray
        self.all.backgroundColor = UIColor.darkGray
        DispatchQueue.main.async(execute: {
            self.titleText.removeAll()
            self.detailText.removeAll()
            self.fileNameList.removeAll()
            self.xmlText.removeAll()
            self.textId.removeAll()
            
            for (key, value) in self.textData!{
                if key as! String == "error"{
                    continue
                }
                
                let d = value as! NSDictionary
                
                if(d["t_status"] as! String == "0"){
                    self.titleText.append(d["t_topic"]! as! String)
                    self.detailText.append(d["t_detail"]! as! String)
                    self.fileNameList.append(d["t_text"]! as! String)
                    self.xmlText.append(d["t_xml"]! as! String)
                    self.textId.append(d["t_id"]! as! String)
                }
            }
            self.tableView.reloadData()
            
        })
    }
    
    @IBAction func recordedTapped(_ sender: Any) {
        self.saveBtn.isEnabled = false
        self.unrecorded.backgroundColor = UIColor.darkGray
        self.recorded.backgroundColor = self.buttonColor
        self.all.backgroundColor = UIColor.darkGray
        DispatchQueue.main.async(execute: {
            self.titleText.removeAll()
            self.detailText.removeAll()
            self.fileNameList.removeAll()
            self.xmlText.removeAll()
            self.textId.removeAll()
            
            for (key, value) in self.textData!{
                if key as! String == "error"{
                    continue
                }
                let d = value as! NSDictionary

                if(d["t_status"] as! String == "1"){
                    self.titleText.append(d["t_topic"]! as! String)
                    self.detailText.append(d["t_detail"]! as! String)
                    self.fileNameList.append(d["t_text"]! as! String)
                    self.xmlText.append(d["t_xml"]! as! String)
                    self.textId.append(d["t_id"]! as! String)
                }
            }
            self.tableView.reloadData()
            
        })
    }
    @IBAction func allTapped(_ sender: Any) {
        self.saveBtn.isEnabled = false
        self.unrecorded.backgroundColor = UIColor.darkGray
        self.recorded.backgroundColor = UIColor.darkGray
        self.all.backgroundColor = self.buttonColor
        DispatchQueue.main.async(execute: {
            self.titleText.removeAll()
            self.detailText.removeAll()
            self.fileNameList.removeAll()
            self.xmlText.removeAll()
            self.textId.removeAll()
            
            for (key, value) in self.textData!{
                if key as! String == "error"{
                    continue
                }
                
                let d = value as! NSDictionary
                self.titleText.append(d["t_topic"]! as! String)
                self.detailText.append(d["t_detail"]! as! String)
                self.fileNameList.append(d["t_text"]! as! String)
                self.xmlText.append(d["t_xml"]! as! String)
                self.textId.append(d["t_id"]! as! String)
                self.tableView.reloadData()
                
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row

        getTextFromServer(filename: xmlText[row])
        self.currentTextId = self.textId[indexPath.row]
        self.currentXml = self.xmlText[indexPath.row]
        /*
        SwiftyPlistManager.shared.save(self.textId[indexPath.row], forKey: "textID", toPlistWithName: "Data") { (err) in
            if err == nil {
                //print("update the url in the plist.")
            }
        }
        */
    }
    
    // tap each of item in the table list
    func getTextFromServer(filename:String){
        self.mainObject?.fileName = filename
        if let url = URL(string: self.initURLText.trimmingCharacters(in: .whitespacesAndNewlines)+":8080/xmldata/\(filename)") {
            do {
                let contents = try String(contentsOf: url)
                let xmlList = parseXML(xmlString: contents)
                //print(timeList.count)
                textArea?.text = xmlList
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
    }
    
    func parseXML(xmlString:String)->String {
        self.timeList.removeAll()
        var xmlList = String()
        let xml = SWXMLHash.config {
            config in
            config.shouldProcessLazily = true
            }.parse(xmlString)
        //print(xml["xml"]["text"]["data"][0]["sentence"].element?.text)
        for elem in xml["xml"]["text"]["data"].all {
            let s = (elem["sentence"].element?.text) as! String
            var st1 = ""
            var st2 = ""
            var flag = true
            for c in s{
                if(c == "["){
                    flag = false
                }
                if(flag){
                    st1.append(c)
                }
                else{
                    if(c != "[" && c != "]" && String(c).isNumber){
                        st2.append(c)
                    }
                }
            }
            self.timeList.append(st2)
            xmlList.append(st1+"\n\n")
        }
        return xmlList

    }
}

extension String {
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil
    }
    
    func isCompose(of thaiWord:String) -> Bool {
        return self.range(of: thaiWord, options: .literal) != nil ? true : false
    }
}



