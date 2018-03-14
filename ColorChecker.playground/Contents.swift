// Authors: Roger Prats, Carlos Butron
// http://chir.ag/projects/name-that-color/

import UIKit

public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

// MARK: - From UIColor to String

extension UIColor {
    
    // MARK: - Initialization
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.characters.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
}

public extension EnumCollection {
    
    public static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var allValues: [Self] {
        return Array(self.cases())
    }
}

enum ThemeColor: Int, EnumCollection {
    
    case `default`, white, alabaster, dustyGray, mineShaft, doveGray, athens_gray, azureRadiance, blueRibbon, black, scarlet
    
    //MARK: - Colors
    
    var BSColor: UIColor {
        switch self {
        case .default:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .alabaster:
            return #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        case .athens_gray:
            return #colorLiteral(red: 0.9372286201, green: 0.9372760653, blue: 0.9586432576, alpha: 1)
        case .dustyGray:
            return #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        case .mineShaft:
            return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .doveGray:
            return #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        case .azureRadiance:
            return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case .blueRibbon:
            return #colorLiteral(red: 0, green: 0.4274509804, blue: 1, alpha: 1)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .scarlet:
            return #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
        }
    }
}

for color in ThemeColor.cases() {
    if #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1) == color.BSColor {
        print(color)
    }
}

print(#colorLiteral(red: 0.3999532461, green: 0.4000268579, blue: 0.3999486566, alpha: 1) .toHex() ?? "")

