//
//  Global.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import Foundation
import UIKit
import SystemConfiguration
import Network
var addConnection : Bool = false
let ksceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
var updateRow = 0
//let kappDelegate = UIApplication.shared.connectedScenes.first?.delegate as? AppDelegate
let reachability = Reachability()
var lang: String = UserDefaults.standard.string(forKey: "Lang") ?? "en"
var locationUpdateTimer: Timer?
class ApiLink {
    static let INTERNET_ERROR_MESSAGE = "Oops! It seems you are not connected with internet. Please check your internet connection."
   static let HOST_URL = "https://kingdomrisingstar.com/cleansing/api" 
    
}
@objc class Reachability: NSObject {
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
        {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

class DatePickerInputView: UIView {

    var datePicker: UIDatePicker!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDatePicker()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDatePicker()
    }

    func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date()) // Change to desired minimum date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor),
            // Adjust width constraint if needed
            datePicker.widthAnchor.constraint(equalToConstant: 200) // Adjust width as needed
        ])
    }
}


class customButton: UIButton {
    
    override var isSelected: Bool {
        willSet {
            if isSelected {
                self.backgroundColor = .clear
            }else{
                self.backgroundColor = .white
            }
        }
        didSet {
            if isSelected {
                self.backgroundColor = .clear
            }else{
                self.backgroundColor = .white
            }
        }
    }
}
