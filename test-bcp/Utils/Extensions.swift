//
//  Extensions.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import Foundation
import Alamofire
import UIKit

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func formatToDoubleTwoDecimals() -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en-US")
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.roundingMode = .halfDown
        return numberFormatter.number(from: String(self))?.doubleValue ?? 0.0
    }
    
    func toString(decimal: Int = 9) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
}
// MARK: - UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}

// MARK: - UIView
extension UIView {
    // MARK: - Inspectables
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat, shadow: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.015) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            
            if shadow {
                let shadowView: UIView = UIView()
                shadowView.backgroundColor = self.backgroundColor
                shadowView.layer.cornerRadius = radius
                shadowView.layer.shadowColor = UIColor.black.cgColor
                shadowView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
                shadowView.layer.shadowOpacity = 0.5
                shadowView.layer.shadowRadius = 5
                self.superview?.insertSubview(shadowView, belowSubview: self)
                shadowView.frame = self.frame
            }
        }
    }
}

func setFont(of type: FontTypes, and size: CGFloat) -> UIFont {
    var fontName = "Metropolis-"
    switch type {
    case .black:
        fontName += "Black"
    case .bold:
        fontName += "Bold"
    case .extraBold:
        fontName += "ExtraBold"
    case .semiBoldItalic:
        fontName += "SemiBoldItalic"
    case .extraLight:
        fontName += "ExtraLigh"
    case .light:
        fontName += "Light"
    case .medium:
        fontName += "Medium"
    case .regular:
        fontName += "Regular"
    case .semibold:
        fontName += "Semibold"
    case .thin:
        fontName += "Thin"
    case .icon:
        fontName = "Font Awesome 5 Free"
    }
    
    let font = UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}

// MARK: - Fonts
enum FontTypes {
    case black
    case bold
    case semiBoldItalic
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semibold
    case thin
    case icon
}
