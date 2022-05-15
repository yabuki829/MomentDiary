//
//  extension.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2022/03/18.
//

import Foundation
import UIKit
extension UIViewController {
    private final class StatusBarView: UIView { }

    func setStatusBarBackgroundColor(_ color: UIColor?) {
        for subView in self.view.subviews where subView is StatusBarView {
            subView.removeFromSuperview()
        }
        guard let color = color else {
            return
        }
        let statusBarView = StatusBarView()
        statusBarView.backgroundColor = color
        self.view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        statusBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        statusBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}

extension UIColor {

       class func cantaloupe() -> UIColor {
           return UIColor(red:255/255, green:204/255, blue:102/255, alpha:1.0)
       }
       class func honeydew() -> UIColor {
           return UIColor(red:204/255, green:255/255, blue:102/255, alpha:1.0)
       }
       class func spindrift() -> UIColor {
           return UIColor(red:102/255, green:255/255, blue:204/255, alpha:1.0)
       }
       class func sky() -> UIColor {
           return UIColor(red:102/255, green:204/255, blue:255/255, alpha:1.0)
       }
       class func lavender() -> UIColor {
           return UIColor(red:204/255, green:102/255, blue:255/255, alpha:1.0)
       }
       class func carnation() -> UIColor {
           return UIColor(red:255/255, green:111/255, blue:207/255, alpha:1.0)
       }
       class func licorice() -> UIColor {
           return UIColor(red:0/255, green:0/255, blue:0/255, alpha:1.0)
       }
       class func snow() -> UIColor {
           return UIColor(red:255/255, green:255/255, blue:255/255, alpha:1.0)
       }
       class func salmon() -> UIColor {
           return UIColor(red:255/255, green:102/255, blue:102/255, alpha:1.0)
       }
       class func banana() -> UIColor {
           return UIColor(red:255/255, green:255/255, blue:102/255, alpha:1.0)
       }
       class func flora() -> UIColor {
           return UIColor(red:102/255, green:255/255, blue:102/255, alpha:1.0)
       }
       class func ice() -> UIColor {
           return UIColor(red:102/255, green:255/255, blue:255/255, alpha:1.0)
       }
       class func orchid() -> UIColor {
           return UIColor(red:102/255, green:102/255, blue:255/255, alpha:1.0)
       }
       class func bubblegum() -> UIColor {
           return UIColor(red:255/255, green:102/255, blue:255/255, alpha:1.0)
       }
       class func lead() -> UIColor {
           return UIColor(red:25/255, green:25/255, blue:25/255, alpha:1.0)
       }
       class func mercury() -> UIColor {
           return UIColor(red:230/255, green:230/255, blue:230/255, alpha:1.0)
       }
       class func tangerine() -> UIColor {
           return UIColor(red:255/255, green:128/255, blue:0/255, alpha:1.0)
       }
       class func lime() -> UIColor {
           return UIColor(red:128/255, green:255/255, blue:0/255, alpha:1.0)
       }
       class func seafoam() -> UIColor {
           return UIColor(red:0/255, green:255/255, blue:128/255, alpha:1.0)
       }
       class func aqua() -> UIColor {
           return UIColor(red:0/255, green:128/255, blue:255/255, alpha:1.0)
       }
       class func grape() -> UIColor {
           return UIColor(red:128/255, green:0/255, blue:255/255, alpha:1.0)
       }
       class func strawberry() -> UIColor {
           return UIColor(red:255/255, green:0/255, blue:128/255, alpha:1.0)
       }
       class func tungsten() -> UIColor {
           return UIColor(red:51/255, green:51/255, blue:51/255, alpha:1.0)
       }
       class func silver() -> UIColor {
           return UIColor(red:204/255, green:204/255, blue:204/255, alpha:1.0)
       }
       class func maraschino() -> UIColor {
           return UIColor(red:255/255, green:0/255, blue:0/255, alpha:1.0)
       }
       class func lemon() -> UIColor {
           return UIColor(red:255/255, green:255/255, blue:0/255, alpha:1.0)
       }
       class func spring() -> UIColor {
           return UIColor(red:0/255, green:255/255, blue:0/255, alpha:1.0)
       }
       class func turquoise() -> UIColor {
           return UIColor(red:0/255, green:255/255, blue:255/255, alpha:1.0)
       }
       class func blueberry() -> UIColor {
           return UIColor(red:0/255, green:0/255, blue:255/255, alpha:1.0)
       }
       class func magenta() -> UIColor {
           return UIColor(red:255/255, green:0/255, blue:255/255, alpha:1.0)
       }
       class func iron() -> UIColor {
           return UIColor(red:76/255, green:76/255, blue:76/255, alpha:1.0)
       }
       class func magnesium() -> UIColor {
           return UIColor(red:179/255, green:179/255, blue:179/255, alpha:1.0)
       }
       class func mocha() -> UIColor {
           return UIColor(red:128/255, green:64/255, blue:0/255, alpha:1.0)
       }
       class func fern() -> UIColor {
           return UIColor(red:64/255, green:128/255, blue:0/255, alpha:1.0)
       }
       class func moss() -> UIColor {
           return UIColor(red:0/255, green:128/255, blue:64/255, alpha:1.0)
       }
       class func ocean() -> UIColor {
           return UIColor(red:0/255, green:64/255, blue:128/255, alpha:1.0)
       }
       class func eggplant() -> UIColor {
           return UIColor(red:64/255, green:0/255, blue:128/255, alpha:1.0)
       }
       class func maroon() -> UIColor {
           return UIColor(red:128/255, green:0/255, blue:64/255, alpha:1.0)
       }
       class func steel() -> UIColor {
           return UIColor(red:102/255, green:102/255, blue:102/255, alpha:1.0)
       }
       class func aluminium() -> UIColor {
           return UIColor(red:153/255, green:153/255, blue:153/255, alpha:1.0)
       }
       class func cayenne() -> UIColor {
           return UIColor(red:128/255, green:0/255, blue:0/255, alpha:1.0)
       }
       class func asparagus() -> UIColor {
           return UIColor(red:128/255, green:120/255, blue:0/255, alpha:1.0)
       }
       class func clover() -> UIColor {
           return UIColor(red:0/255, green:128/255, blue:0/255, alpha:1.0)
       }
       class func teal() -> UIColor {
           return UIColor(red:0/255, green:128/255, blue:128/255, alpha:1.0)
       }
       class func midnight() -> UIColor {
           return UIColor(red:0/255, green:0/255, blue:128/255, alpha:1.0)
       }
       class func plum() -> UIColor {
           return UIColor(red:128/255, green:0/255, blue:128/255, alpha:1.0)
       }
       class func tin() -> UIColor {
           return UIColor(red:127/255, green:127/255, blue:127/255, alpha:1.0)
       }
       class func nickel() -> UIColor {
           return UIColor(red:128/255, green:128/255, blue:128/255, alpha:1.0)
       }
    
}


extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension Encodable {

    var json: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}

extension Decodable {

