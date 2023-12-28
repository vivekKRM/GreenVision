//
//  Extensions.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import Foundation
import UIKit

let overcastBlueColor = UIColor(red: 127/255, green: 195/255, blue: 70/255, alpha: 1.0)
let blueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 0.5)
let tableviewbackground = UIColor(red: 242/255, green: 241/255, blue: 246/255, alpha: 1.0)

extension String
{
    func validpassword(mypassword : String) -> Bool
    {
        
        let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: mypassword)
    }
}
extension UIViewController{
    
    //    func changeAll(_ textfield: SkyFloatingLabelTextField)
    //    {
    //        textfield.tintColor = overcastBlueColor
    //        textfield.textColor = .darkGray
    //        textfield.lineColor = .lightGray
    //        textfield.titleFont = UIFont.systemFont(ofSize: 9)
    //        textfield.selectedTitleColor =  overcastBlueColor//UIColor(red: 87/255, green: 206/255, blue: 214/255, alpha: 1.0)
    //        textfield.selectedLineColor = .lightGray
    //        textfield.lineHeight = 1.0 // bottom line height in points
    //        textfield.selectedLineHeight = 1.0
    //    }
    
}
extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
}

func addCornerRadius(UIview: [UIView])
{
    for view in UIview{
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
    }
}

func AddShadow(button: UIButton){
    button.layer.shadowColor = UIColor.lightGray.cgColor
    button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    button.layer.shadowOpacity = 1.0
    button.layer.shadowRadius = 0.0
    button.layer.masksToBounds = false
    button.layer.cornerRadius = button.frame.size.height/2
}
func AddShadow10(button: UIButton){
    button.layer.shadowColor = UIColor.lightGray.cgColor
    button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    button.layer.shadowOpacity = 1.0
    button.layer.shadowRadius = 0.0
    button.layer.masksToBounds = false
    button.layer.cornerRadius = 10
}

func addBlackBorder(to textField: UITextField) {
    textField.layer.borderColor = UIColor.buttonColor().cgColor
        textField.layer.borderWidth = 1.0 // You can adjust the border width as needed
        textField.layer.cornerRadius = 5.0 // Optional: Add corner radius for a rounded appearance
    }

func addDottedBorder(to button: UIButton) {
       let dottedBorder = CAShapeLayer()
       dottedBorder.strokeColor = UIColor.black.cgColor
       dottedBorder.lineDashPattern = [2, 2] // Customize the pattern as needed
       dottedBorder.frame = button.bounds
       dottedBorder.fillColor = nil
       dottedBorder.path = UIBezierPath(rect: button.bounds).cgPath

       button.layer.addSublayer(dottedBorder)
   }

func AddShadow(view: UIView){
    view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    view.layer.shadowOpacity = 1.0
    view.layer.shadowRadius = 0.0
    view.layer.masksToBounds = false
    view.layer.cornerRadius = 4.0
}

extension UIView {
    
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadowWithBlackColor()
    {
        self.layer.shadowColor    = UIColor.lightGray.cgColor
        self.layer.shadowOpacity  = 0.6
        self.layer.shadowRadius   = 7;
        self.layer.masksToBounds  = false
        self.layer.shadowOffset   = CGSize(width: 1.0, height: 1.0)
        self.layer.cornerRadius = 10
    }
    
    
}
extension UIViewController{
    
    func isEarlier(timeString1: String, timeString2: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        if let date1 = dateFormatter.date(from: timeString1),
           let date2 = dateFormatter.date(from: timeString2) {
            return date1 < date2
        } else {
            // Invalid time format
            return false
        }
    }
    
    func showToast(message : String, font: UIFont) {
        var toastLabel =  UILabel(frame: CGRect.zero)
        if UIDevice.current.userInterfaceIdiom == .phone{
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - ((UIScreen.main.bounds.width) * 0.3), y: self.view.frame.size.height-((UIScreen.main.bounds.height) * 0.19), width: 258, height: 35))
        }else{
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 95, y: self.view.frame.size.height-((UIScreen.main.bounds.height) * 0.15), width: 258, height: 35))
        }//75x//100y
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        //added
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}
extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
}
class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(systemName: "checkmark.square.fill")! as UIImage
    let uncheckedImage = UIImage(systemName: "square")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
