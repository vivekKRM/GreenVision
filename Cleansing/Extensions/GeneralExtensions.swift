//
//  GeneralExtensions.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Alamofire
// MARK: Dictionary Extensions

extension Dictionary {
    
    
    func validatedValue(_ key: Key, expected: AnyObject) -> AnyObject {
        
        // checking if in case object is nil
        
        if let object = self[key] as? AnyObject{
            
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber && expected is String {
                
                //logInfo("case we are getting number from server but we want a string from it")
                
                return "\(object)" as AnyObject
            }
                
                // checking if object is of desired class
            else if (object.isKind(of: expected.classForCoder) == false) {
                //logInfo("case // checking if object is of desired class....not")
                
                return expected
            }
                
                // checking if in case object if of string type and we are getting nil inside quotes
            else if object is String {
                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                    //logInfo("null string")
                    return "" as AnyObject
                }
            }
            
            return object
        }
        else {
            
            if expected is String || expected as! String == "" {
                return "" as AnyObject
            }
            
            return expected
        }
    }
    
}



// MARK: UIView Extensions
extension UIView {
   
    func shadow(_ color:UIColor) {
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
    }
    
    func setNormalRoundedShadow(_ color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
    }
    
    func setBorder(_ color:UIColor, borderWidth:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
    
    func vibrate() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.02
        animation.repeatCount = 2
        animation.speed = 0.5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 2.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 2.0, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 5, y: 5)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func setTapperTriangleShape(_ color:UIColor) {
        // Build a triangular path
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0,y: 0))
        path.addLine(to: CGPoint(x: 40,y: 40))
        path.addLine(to: CGPoint(x: 0,y: 100))
        path.addLine(to: CGPoint(x: 0,y: 0))
        
        // Create a CAShapeLayer with this triangular path
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        
        // Mask the view's layer with this shape
        self.layer.mask = mask
        
        self.backgroundColor = color
        
        // Transform the view for tapper shape
       // self.transform = CGAffineTransform(rotationAngle: CGFloat(270) * CGFloat(M_PI_2) / 180.0)
    }
}


// MARK: Int/Float/Double Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Int {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)d" as NSString, self) as String
    }
}

extension Double {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

extension Float {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension Collection where Iterator.Element == [String:Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Avenir-Heavy", size: 15)! , .foregroundColor : [UIColor .black]]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Avenir-Medium", size: 13)!]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)
        
        return self
    }
}

extension Notification.Name {
    static let notificationSocketOnline = Notification.Name("notificationSocketOnline")
    static let notificationRoomConnect = Notification.Name("notificationRoomConnect")
    static let notificationSendMessage = Notification.Name("notificationSendMessage")
    static let notificationSocketTyping = Notification.Name("notificationSocketTyping")
    static let notificationSocketConnected = Notification.Name("notificationSocketConnected")
    static let notificationRecieverAcknowledge = Notification.Name("RecieverAcknowledge")
    static let notificationLocataionSettingUpdated = Notification.Name("locationSettingUpdated")
    static let notificationCheckInUserNotify = Notification.Name("checkInUserListUpdated")
    static let notificationNewMessageCount = Notification.Name("newMessageCount")
    static let notificationResetMessageCount = Notification.Name("resetMessageCount")
}

extension UIApplication {
  static func topViewController(_ base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = (base as? UITabBarController) , let selected = tab.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
extension String {
    
    func numberOfLines() -> Int {
        return self.numberOfOccurrencesOf(string: "\n") + 1
    }
    func numberOfOccurrencesOf(string: String) -> Int {
           return self.components(separatedBy:string).count - 1
       }
}
extension UIViewController{
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        if let url = URL(string: urlString){
        
            let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
            
        dataTask.resume()
    }
    }
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
//            self.openWifiSettings()
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    func showAlertImage(withTitle title: String, withMessage message:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default,handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.dismiss(animated: true)
            })
        let imgTitle = UIImage(named:"remove-1")
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgViewTitle.image = imgTitle

        alert.view.addSubview(imgViewTitle)
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    func openWifiSettings() {
        print("Opening Wi-Fi settings.")

        let shared = UIApplication.shared
        let url = URL(string: UIApplication.openSettingsURLString)!

        if #available(iOS 10.0, *) {
            shared.open(url)
        } else {
            shared.openURL(url)
        }
    }
    
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["1.0"] as? String,
            let identifier = info["com.LiveNutrifit"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            return version != currentVersion
        }
        throw VersionError.invalidResponse
    }
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
    
}
extension UIViewController
{
    func getImageFromURL(imageView: UIImageView , stringURL: String) {
    self.fetchImage(from: stringURL ) { (imageData) in
    if let data = imageData {
        DispatchQueue.main.async {
            imageView.image = UIImage(data: data)
        }
    } else {
            // show as an alert if you want to
        print("Error loading image");
    }
    }
    }
}
extension String {
    func before(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let before = prefix(upTo: index)
            return String(before)
        }
        return ""
    }
    
    func after(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let after = suffix(from: index).dropFirst()
            return String(after)
        }
        return ""
    }
}
extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}

class CustomAnnotation: MKPointAnnotation {
    var image: UIImage?

    override init() {
        super.init()
    }
}
class PasswordTextField: UITextField {
    private let eyeButton = UIButton(type: .custom)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Configure the text field properties
        isSecureTextEntry = true
        borderStyle = .roundedRect
        
        // Configure the eye button
        eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal) // Replace "eye_open" with your open eye icon image
        eyeButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected) // Replace "eye_closed" with your closed eye ic
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // Adjust the frame as needed
        eyeButton.contentMode = .scaleAspectFit
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        rightView = eyeButton
        rightViewMode = .always
    }
    
    // MARK: - Actions
    
    @objc private func eyeButtonTapped() {
        isSecureTextEntry.toggle()
        eyeButton.isSelected = !isSecureTextEntry
    }
}

class CustomPointAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage? // Custom image for the annotation
    
    init(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
