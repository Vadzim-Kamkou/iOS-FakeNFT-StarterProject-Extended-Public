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
    static var bodyBold = Font.system(size: 17, weight: .bold)
    static var body22Bold = Font.system(size: 22, weight: .bold)
    static var medium10 = Font.system(size: 10, weight: .regular)
    static var regular13 = Font.system(size: 13, weight: .regular)
    static var regular15 = Font.system(size: 15, weight: .regular)
}
