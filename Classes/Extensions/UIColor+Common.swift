//
//  UIColor+Common.swift
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    convenience init?(hexaARGB: String) {
            var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
            switch chars.count {
            case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
            case 6: chars.append(contentsOf: ["F","F"])
            case 8: break
            default: return nil
            }
            self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                    green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                     blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                    alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
        }
}