extension UILabel {
    func setMargins(margin: CGFloat = 10) {
        if let textString = self.text {
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
extension UITextField {
    @objc func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    @objc func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
class PaddingLabel: UILabel {
    
    var edgeInset: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
}
extension CAShapeLayer {
    func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
    }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func setBadge(text: String?, withOffsetFromTopRight offset: CGPoint = CGPoint.zero, andColor color:UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 11)
    {
        badgeLayer?.removeFromSuperlayer()
        
        if (text == nil || text == "") {
            return
        }
        
        addBadge(text: text!, withOffset: offset, andColor: color, andFilled: filled)
    }
    
    public func addBadge(text: String, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 11)
    {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        var font = UIFont.systemFont(ofSize: fontSize)
        
        if #available(iOS 9.0, *) { font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFont.Weight.regular) }
        let badgeSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        // Initialize Badge
        let badge = CAShapeLayer()
        
        let height = badgeSize.height;
        var width = badgeSize.width + 2 /* padding */
        
        //make sure we have at least a circle
        if (width < height) {
            width = height
        }
        
        //x position is offset from right-hand side
        let x = view.frame.width - width + offset.x
        
        let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))
        
        badge.drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = text
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.font = font
        label.fontSize = font.pointSize
        
        label.frame = badgeFrame
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
extension UITableView {
    func reloadDataWithDelay(delayTime: TimeInterval) -> Void {
        let delayTime = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.reloadData()
        }
        
    }
}
extension Collection {
    
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < endIndex else { return nil }
            let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
    
    func every(n: Int) -> UnfoldSequence<Element,Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { formIndex(&index, offsetBy: n, limitedBy: endIndex) }
            return self[index]
        }
    }
    
    var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}
extension UITextField {
    
    enum PaddingSpace {
        case left(CGFloat)
        case right(CGFloat)
        case equalSpacing(CGFloat)
    }
    
    func addPadding(padding: PaddingSpace) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        switch padding {
            
        case .left(let spacing):
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = leftPaddingView
            self.leftViewMode = .always
            
        case .right(let spacing):
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = rightPaddingView
            self.rightViewMode = .always
            
        case .equalSpacing(let spacing):
            let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = equalPaddingView
            self.leftViewMode = .always
            // right
            self.rightView = equalPaddingView
            self.rightViewMode = .always
        }
    }
}
class ShadowView: UIView {
    
    var setupShadowDone: Bool = false
    
    public func setupShadow() {
        if setupShadowDone { return }
        print("Setup shadow!")
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height:
                                                                                                    8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        setupShadowDone = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("Layout subviews!")
        setupShadow()
    }
}

extension UITableViewCell {
    func addShadow(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 5, shadowOpacity: Float = 0.1, shadowPathInset: (dx: CGFloat, dy: CGFloat), shadowPathOffset: (dx: CGFloat, dy: CGFloat)) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy).offsetBy(dx: shadowPathOffset.dx, dy: shadowPathOffset.dy), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = backgroundColor
        whiteBackgroundView.layer.cornerRadius = cornerRadius
        whiteBackgroundView.layer.masksToBounds = true
        whiteBackgroundView.clipsToBounds = false
        
        whiteBackgroundView.frame = bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy)
        insertSubview(whiteBackgroundView, at: 0)
    }
}
@IBDesignable class BubbleView: UIView { // 1
    
    override init(frame: CGRect) { // 2
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        super.backgroundColor = .clear // 3
    }
    
    private var bubbleColor: UIColor? { // 4
        didSet {
            setNeedsDisplay() // 5
        }
    }
    
