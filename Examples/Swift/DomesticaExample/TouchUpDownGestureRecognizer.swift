//
//  CustomGestures.swift
//  DomesticaExample
//
//  Created by Lacy Rhoades on 6/28/17.
//  Copyright © 2017 Lacy Rhoades. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class TouchDownGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .recognized
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
}

class TouchUpGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .possible
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .possible
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .recognized
    }
}
