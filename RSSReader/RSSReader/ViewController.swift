//
//  ViewController.swift
//  RSSReader
//
//  Created by Owner on 2020/06/09.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var table: UITableView!
    
    var elementList = NSMutableArray()
    var urlForDetailForView = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        table.delegate = self
        getJson()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int{
        return elementList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let n = elementList.object(at: indexPath.row) as! News
        let selectedURL = n.url
        urlForDetailForView = NSURL(string: selectedURL)!
        
        self.performSegue(withIdentifier: "toDetailView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell",for: indexPath as IndexPath)
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let dataLabel = cell.viewWithTag(2) as! UILabel
        
        let f = elementList.object(at: indexPath.row) as! News
        //titleLabel.text = f.title
        dataLabel.text = f.date
        
        return cell
    }
    
    
    

    func getJson(){
        let urlString = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.dailynews.yahoo.co.jp/fc/rss.xml&num=8"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(urlString,method:.get).responseJSON{
            response in
            switch response.result{
            case .success(let value):
                print("\(urlString)の取得に成功しました")
                if let jsonDic = response.result.value as? NSDictionary{
                    let responseData = jsonDic["responseData"] as! NSDictionary
                    let responseData2 = responseData["feed"] as! NSDictionary
                    let entries = responseData2["entries"] as! NSArray
                    for i in 0 ..< entries.count{
                        let n = News()
                        n.title = ((entries[i] as Any) as AnyObject).object(forKey: "title") as! String
                        n.url = ((entries[i] as Any) as AnyObject).object(forKey: "link") as! String
                        n.date = ((entries[i] as Any) as AnyObject).object(forKey: "publishedDate") as! String
                        self.elementList.add(n)
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.table.reloadData()
            case .failure( _):
                print("\(urlString)の取得に失敗しました")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toDetailView"{
            //let nvc = segue.destination as! NewsDetailViewController
            //nvc.urlToRSSReaderView = urlForDetailForView
        }
    }
    
    @IBAction func backView(segue: UIStoryboardSegue) {
            
    }
    
    @IBAction func refleshList(_ sender: Any) {
        getJson()
    }
    
}