    override var backgroundColor: UIColor? { // 6
        get { return bubbleColor }
        set { bubbleColor = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 { // 1
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear { // 2
        didSet {
            setNeedsDisplay()
        }
    }
    
    enum ArrowDirection: String { // 1
        case left = "left"
        case right = "right"
    }
    
    var arrowDirection: ArrowDirection = .right { // 2
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var arrowDirectionIB: String { // 3
        get {
            return arrowDirection.rawValue
        }
        set {
            if let direction = ArrowDirection(rawValue: newValue) {
                arrowDirection = direction
            }
        }
    }
    override func draw(_ rect: CGRect) {
        // ... unchanged
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = borderWidth // 3
        
        let bottom = rect.height - borderWidth // 4
        let right = rect.width - borderWidth
        let top = borderWidth
        let left = borderWidth
        
        if arrowDirection == .right { // 4
            bezierPath.move(to: CGPoint(x: right - 22, y: bottom)) // 5
            bezierPath.addLine(to: CGPoint(x: 17 + borderWidth, y: bottom))
            bezierPath.addCurve(to: CGPoint(x: left, y: bottom - 18), controlPoint1: CGPoint(x: 7.61 + borderWidth, y: bottom), controlPoint2: CGPoint(x: left, y: bottom - 7.61))
            bezierPath.addLine(to: CGPoint(x: left, y: 17 + borderWidth))
            bezierPath.addCurve(to: CGPoint(x: 17 + borderWidth, y: top), controlPoint1: CGPoint(x: left, y: 7.61 + borderWidth), controlPoint2: CGPoint(x: 7.61 + borderWidth, y: top))
            bezierPath.addLine(to: CGPoint(x: right - 21, y: top))
            bezierPath.addCurve(to: CGPoint(x: right - 4, y: 17 + borderWidth), controlPoint1: CGPoint(x: right - 11.61, y: top), controlPoint2: CGPoint(x: right - 4, y: 7.61 + borderWidth))
            bezierPath.addLine(to: CGPoint(x: right - 4, y: bottom - 11))
            bezierPath.addCurve(to: CGPoint(x: right, y: bottom), controlPoint1: CGPoint(x: right - 4, y: bottom - 1), controlPoint2: CGPoint(x: right, y: bottom))
            bezierPath.addLine(to: CGPoint(x: right + 0.05, y: bottom - 0.01))
            bezierPath.addCurve(to: CGPoint(x: right - 11.04, y: bottom - 4.04), controlPoint1: CGPoint(x: right - 4.07, y: bottom + 0.43), controlPoint2: CGPoint(x: right - 8.16, y: bottom - 1.06))
            bezierPath.addCurve(to: CGPoint(x: right - 22, y: bottom), controlPoint1: CGPoint(x: right - 16, y: bottom), controlPoint2: CGPoint(x: right - 19, y: bottom))
            bezierPath.close()
            
            backgroundColor?.setFill()
            borderColor.setStroke() // 6
            bezierPath.fill()
            bezierPath.stroke()
        } else {
            bezierPath.move(to: CGPoint(x: 22 + borderWidth, y: bottom)) // 5
            bezierPath.addLine(to: CGPoint(x: right - 17, y: bottom))
            bezierPath.addCurve(to: CGPoint(x: right, y: bottom - 17), controlPoint1: CGPoint(x: right - 7.61, y: bottom), controlPoint2: CGPoint(x: right, y: bottom - 7.61))
            bezierPath.addLine(to: CGPoint(x: right, y: 17 + borderWidth))
            bezierPath.addCurve(to: CGPoint(x: right - 17, y: top), controlPoint1: CGPoint(x: right, y: 7.61 + borderWidth), controlPoint2: CGPoint(x: right - 7.61, y: top))
            bezierPath.addLine(to: CGPoint(x: 21 + borderWidth, y: top))
            bezierPath.addCurve(to: CGPoint(x: 4 + borderWidth, y: 17 + borderWidth), controlPoint1: CGPoint(x: 11.61 + borderWidth, y: top), controlPoint2: CGPoint(x: borderWidth + 4, y: 7.61 + borderWidth))
            bezierPath.addLine(to: CGPoint(x: borderWidth + 4, y: bottom - 11))
            bezierPath.addCurve(to: CGPoint(x: borderWidth, y: bottom), controlPoint1: CGPoint(x: borderWidth + 4, y: bottom - 1), controlPoint2: CGPoint(x: borderWidth, y: bottom))
            bezierPath.addLine(to: CGPoint(x: borderWidth - 0.05, y: bottom - 0.01))
            bezierPath.addCurve(to: CGPoint(x: borderWidth + 11.04, y: bottom - 4.04), controlPoint1: CGPoint(x: borderWidth + 4.07, y: bottom + 0.43), controlPoint2: CGPoint(x: borderWidth + 8.16, y: bottom - 1.06))
            bezierPath.addCurve(to: CGPoint(x: borderWidth + 22, y: bottom), controlPoint1: CGPoint(x: borderWidth + 16, y: bottom), controlPoint2: CGPoint(x: borderWidth + 19, y: bottom))
            
            backgroundColor?.setFill()
            borderColor.setStroke() // 6
            bezierPath.fill()
            bezierPath.stroke()
        }
        
        // ... unchanged
    }
}




//enum ArrowDirection: String { // 1
//   case left = "left"
//   case right = "right"
// }
//
// var arrowDirection: ArrowDirection = .right { // 2
//   didSet {
//     setNeedsDisplay()
//   }
// }
//
// @IBInspectable var arrowDirectionIB: String { // 3
//   get {
//     return arrowDirection.rawValue
//   }
//   set {
//     if let direction = ArrowDirection(rawValue: newValue) {
//       arrowDirection = direction
//     }
//   }
// }
//
// override func draw(_ rect: CGRect) {
//   // ... unchanged
//
//   if arrowDirection == .right { // 4
//     // ... unchanged
//   } else {
//     bezierPath.move(to: CGPoint(x: 22 + borderWidth, y: bottom)) // 5
//     bezierPath.addLine(to: CGPoint(x: right - 17, y: bottom))
//     bezierPath.addCurve(to: CGPoint(x: right, y: bottom - 17), controlPoint1: CGPoint(x: right - 7.61, y: bottom), controlPoint2: CGPoint(x: right, y: bottom - 7.61))
//     bezierPath.addLine(to: CGPoint(x: right, y: 17 + borderWidth))
//     bezierPath.addCurve(to: CGPoint(x: right - 17, y: top), controlPoint1: CGPoint(x: right, y: 7.61 + borderWidth), controlPoint2: CGPoint(x: right - 7.61, y: top))
//     bezierPath.addLine(to: CGPoint(x: 21 + borderWidth, y: top))
//     bezierPath.addCurve(to: CGPoint(x: 4 + borderWidth, y: 17 + borderWidth), controlPoint1: CGPoint(x: 11.61 + borderWidth, y: top), controlPoint2: CGPoint(x: borderWidth + 4, y: 7.61 + borderWidth))
//     bezierPath.addLine(to: CGPoint(x: borderWidth + 4, y: bottom - 11))
//     bezierPath.addCurve(to: CGPoint(x: borderWidth, y: bottom), controlPoint1: CGPoint(x: borderWidth + 4, y: bottom - 1), controlPoint2: CGPoint(x: borderWidth, y: bottom))
//     bezierPath.addLine(to: CGPoint(x: borderWidth - 0.05, y: bottom - 0.01))
//     bezierPath.addCurve(to: CGPoint(x: borderWidth + 11.04, y: bottom - 4.04), controlPoint1: CGPoint(x: borderWidth + 4.07, y: bottom + 0.43), controlPoint2: CGPoint(x: borderWidth + 8.16, y: bottom - 1.06))
//     bezierPath.addCurve(to: CGPoint(x: borderWidth + 22, y: bottom), controlPoint1: CGPoint(x: borderWidth + 16, y: bottom), controlPoint2: CGPoint(x: borderWidth + 19, y: bottom))
//   }
//
//   // ... unchanged
// }
extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.gray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.gray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 1.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var masksToBounds: Bool = true {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 12, height: 12) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCornersWithBorder(corners: UIRectCorner, radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        layer.mask = maskLayer
        
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(red:3/255, green:33/255, blue:70/255, alpha: 0.15).cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}


extension UIViewController{
    //    func changePlaceholder(text: SkyFloatingLabelTextField)
    //    {
    //        text.setRightPaddingPoints(10.0)
    //        text.setLeftPaddingPoints(10.0)
    //        let overcastBlueColor = UIColor(red: 127/255, green: 195/255, blue: 70/255, alpha: 1.0)
    //        text.tintColor = overcastBlueColor
    //        text.textColor = .darkGray
    //        text.lineColor = .lightGray
    //        text.titleColor = overcastBlueColor
    //        text.titleFont = UIFont.systemFont(ofSize: 12)
    //        text.selectedTitleColor =  overcastBlueColor
    //        text.selectedLineColor = .lightGray
    //        text.titleErrorColor = .red
    //        text.lineHeight = 1.0
    //        text.selectedLineHeight = 1.0
    //    }
    func makeButtonBackground( button : UIButton)
    {
        //        button.layer.shadowColor = UIColor.black.cgColor
        //        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        //        button.layer.shadowRadius = 8
        //        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = true//false
        button.layer.cornerRadius = 10//5
    }
    
    func makeButtonShadow( button : UIButton)
    {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 5
    }
    func makeButtonBackgroundBorder( button : UIButton)
    {
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        button.layer.shadowRadius = 8
//        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = true//false
        button.layer.cornerRadius = button.frame.height/2
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func makeLeaderBorder( button : UIButton)
    {
        button.layer.masksToBounds = true//false
        button.layer.cornerRadius = button.frame.height/2
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    func makeLabelLeaderBorder( label : UILabel)
    {
        label.layer.masksToBounds = true//false
        label.layer.cornerRadius = label.frame.size.height/2
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    
    
}
extension UIView {
    
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
//extension Date {
//    
//    var fullDate: String { localizedDescription(date: .full, time: .none) }
//    var longDate: String { localizedDescription(date: .long, time: .none) }
//    var mediumDate: String { localizedDescription(date: .medium, time: .none) }
//    var shortDate: String { localizedDescription(date: .short, time: .none) }
//    
//    var fullTime: String { localizedDescription(date: .none, time: .full) }
//    var longTime: String { localizedDescription(date: .none, time: .long) }
//    var mediumTime: String { localizedDescription(date: .none, time: .medium) }
//    var shortTime: String { localizedDescription(date: .none, time: .short) }
//    
//    var fullDateTime: String { localizedDescription(date: .full, time: .full) }
//    var longDateTime: String { localizedDescription(date: .long, time: .long) }
//    var mediumDateTime: String { localizedDescription(date: .medium, time: .medium) }
//    var shortDateTime: String { localizedDescription(date: .short, time: .short) }
//    
//    
//    func localizedDescription(date dateStyle: DateFormatter.Style = .medium,
//                              time timeStyle: DateFormatter.Style = .medium,
//                              in timeZone: TimeZone = .current,
//                              locale: Locale = .current,
//                              using calendar: Calendar = .current) -> String {
//        Formatter.date.calendar = calendar
//        Formatter.date.locale = locale
//        Formatter.date.timeZone = timeZone
//        Formatter.date.dateStyle = dateStyle
//        Formatter.date.timeStyle = timeStyle
//        return Formatter.date.string(from: self)
//    }
//    var localizedDescription: String { localizedDescription() }
//}
extension Formatter {
    static let date = DateFormatter()
}

extension UIView {
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
}
extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

}

extension UIImage{
    convenience init(view: UIView) {

        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)

    }
}

@IBDesignable
class GradientView: UIView {

    private var gradientLayer = CAGradientLayer()
    private var vertical: Bool = false

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code

        //fill view with gradient layer
        gradientLayer.frame = self.bounds
        //style and insert layer if not already inserted
        if gradientLayer.superlayer == nil {

            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
            gradientLayer.colors = [UIColor(red: 155/255, green: 223/255, blue: 97/255, alpha: 1.0).cgColor, UIColor(red: 127/255, green: 195/255, blue: 70/255, alpha: 1.0)]
            gradientLayer.locations = [0.0, 1.0]

            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

}
extension UIView {
    
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {

        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]

            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }

                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)

                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"

                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }

                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
}
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
      var isDigits: Bool {
        guard !self.isEmpty else { return false }
        return !self.contains { Int(String($0)) == nil }
      }
}
extension UIImage {
    func tinted(with color: UIColor, isOpaque: Bool = false) -> UIImage? {
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
}
extension UIFont {

    public enum OpenSansType: String {
        case extraboldItalic = "-ExtraboldItalic"
        case semiboldItalic = "-SemiboldItalic"
        case semibold = "-Semibold"
        case regular = ""
        case lightItalic = "Light-Italic"
        case light = "-Light"
        case italic = "-Italic"
        case extraBold = "-Extrabold"
        case boldItalic = "-BoldItalic"
        case bold = "-Bold"
    }

    static func OpenSans(_ type: OpenSansType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "OpenSans\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}
extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}
extension UIScreen {

    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 1920.0
        case iPhone12Mini = 2340.0
        
    }

    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}
extension NSDate {
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}
extension UIButton{
    func roundedButtons(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedButton(){
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
}
extension CATransition {

//New viewController will appear from bottom of screen.
func segueFromBottom() -> CATransition {
    self.duration = 0.4 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromTop
    return self
}
//New viewController will appear from top of screen.
func segueFromTop() -> CATransition {
    self.duration = 0.4 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromBottom
    return self
}
 //New viewController will appear from left side of screen.
func segueFromLeft() -> CATransition {
    self.duration = 0.4 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromLeft
    return self
}
//New viewController will pop from right side of screen.
func popFromRight() -> CATransition {
    self.duration = 0.4 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.reveal
    self.subtype = CATransitionSubtype.fromRight
    return self
}
//New viewController will appear from left side of screen.
func popFromLeft() -> CATransition {
    self.duration = 0.4 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.reveal
    self.subtype = CATransitionSubtype.fromLeft
    return self
   }
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
extension UIButton {

    private class Action {
        var action: (UIButton) -> Void

        init(action: @escaping (UIButton) -> Void) {
            self.action = action
        }
    }

    private struct AssociatedKeys {
        static var ActionTapped = "actionTapped"
    }

    private var tapAction: Action? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionTapped, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionTapped) as? Action }
    }


    @objc dynamic private func handleAction(_ recognizer: UIButton) {
        tapAction?.action(recognizer)
    }


    func mk_addTapHandler(action: @escaping (UIButton) -> Void) {
        self.addTarget(self, action: #selector(handleAction(_:)), for: .touchUpInside)
        tapAction = Action(action: action)

    }
}
extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
class TriangleView: UIView {
      override func draw(_ rect: CGRect) {
         let widthHeight = self.layer.frame.size.height

         let triangle = CAShapeLayer()
          triangle.fillColor = UIColor(red: 238/255, green: 248/255, blue: 229/255, alpha: 1.0).cgColor
         triangle.path = roundedTriangle(widthHeight: widthHeight)
         triangle.position = CGPoint(x: 0, y: 0)
         self.layer.addSublayer(triangle)
      }

      func roundedTriangle(widthHeight: CGFloat) -> CGPath {
         let point1 = CGPoint(x: widthHeight/2, y:0)
         let point2 = CGPoint(x: widthHeight , y: widthHeight)
         let point3 =  CGPoint(x: 0, y: widthHeight)
    
         let path = CGMutablePath()
  
         path.move(to: CGPoint(x: 0, y: widthHeight))
         path.addArc(tangent1End: point1, tangent2End: point2, radius: 5)
         path.addArc(tangent1End: point2, tangent2End: point3, radius: 5)
         path.addArc(tangent1End: point3, tangent2End: point1, radius: 5)
         path.closeSubpath()
         return path
      }
   }
extension String {
    func floatValue() -> Float? {
        return Float(self)
    }
}
extension Collection where Iterator.Element == String {
    var doubleArray: [Double] {
        return flatMap{ Double($0) }
    }
    var floatArray: [Float] {
        return flatMap{ Float($0) }
    }
}
extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}

extension UIFont {
  public enum fontType: String {
    case regular = ""
    case kFontBlackItalic = "Montserrat-BlackItalic"
    case kFontExtraBoldItalic = "Montserrat-ExtraBoldItalic"
    case kFontBoldItalic = "Montserrat-BoldItalic"
    case kFontSemiBoldItalic = "Montserrat-SemiBoldItalic"
    case kFontMediumItalic = "Montserrat-MediumItalic"
    case kFontItalic = "Montserrat-Italic"
    case kFontLightItalic = "Montserrat-LightItalic"
    case kFontBlack = "Montserrat-Black"
    case kFontExtraLightItalic = "Montserrat-ExtraLightItalic"
    case kFontThinItalic = "Montserrat-ThinItalic"
    case kFontExtraBold = "Montserrat-ExtraBold"
    case kFontBold = "Montserrat-Bold"
    case kFontSemiBold = "Montserrat-SemiBold"
    case kFontMedium = "Montserrat-Medium"
    case kFontRegular = "Montserrat-Regular"
    case kFontLight = "Montserrat-Light"
    case kFontExtraLight = "Montserrat-ExtraLight"
    case kFontThin = "Montserrat-Thin"
}
    
static func setFont(_ type: fontType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
    return UIFont(name: type.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: 16.0)
    }
 }
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension UIView {
    func displayTooltip(_ message: String, completion: (() -> Void)? = nil) {
        let tooltipBottomPadding: CGFloat = 12
        let tooltipCornerRadius: CGFloat = 6
        let tooltipAlpha: CGFloat = 0.95
        let pointerBaseWidth: CGFloat = 14
        let pointerHeight: CGFloat = 8
        let padding = CGPoint(x: 18, y: 12)
        
        let tooltip = UIView()
        
        let tooltipLabel = UILabel()
        tooltipLabel.text = "    \(message)    "
        tooltipLabel.font = UIFont.systemFont(ofSize: 12)
        tooltipLabel.contentMode = .center
        tooltipLabel.textColor = .white
        tooltipLabel.layer.backgroundColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 44 / 255, alpha: 1).cgColor
        tooltipLabel.layer.cornerRadius = tooltipCornerRadius
        
        tooltip.addSubview(tooltipLabel)
        tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
        tooltipLabel.bottomAnchor.constraint(equalTo: tooltip.bottomAnchor, constant: -pointerHeight).isActive = true
        tooltipLabel.topAnchor.constraint(equalTo: tooltip.topAnchor).isActive = true
        tooltipLabel.leadingAnchor.constraint(equalTo: tooltip.leadingAnchor).isActive = true
        tooltipLabel.trailingAnchor.constraint(equalTo: tooltip.trailingAnchor).isActive = true
        
        let labelHeight = message.height(withWidth: .greatestFiniteMagnitude, font: UIFont.systemFont(ofSize: 12)) + padding.y
        let labelWidth = message.width(withHeight: .zero, font: UIFont.systemFont(ofSize: 12)) + padding.x
        
        let pointerTip = CGPoint(x: labelWidth / 2, y: labelHeight + pointerHeight)
        let pointerBaseLeft = CGPoint(x: labelWidth / 2 - pointerBaseWidth / 2, y: labelHeight)
        let pointerBaseRight = CGPoint(x: labelWidth / 2 + pointerBaseWidth / 2, y: labelHeight)
        
        let pointerPath = UIBezierPath()
        pointerPath.move(to: pointerBaseLeft)
        pointerPath.addLine(to: pointerTip)
        pointerPath.addLine(to: pointerBaseRight)
        pointerPath.close()
        
        let pointer = CAShapeLayer()
        pointer.path = pointerPath.cgPath
        pointer.fillColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 44 / 255, alpha: 1).cgColor
        
        tooltip.layer.addSublayer(pointer)
        (superview ?? self).addSubview(tooltip)
        tooltip.translatesAutoresizingMaskIntoConstraints = false
        tooltip.bottomAnchor.constraint(equalTo: topAnchor, constant: -tooltipBottomPadding + pointerHeight).isActive = true
        tooltip.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tooltip.heightAnchor.constraint(equalToConstant: labelHeight + pointerHeight).isActive = true
        tooltip.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        
        tooltip.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            tooltip.alpha = tooltipAlpha
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 12.0, animations: {
                tooltip.alpha = 0
            }, completion: { _ in
                tooltip.removeFromSuperview()
                completion?()
            })
        })
    }
}
extension String {
    func width(withHeight constrainedHeight: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: constrainedHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func height(withWidth constrainedWidth: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
class MyButton: UIButton{
    var myRow: Int = 0
    var mySection: Int = 0

}
extension Array where Element: Equatable {

    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }

    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index+=1
            }
        }
    }
}
extension UILabel {
    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}
