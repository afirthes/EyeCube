//
//  ViewController.swift
//  EyeCube
//
//  Created by Afir Thes on 12.10.2022.
//

import UIKit

class ViewController: UIViewController {

    var timer: Timer!
    var angle: CGFloat = 0

    @IBOutlet weak var drawingView: View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func angleChanged(_ sender: UISlider) {
        
        drawingView.fTheta = CGFloat(sender.value).degreesToRadians
        drawingView.setup()
        //print(sender.value)
    }
    
    @objc func fireTimer() {
        angle += 3
        
        if angle > 3600 {
            angle = angle - 3600
        }
        
        drawingView.fTheta = angle.degreesToRadians
        drawingView.setup()
    }
}

