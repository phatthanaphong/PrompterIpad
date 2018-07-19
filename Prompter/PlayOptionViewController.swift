//
//  PlayOptionViewController.swift
//  Prompter
//
//  Created by Phatthanaphong on 13/7/2561 BE.
//  Copyright © 2561 phatthanaphong. All rights reserved.
//

import UIKit
import DLRadioButton
import SwiftyPlistManager


class PlayOptionViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var lineOption: DLRadioButton!
    @IBOutlet weak var boxOption: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        self.mainView.layer.cornerRadius = 7.0
        self.closeBtn.layer.cornerRadius = 10.0
        
        guard let display  = SwiftyPlistManager.shared.fetchValue(for: "play", fromPlistWithName: "Data") else { return }
        if(display as! String == "1"){
            self.lineOption.isSelected = true
        }
        else{
            self.boxOption.isSelected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doLineOption(_ sender: Any) {
        SwiftyPlistManager.shared.save("1", forKey: "play", toPlistWithName: "Data") { (err) in
            if err == nil {
                
            }
        }
    }
    
    @IBAction func doBoxOption(_ sender: Any) {
        SwiftyPlistManager.shared.save("2", forKey: "play", toPlistWithName: "Data") { (err) in
            if err == nil {
                
            }
        }
    }
    
    @IBAction func doClose(_ sender: Any) {
         removeAnimate()
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

}