extension UITabBar {
    func addBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = "●"
            tabItem.badgeColor = .clear
            tabItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
        }
    }
    func removeBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = nil
        }
    }
    
 }
//Chnage Font
public protocol ChangableFont: AnyObject {
    var rangedAttributes: [RangedAttributes] { get }
    func getText() -> String?
    func set(text: String?)
    func getAttributedText() -> NSAttributedString?
    func set(attributedText: NSAttributedString?)
    func getFont() -> UIFont?
    func changeFont(ofText text: String, with font: UIFont)
    func changeFont(inRange range: NSRange, with font: UIFont)
    func changeTextColor(ofText text: String, with color: UIColor)
    func changeTextColor(inRange range: NSRange, with color: UIColor)
    func resetFontChanges()
}
public struct RangedAttributes {

    public let attributes: [NSAttributedString.Key: Any]
    public let range: NSRange

    public init(_ attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        self.attributes = attributes
        self.range = range
    }
}
extension UILabel: ChangableFont {
    public func getText() -> String? {
        return text
    }

    public func set(text: String?) {
        self.text = text
    }

    public func getAttributedText() -> NSAttributedString? {
        return attributedText
    }

    public func set(attributedText: NSAttributedString?) {
        self.attributedText = attributedText
    }

    public func getFont() -> UIFont? {
        return font
    }
}
public extension ChangableFont {

