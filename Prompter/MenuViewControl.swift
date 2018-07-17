//
//  MenuViewControl.swift
//  Prompter
//
//  Created by Phatthanaphong on 10/3/2561 BE.
//  Copyright © 2561 phatthanaphong. All rights reserved.
//

import UIKit
import SwiftyPlistManager

class MenuViewControl: UIViewController {

    @IBOutlet weak var fontSize: UISlider!
    @IBOutlet weak var textSpeed: UISlider!
    @IBOutlet weak var mainPanel: UIView!
    
    @IBOutlet weak var valueSize: UILabel!
    @IBOutlet weak var valueSpeed: UILabel!
    
    @IBOutlet weak var sizeVal: UILabel!
    @IBOutlet weak var fontVal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainPanel.layer.cornerRadius = 10.0
        
        guard let size  = SwiftyPlistManager.shared.fetchValue(for: "size", fromPlistWithName: "Data") else { return }
        guard let speed  = SwiftyPlistManager.shared.fetchValue(for: "speed", fromPlistWithName: "Data") else { return }
        
        self.fontSize.setValue(Float(size as! String)!, animated: true)
        self.textSpeed.setValue(Float(speed as! String)!, animated: true)
        
        self.valueSize.text =   String(format: "%.0f", Float(size as! String)!)
        self.valueSpeed.text =  String(format: "%.01f", Float(speed as! String)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getFont(_ sender: Any) {
        SwiftyPlistManager.shared.save(String(self.fontSize.value), forKey: "size", toPlistWithName: "Data") { (err) in
            if err == nil {
                //print("Value successfully saved into plist.")
            }
        }
         self.valueSize.text =   String(format: "%.0f", self.fontSize.value)
    }
    
    @IBAction func getSpeed(_ sender: Any) {
        SwiftyPlistManager.shared.save(String(self.textSpeed.value), forKey: "speed", toPlistWithName: "Data") { (err) in
            if err == nil {
                //print("Value successfully saved into plist.")
            }
        }
         self.valueSpeed.text = String(format: "%.01f", self.textSpeed.value)
    }
    
    
    @IBAction func doClose(_ sender: Any) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
