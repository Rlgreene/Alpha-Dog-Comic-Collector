//
//  SearchNewTableViewController.swift
//  Alpha Dog Comic Collector
//
//  Created by Richard Greene on 8/29/17.
//  Copyright © 2017 Richard Greene. All rights reserved.
//

import UIKit



func MD5(_ string: String) -> String? {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)
    if let d = string.data(using: String.Encoding.utf8) {
        _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in CC_MD5(body, CC_LONG(d.count), &digest) } }
    return (0..<length).reduce("") { $0 + String(format: "%02x", digest[$1]) }

}

class SearchNewTableViewController: UITableViewController, UISearchBarDelegate {
 
    @IBOutlet var comictitle: UITableView!
    
    var titles: [String]?
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar button clicked")
        searchBar.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let timeStampString = formatter.string(from: Date() as Date)
        let privateKey = "3b4b700552379e522aef7628a9d6f86d38492027" as String
        let publicKey = "3e72c9cff900f6c36de7924b3f70038c" as String
        let hash = MD5(timeStampString + privateKey + publicKey)
        
        
        let manager = AFHTTPSessionManager()
        
        let searchParameters:[String:Any] = [ "apikey": "3e72c9cff900f6c36de7924b3f70038c",
                                              "hash": hash!,
                                              "ts": timeStampString
                                              //"title": ""
            
                                              ]
        self.titles = [String]()
        
        manager.get("https://gateway.marvel.com/v1/public/comics", parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject as? [String:AnyObject] {
                            print("Response: " + (responseObject as AnyObject).description)
                            let results = (responseObject["data"]?["results"] as? [[String: AnyObject]])
                            for comic in results!{
                                self.titles?.append(comic ["title"] as! String)
                            }
                            print(self.titles?.count ?? 0)
                            self.comictitle.reloadData()
                            
                        }
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.titles!.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResults", for: indexPath)
            cell.textLabel?.text = self.titles?[indexPath.row]
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

