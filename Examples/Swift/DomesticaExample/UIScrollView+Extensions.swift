//
//  UIScrollView+Extensions.swift
//  DomesticaExample
//
//  Created by Lacy Rhoades on 6/28/17.
//  Copyright © 2017 Lacy Rhoades. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let maxOffset = self.contentSize
            let bottom = CGRect(x: self.contentOffset.x, y: maxOffset.height - 1.0, width: 1.0, height: 1.0)
            self.scrollRectToVisible(bottom, animated: animated)
        }
    }
    
    func scrollToTop(_ animated: Bool) {
        DispatchQueue.main.async {
            let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
            self.scrollRectToVisible(rect, animated: animated)
        }
    }
}
