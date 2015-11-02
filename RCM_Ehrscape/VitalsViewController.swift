//
//  ViewController.swift
//  RCM_Ehrscape
//
//  Created by Ian McNicoll on 16/10/2015.
//  Copyright © 2015 Ian McNicoll. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class VitalsViewController: UITableViewController {

    var aqlResponse:JSON = []
    var compositionList:  ChemoMonitorList = ChemoMonitorList();
 
    // MARK: Properties
   
    
    // MARK: Actions
   
    func ReloadTable(maxRows: Int){
        
        compositionList.readCompositions(maxRows,
            success: {
                (compositionCount) -> () in
                self.tableView.reloadData()
            })
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ReloadTable(1)
        
    }

    override func tableView(tableView: (UITableView!), numberOfRowsInSection section: Int) -> Int {
        //return self.aqlResponse.count;
        return compositionList.compositions.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tempCell", forIndexPath: indexPath)
     //   cell.textLabel?.text = self.aqlResponse[indexPath.item]["Temp"].description
         cell.textLabel?.text =
            "HR = \(compositionList.compositions[indexPath.item].heartRate) " +
            "Temp = \(compositionList.compositions[indexPath.item].temperature) " +
            "Sys = \(compositionList.compositions[indexPath.item].systolicBP) " +
           "Dia = \(compositionList.compositions[indexPath.item].diastolicBP) " +
           "spO2 = \(compositionList.compositions[indexPath.item].spO2) " +
           "Comments = \(compositionList.compositions[indexPath.item].Comments) " +
            "Date = \(compositionList.compositions[indexPath.item].startDate) "
        
        return cell
    }

}
