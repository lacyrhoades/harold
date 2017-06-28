//
//  ViewController.swift
//  DomesticaExample
//
//  Created by Lacy Rhoades on 6/28/17.
//  Copyright © 2017 Lacy Rhoades. All rights reserved.
//

import UIKit
import Domestica

class ViewController: UIViewController {

    var textView = UITextView()
    
    var bgColor: UIColor = .white {
        didSet {
            DispatchQueue.main.async {
                self.textView.backgroundColor = self.bgColor
            }
        }
    }
    
    var textColor: UIColor = .white {
        didSet {
            DispatchQueue.main.async {
                self.textView.textColor = self.textColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size: CGFloat = UI_USER_INTERFACE_IDIOM() == .pad ? 28.0 : 15.0
        textView.font = UIFont.systemFont(ofSize: size)
        textView.text = "Domestica – A discoverability layer for Swift and Node.js"
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
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
        self.textView.scrollToBottom(animated: true)
    }

}

extension ViewController: DomesticaListener {
    func domesticaReceived(fromHost host: String, message: String) {
        if message.contains("tapDown") {
            self.bgColor = .blue
            self.textColor = .white
        } else if message.contains("tapUp") {
            self.bgColor = .white
            self.textColor = .darkGray
        }
        self.log(
            String(format: "%@: %@", host, message)
        )
    }
}

extension ViewController: DomesticaLoggingDelegate {
    func logFromDomestica(_ message: String) {
        self.log(message)
    }
}
