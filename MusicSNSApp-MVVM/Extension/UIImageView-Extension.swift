//
//  UIImageView-Extension.swift
//  MusicSNSApp-MVVM
//
//  Created by 近藤米功 on 2022/10/07.
//

import Foundation
import UIKit

extension UIImageView {

    func circle() {
        layer.masksToBounds = false
        layer.cornerRadius = frame.width/2
        clipsToBounds = true
    }
}
