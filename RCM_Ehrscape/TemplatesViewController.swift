//
//  ViewController.swift
//  RCM_Ehrscape
//
//  Created by Ian McNicoll on 16/10/2015.
//  Copyright © 2015 Ian McNicoll. All rights reserved.
//

import UIKit
import SwiftyJSON


class TemplatesViewController: UIViewController {

    let templateList = EhrscapeTemplateList()
    // MARK: Properties
   
    @IBOutlet weak var lblSymptom: UILabel!
    @IBOutlet weak var txtSymptom: UITextField!
 
    @IBOutlet weak var tableViewer: UITableView!
 
    
    // MARK: Actions
    
    @IBAction func btnSymptoms(sender: AnyObject) {
        
        templateList.readList({ (jsonData) -> () in
            let templateJson: JSON = jsonData
            print(templateJson.rawString())
        },
        failure: { (errorMessage) -> () in
            print(errorMessage)
        });
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return templateList.count;
    }
    
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"cell")
        cell.textLabel?.text = templateList.templates[indexPath.row].templateId
        
        return cell
    }

}