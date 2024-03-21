//
//  WebViewVC.swift
//  Cleansing
//
//  Created by uis on 21/03/24.
//

import UIKit

//
//  WebViewVC.swift
//  LiveNutrifit
//
//  Created by Vivek Kumar on 30/08/22.
//

import UIKit
import WebKit
import Alamofire
class WebViewVC: UIViewController,WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: UIView!
    var webview : WKWebView!
    var type: String!
    var amount: Int = 0
    var callfrom:String = ""
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var duration: String = ""
    var foodURL: String = ""
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Register"
       
        addWebView(webURL: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    func activityIndicator(_ title: String) {
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    
    func addWebView(webURL:String)
    {
        webview = WKWebView()
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        if UIScreen.main.sizeType == .iPhone6 {
            webview.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 1.0, height: (UIScreen.main.bounds.height * 0.9))
        }else{
            webview.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 1.0, height: (UIScreen.main.bounds.height * 0.85))
        }
        webview.uiDelegate = self
        webview.allowsLinkPreview = true
        webview.navigationDelegate = self
        webview.scrollView.minimumZoomScale = 1.0
        webview.scrollView.maximumZoomScale = 1.0
        webview.scrollView.zoomScale = 1.0
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.showsHorizontalScrollIndicator = false
        let urlString:String = "https://kingdomrisingstar.com/cleansing/employee/registration"
        let request = URLRequest(url:URL(string: urlString)!)
        webview.load(request)
        webView.addSubview(webview)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator("Loading ...")
        if let url: URL = webview.url {
            let urlstring = url.absoluteString
        }
        print("Refresh")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("initMap()", completionHandler: { (value, err) in
            print("Not Working")
        })
        self.effectView.removeFromSuperview()
        print("Refresh Paused")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            let string = url.absoluteString
            print(string)
            if (string.contains("https://kingdomrisingstar.com/cleansing/employee/redirect")){
                self.navigationController?.popViewController(animated: true)
            }else{
//                self.navigationController?.popViewController(animated: true)
            }
        }
        decisionHandler(.allow)
    }
}
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
}
