//
//  DisplayViewController.swift
//  Prompter
//
//  Created by Phatthanaphong on 13/7/2561 BE.
//  Copyright © 2561 phatthanaphong. All rights reserved.
//

import UIKit
import DLRadioButton
import SwiftyPlistManager

class DisplayOptionViewController: UIViewController {

    
    @IBOutlet var label: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var opt1: DLRadioButton!
    @IBOutlet weak var opt2: DLRadioButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.layer.cornerRadius = 7.0
        self.closeBtn.layer.cornerRadius = 10.0
        
        guard let display  = SwiftyPlistManager.shared.fetchValue(for: "display", fromPlistWithName: "Data") else { return }
        if(display as! String == "1"){
            self.opt1.isSelected = true
        }
        else{
            self.opt2.isSelected = true
        }
        
        
        showAnimate()
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doClose(_ sender: Any) {
        removeAnimate()
        //self.willMove(toParentViewController: nil)
        //self.view.removeFromSuperview()
        //self.removeFromParentViewController()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.view.alpha = 1
        UIView.animate(withDuration: 0.45, animations: {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.45, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.view.alpha = 0.95
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        })
    }
    
    @IBAction func doOption1(_ sender: Any) {
        SwiftyPlistManager.shared.save("1", forKey: "display", toPlistWithName: "Data") { (err) in
            if err == nil {
               
            }
        }
        
    }
    
    @IBAction func doOption2(_ sender: Any) {
        SwiftyPlistManager.shared.save("2", forKey: "display", toPlistWithName: "Data") { (err) in
            if err == nil {
               
            }
        }
    }
    
}
