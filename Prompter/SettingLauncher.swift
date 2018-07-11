//
//  SettingLauncher.swift
//  Prompter
//
//  Created by phatthanaphong on 10/11/17.
//  Copyright © 2017 phatthanaphong. All rights reserved.
//

import Foundation
import UIKit

class SettinLauncher : NSObject{
    
    let blackView = UIView()
    /*
    func showSettingLauncher(){
        let if window = UIApplication.shared{
            blackView.backgroundColor = UIColor(white:0, alpha : 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 1
            })
        }
    }
 */
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
        })
    }
    
    override init(){
        super.init()
        
    }
}
