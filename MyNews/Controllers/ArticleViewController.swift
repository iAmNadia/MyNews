//
//  ArticleViewController.swift
//  MyNews
//
//  Created by Надежда Морозова on 04/09/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webViewArticle: WKWebView!
    @IBOutlet weak var spinerActivity: UIActivityIndicatorView!
    
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webViewArticle.translatesAutoresizingMaskIntoConstraints = false
        webViewArticle.navigationDelegate = self
        webViewArticle.load(URLRequest(url: url))
        webViewArticle.allowsBackForwardNavigationGestures = true
        
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
    }
    
    func stopAnimating() {
        spinerActivity.stopAnimating()
        self.spinerActivity.hidesWhenStopped = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func startAnimating() {
        spinerActivity.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func alert() {
        let alertController = UIAlertController(
            title: "Нет соединения с интернетом",
            message: "Проверьте, что имеется соединение с интернетом",
            preferredStyle: .alert)
        let alertButtonOne = UIAlertAction(title: "ОК", style: .default, handler: nil)
        let alertButtonTwo = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(alertButtonOne)
        alertController.addAction(alertButtonTwo)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
