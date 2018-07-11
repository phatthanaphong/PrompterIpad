//
//  ViewController.swift
//  Prompter
//
//  Created by phatthanaphong on 10/10/17.
//  Copyright © 2017 phatthanaphong. All rights reserved.
//

import UIKit
import SwiftyPlistManager

class ViewController: UIViewController {

   
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var userName:String = ""
    var userID:Int?
    var initURLText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPlist()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let uName = username.text
        let pWord = password.text
        
        if (uName?.isEmpty)! || (pWord?.isEmpty)!{
            self.displayMessgage(tileMsg: "Login Failed", msg: "Either Username or Password is empty")
            return
        }
        
        self.getFromJSonLogin(username: uName!, password: pWord!, presentigViewController: self)
    }
    
    func getFromJSonLogin(username:String, password:String, presentigViewController:UIViewController){
        let url = NSURL(string:self.initURLText+":8080/ioslogin.php")
        let request = NSMutableURLRequest(url:url! as URL)
        request.httpMethod = "POST"

        let postString = "username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task =  URLSession.shared.dataTask(with: request as URLRequest) {data,response,error in
            guard error == nil && data != nil else{
                self.displayMessgage(tileMsg: "Conection Failed", msg: "Cannot connect to the server, please check your connection")
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
                           
                            let user = responseString["user"] as! NSDictionary
                            
                            DispatchQueue.main.async(execute: {
                                self.username.text = ""
                                self.password.text = ""
                                self.userName = "\(user["name"]!)"//"  \(user["lastname"]!)"
                                self.userID = (user["id"]! as! NSString).integerValue
                                self.performSegue(withIdentifier: "LoggedIn", sender:self)
                                
                            })
                        }
                        else{
                            print(responseString["message"] as! String)
                            
                            DispatchQueue.main.async(execute: {
                                self.username.text = ""
                                self.password.text = ""
                                self.displayMessgage(tileMsg: "Login Failed", msg: "Invalid Username or Password")
                            })
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
        let recieverVC = segue.destination as! MainViewController
        recieverVC.textName = self.userName
        recieverVC.userID = self.userID
    }
    
    func checkPlist(){
        let url = URL(string:"http://202.28.34.202/TextPrepPilot/config.txt")!
        let task = URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error!)
            }
            else {
                if let textFile = String(data: data!, encoding: .utf8) {
                    let text = textFile
                    let textArr = text.components(separatedBy: "\n");
                    self.initURLText = textArr[0]
                    self.initURLText = "http://10.10.10.117"
                    
                }
                
                guard let fetchedValue = SwiftyPlistManager.shared.fetchValue(for: "initURL", fromPlistWithName: "Data")
                    else {
                        //load the data from the server and write it to the data plist
                        //write to the plist
                        SwiftyPlistManager.shared.addNew(self.initURLText, key:"initURL" , toPlistWithName: "Data") { (err) in
                            if err == nil {
                                print("Value successfully added into plist.")
                            }
                        }
                        
                        return
                };
                
                guard let initText  = SwiftyPlistManager.shared.fetchValue(for: "initURL", fromPlistWithName: "Data") else { return }
                
                
                
                if(self.initURLText.compare(initText as! String).rawValue != 0){
                    
                    SwiftyPlistManager.shared.save(self.initURLText, forKey: "initURL", toPlistWithName: "Data") { (err) in
                        if err == nil {
                            print("Value successfully saved into plist.")
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
}
