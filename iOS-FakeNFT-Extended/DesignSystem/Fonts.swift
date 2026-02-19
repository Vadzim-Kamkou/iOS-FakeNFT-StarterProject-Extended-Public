import UIKit
import SwiftUI

extension UIFont {
    // Ниже приведены примеры шрифтов, настоящие шрифты надо взять из фигмы

    // Headline Fonts
    static var headline1 = UIFont.systemFont(ofSize: 34, weight: .bold)
    static var headline2 = UIFont.systemFont(ofSize: 28, weight: .bold)
    static var headline3 = UIFont.systemFont(ofSize: 22, weight: .bold)
    static var headline4 = UIFont.systemFont(ofSize: 20, weight: .bold)

    // Body Fonts
    static var bodyRegular = UIFont.systemFont(ofSize: 17, weight: .regular)
    static var bodyBold = UIFont.systemFont(ofSize: 17, weight: .bold)

    // Caption Fonts
    static var caption1 = UIFont.systemFont(ofSize: 15, weight: .regular)
    static var caption2 = UIFont.systemFont(ofSize: 13, weight: .regular)
}

extension Font {
    static let headline1 = Font(UIFont.headline1)
    static let headline2 = Font(UIFont.headline2)
    static let headline3 = Font(UIFont.headline3)
    static let headline4 = Font(UIFont.headline4)

    static let bodyRegular = Font(UIFont.bodyRegular)
    static let bodyBold = Font(UIFont.bodyBold)

    static let caption1 = Font(UIFont.caption1)
    static let caption2 = Font(UIFont.caption2)
}
