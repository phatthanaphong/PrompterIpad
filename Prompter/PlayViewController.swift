//
//  PlayViewController.swift
//  Prompter
//
//  Created by Phatthanaphong on 11/3/2561 BE.
//  Copyright © 2561 phatthanaphong. All rights reserved.
//

import UIKit
import SwiftyPlistManager

class PlayViewController: UIViewController {

    var currentText = String()
    var delay = Float()
    var pause = false
    var size = CGFloat()
    var display = String()
    var play = String()
    var textColor = UIColor()
    var bgColor = UIColor()
    var playButton = UIButton()
    @IBOutlet weak var closeBtn: UIButton!
    
    func getSetting(){
        //getting the information from the plist
        guard let size   = SwiftyPlistManager.shared.fetchValue(for: "size", fromPlistWithName: "Data") else { return }
        guard let speed  = SwiftyPlistManager.shared.fetchValue(for: "speed", fromPlistWithName: "Data") else { return }
        guard let display  = SwiftyPlistManager.shared.fetchValue(for: "display", fromPlistWithName: "Data") else { return }
        guard let play  = SwiftyPlistManager.shared.fetchValue(for: "play", fromPlistWithName: "Data") else { return }
        
        self.delay = Float(speed as! String)!
        self.size  = CGFloat(Float(size as! String)!)
        
        self.display = display as!String
        self.play = play as! String
    }
    
    override func viewDidLoad() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view.addGestureRecognizer(gesture)
        
        showAnimate()
        getSetting()
        
        if (self.display == "1"){
            closeBtn.setTitleColor(UIColor.white, for: .normal)
            self.textColor = UIColor.white
            self.bgColor = UIColor.black
            self.view.backgroundColor = UIColor.black
        }
        else{
            closeBtn.setTitleColor(UIColor.black, for: .normal)
            self.textColor = UIColor.black
            self.bgColor = UIColor.white
            self.view.backgroundColor = UIColor.white
        }
        
        if(self.play == "1"){
            
            let renderer = UIGraphicsImageRenderer(bounds: CGRect(x:0, y:-100, width:990, height:4024))
            let img = renderer.image { ctx in
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Thin", size: self.size)!,
                             NSAttributedStringKey.paragraphStyle: paragraphStyle,
                             NSAttributedStringKey.foregroundColor: self.textColor]
                
                let string = currentText
                string.draw(with: CGRect(x: 0, y: 300, width: 990, height: 4024), options: [.usesLineFragmentOrigin], attributes: attrs, context: nil)
                
            }
            let imageView = UIImageView(image: img)
            imageView.backgroundColor = self.bgColor
            imageView.alpha = 1
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.view.addSubview(imageView)
            
            UIView.animate(withDuration: (10-TimeInterval(self.delay))*80, delay: 5, options: [.curveLinear], animations: {
                imageView.frame = CGRect(x:0, y:-4000, width:990, height:4024)},
                           completion: nil)
            self.view.layoutIfNeeded()
        }
        else{
            
            let renderer = UIGraphicsImageRenderer(bounds: CGRect(x:0, y: 0, width:990, height:4024))
            let img = renderer.image { ctx in
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Thin", size: self.size)!,
                             NSAttributedStringKey.paragraphStyle: paragraphStyle,
                             NSAttributedStringKey.foregroundColor: self.textColor]
                
                let string = currentText
                string.draw(with: CGRect(x: 0, y: 800, width: 990, height: 4024), options: [.usesLineFragmentOrigin], attributes: attrs, context: nil)
                
            }
            let imageView = UIImageView(image: img)
            imageView.backgroundColor = self.bgColor
            imageView.alpha = 1
            self.view.addSubview(imageView)
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            UIView.animate(withDuration: 20, delay: 0.0, options: [.curveLinear], animations: {
                imageView.frame = CGRect(x:0, y:-4024, width:990, height:4024)},
                           completion: nil)
            self.view.layoutIfNeeded()
            startTimer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if(self.play == "2"){
            let pausedTime: CFTimeInterval =  self.view.layer.timeOffset
            self.view.layer.speed = 1.0
            self.view.layer.timeOffset = 0.0
            self.view.layer.beginTime = 0.0
            let timeSincePause: CFTimeInterval =  self.view.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            self.view.layer.beginTime = timeSincePause
        }

        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {

        if(self.play == "1"){
            let layer = self.view.layer
            pause = !pause
            if pause {
                pauseLayer(layer: layer)
            } else {
                resumeLayer(layer: layer)
            }
        }
        else{
            let layer = self.view.layer
            resumeLayer(layer: layer)
            startTimer()
        }
    }
    
    @IBAction func doClose(_ sender: Any) {
        self.playButton.layer.backgroundColor = UIColor.gray.cgColor
        removeAnimate()
        //self.willMove(toParentViewController: nil)
        //self.view.removeFromSuperview()
        //self.removeFromParentViewController()
        
    }
    
    weak var timer: Timer?
    
    func startTimer() {
        timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 3.9, repeats: true) { [weak self] _ in
            let layer = self?.view.layer
            self?.pauseLayer(layer: layer!)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    deinit {
        stopTimer()
    }
    
}