    var rangedAttributes: [RangedAttributes] {
        guard let attributedText = getAttributedText() else {
            return []
        }
        var rangedAttributes: [RangedAttributes] = []
        let fullRange = NSRange(
            location: 0,
            length: attributedText.string.count
        )
        attributedText.enumerateAttributes(
            in: fullRange,
            options: []
        ) { (attributes, range, stop) in
            guard range != fullRange, !attributes.isEmpty else { return }
            rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        }
        return rangedAttributes
    }

    func changeFont(ofText text: String, with font: UIFont) {
        guard let range = (self.getAttributedText()?.string ?? self.getText())?.range(ofText: text) else { return }
        changeFont(inRange: range, with: font)
    }

    func changeFont(inRange range: NSRange, with font: UIFont) {
        add(attributes: [.font: font], inRange: range)
    }

    func changeTextColor(ofText text: String, with color: UIColor) {
        guard let range = (self.getAttributedText()?.string ?? self.getText())?.range(ofText: text) else { return }
        changeTextColor(inRange: range, with: color)
    }

    func changeTextColor(inRange range: NSRange, with color: UIColor) {
        add(attributes: [.foregroundColor: color], inRange: range)
    }

    private func add(attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        guard !attributes.isEmpty else { return }

        var rangedAttributes: [RangedAttributes] = self.rangedAttributes

        var attributedString: NSMutableAttributedString

        if let attributedText = getAttributedText() {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else if let text = getText() {
            attributedString = NSMutableAttributedString(string: text)
        } else {
            return
        }

        rangedAttributes.append(RangedAttributes(attributes, inRange: range))

        rangedAttributes.forEach { (rangedAttributes) in
            attributedString.addAttributes(
                rangedAttributes.attributes,
                range: rangedAttributes.range
            )
        }

        set(attributedText: attributedString)
    }

    func resetFontChanges() {
        guard let text = getText() else { return }
        set(attributedText: NSMutableAttributedString(string: text))
    }
}
public extension String {

    func range(ofText text: String) -> NSRange {
        let fullText = self
        let range = (fullText as NSString).range(of: text)
        return range
    }
}

//extension String {
//    func localizeString(string: String) -> String {
//        let path = Bundle.main.path(forResource: string, ofType: "lproj")
//        let bundle = Bundle(path: path!)
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
//}
extension UIButton{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

extension UIColor {

        class func buttonColor() -> UIColor {
            return UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 1.0)
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

class GradientButton: UIButton {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    var startColor: UIColor = .blue {
        didSet {
            updateColors()
        }
    }
    
    var endColor: UIColor = .green {
        didSet {
            updateColors()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        setTitleColor(.white, for: .normal)
    }
    
    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}

extension UIView {
    func addTopRoundedCorner(radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = maskPath.cgPath
        layer.mask = shapeLayer
    }
}
