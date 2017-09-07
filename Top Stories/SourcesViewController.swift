//
//  ViewController.swift
//  Top Stories
//
//  Created by Andrew James Kinsey on 9/6/17.
//  Copyright © 2017 The Cabinents. All rights reserved.
//

import UIKit

class SourceViewController: UITableViewController
{

    var sources = [[String: String]]()
    let apiKey = "5d892509a49046a087917c466fa80d09"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "News Source"
        let query = "https://newsapi.org/v1/sources?language=en&country=us&apiKey=\(apiKey)"
        if let url = URL(string: query)
        {
            if let data = try? Data(contentsOf: url) //optional unwrapping "if it's there"
            {
                let json = try! JSON(data: data)     //forced unwrapping
                if json["status"] == "ok"
                {
                    parse(json: json)
                    return
                }
            }
        }
        loadError() //if anything fails
    }
    
    func parse(json: JSON)
    {
        for result in json["sources"].arrayValue
        {
            let id = result["id"].stringValue
            let name = result["name"].stringValue
            let description = result["description"].stringValue
            let source = ["id": id, "name": name, "description": description]
            sources.append(source)
        }
        tableView.reloadData()
    }
    
    func loadError()
    {
        let alert = UIAlertController(title: "Loading Error", message: "There was a problem loading the news feed.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let source = sources[indexPath.row]
        cell.textLabel?.text = source["name"]
        cell.detailTextLabel?.text = source["description"]
        return cell
    }
}