    static func decode(json data: Data?) -> Self? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Self.self, from: data)
    }
}

extension UserDefaults {

    //コピペ
    //今度精読する。　https://qiita.com/yuki0n0/items/280e351f85c502945d06
    ///
    ///  setCodable ではなく set という関数名にすると、String をセットしたいときに Codable と衝突して Codable 扱いとなってしまうため注意。
    func setCodable(_ value: Codable?, forKey key: String) {
        guard let json: Any = value?.json else { return }
        self.set(json, forKey: key)
        synchronize()
    }

    func codable<T: Codable>(forKey key: String) -> T? {
        let data = self.data(forKey: key)
        let object = T.decode(json: data)
        return object
    }
}



extension Date{
    func covertString() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyy年MM月dd日(eee)"
        let date = formatter.string(from: self)
        return date
    }
    func convert_short() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "HH:mm"
        let date = formatter.string(from:self)
        return date
    }
}


extension UITextField {
    func setUnderLine(color:UIColor) {
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        // 枠線の色
        underline.backgroundColor = color
        addSubview(underline)
        bringSubviewToFront(underline)
    }
}


extension UILabel {

  /// 行数を返す
  func lineNumber() -> Int {
    let oneLineRect  =  "a".boundingRect(
      with: self.bounds.size,
      options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: self.font ?? UIFont()],
      context: nil
    )
    let boundingRect = (self.text ?? "").boundingRect(
      with: self.bounds.size,
      options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: self.font ?? UIFont()],
      context: nil
    )

    return Int(boundingRect.height / oneLineRect.height)
  }

}
