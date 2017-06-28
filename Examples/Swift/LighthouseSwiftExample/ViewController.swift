//
//  ViewController.swift
//  LighthouseSwiftExample
//
//  Created by Lacy Rhoades on 6/28/17.
//  Copyright © 2017 Lacy Rhoades. All rights reserved.
//

import UIKit
import Lighthouse

class ViewController: UIViewController {

    private var textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "Lighthouse – A discoverability layer for Swift and Node.js"
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        
        let views = ["textView": textView]
        let metrics = ["margin": 24]
        
        var constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(margin)-[textView]-(margin)-|",
            options: [],
            metrics: metrics,
            views: views
        )
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(margin)-[textView]-(margin)-|",
            options: [],
            metrics: metrics,
            views: views
        ))
        self.view.addConstraints(constraints)
    }
    
    func log(_ text: String) {
        DispatchQueue.main.async {
            self.textView.text = self.textView.text.appending("\n").appending(text)
        }
    }

}

extension ViewController: LighthouseListener {
    func lighthouseFoundHost(withAddress address: String, andInfo info: String) {
        self.log(
            String(format: "%@: %@", address, info)
        )
    }
}

extension ViewController: LighthouseLoggingDelegate {
    func logFromLighthouse(_ message: String) {
        self.log(message)
    }
}
