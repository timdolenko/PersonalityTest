import UIKit

public enum Font: String, CaseIterable {
    case avenirNextBold = "AvenirNext-Bold"
    case avenirNext = "AvenirNext-Regular"
}

public extension Font {
    func ofSize(_ size: CGFloat) -> UIFont {
        UIFont.init(name: self.rawValue, size: size)!
    }
}

public extension UIFont {
    class func avenirOfSize(_ size: CGFloat) -> UIFont {
        Font.avenirNext.ofSize(size)
    }
    class func avenirBoldOfSize(_ size: CGFloat) -> UIFont {
        Font.avenirNextBold.ofSize(size)
    }
}

