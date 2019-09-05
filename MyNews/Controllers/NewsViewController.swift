//
//  ViewController.swift
//  MyNews
//
//  Created by Надежда Морозова on 04/09/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import WebKit


let cacheImage = NSCache<NSString, UIImage>()

class NewsViewController: UITableViewController {
    var textErr = "No Connect!"
    let newsApiURL = "https://newsapi.org/v2/everything?q=android&from=2019-04-00&sortBy=publi%20shedAt&apiKey=26eddb253e7840f988aec61f2ece2907&page=2"
    
    var webView: WKWebView!
    var articles = [Article]()
    var spiner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self as? WKNavigationDelegate
        startSpiner()
        startJSON(newsApiURL)
        
    }
    
    // MARK: - Network
    func startJSON(_ apiUrl: String) {
        Alamofire.request(apiUrl).responseJSON { response in
            
            if response.result.value != nil {
                
                let json = JSON(response.result.value!)
                let results = json["articles"].arrayValue
                
                for result in results {
                    
                    let article = Article(title: result["title"].stringValue,
                                          desc: result["description"].stringValue,
                                          image: result["urlToImage"].stringValue,
                                          url: result["url"].url!,
                                          datePublic: result["publishedAt"].stringValue)
                    
                    self.articles.append(article)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.stopSpiner()
            } else {
                self.alert()
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ArticleViewCell", owner: self, options: nil)?.first as! ArticleViewCell
        
        let article = self.articles[indexPath.row]
        cell.config(article: article)
        
        if cell.TextLabel?.text == nil && cell.titleLabel.text == nil {
            
            let cell = Bundle.main.loadNibNamed("ArrorTableViewCell", owner: self, options: nil)?.first as! ArrorTableViewCell
            let textarr = textErr
            cell.errorText.text = textarr
            cell.errorButton.tag = indexPath.row
            cell.errorButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
            
            return cell
        }
        return cell
    }
    
    @objc func editButtonPressed(_ sender: UIButton) {
        tableView.reloadData()
        print(sender.tag)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "urlSeque", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "urlSeque" {
            
            if let viewController = segue.destination as? ArticleViewController {
                let indexPath = self.tableView.indexPathForSelectedRow
                let article = self.articles[(indexPath?.row)!]
                viewController.url = article.url
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let translate = CATransform3DTranslate(CATransform3DIdentity, -500, 400, 0)
        cell.layer.transform = translate
        
        UIView.animate(withDuration: 1, delay: 0.2 * Double(indexPath.row), options: .curveEaseInOut, animations: {
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    func startSpiner() {
        self.spiner = UIActivityIndicatorView(style: .whiteLarge)
        self.spiner.color = UIColor .gray
        view.addSubview(spiner)
        self.spiner.center = self.tableView.center
        self.spiner.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    func stopSpiner() {
        self.spiner.stopAnimating()
        self.spiner.removeFromSuperview()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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

extension UIImageView {
    
    func loadImage(_ urlString: String) {
        self.image = nil
        if let cacheImages = cacheImage.object(forKey: urlString as NSString) {
            self.image = cacheImages
            return
        }
        Alamofire.request(urlString).responseImage { response in
            
            if let downloadedImage = response.result.value {
                
                cacheImage.setObject(downloadedImage, forKey: urlString as NSString)
                self.image = downloadedImage
            }
        }
    }
}
