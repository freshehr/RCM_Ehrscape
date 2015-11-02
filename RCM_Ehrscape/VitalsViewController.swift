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
    
    func ReloadViewTable(){
        
        
        let ehr:EHR = EHR();
        
        ehr.getEHRId("115",subjectNamespace:"uk.nhs.hospital_number",
            success: { (ehrUid) -> () in
                let ehrId = ehrUid
                let aqlString: String =
                    "select b_a/data[at0002]/events[at0003]/data[at0001]/items[at0004]/value/magnitude as HR," +
                    "b_b/data[at0001]/events[at0002]/data[at0003]/items[at0006]/value/numerator as spO2," +
                    "b_c/data[at0002]/events[at0003]/data[at0001]/items[at0004]/value/magnitude as Temp," +
                    "b_d/data[at0001]/events[at0006]/data[at0003]/items[at0004]/value/magnitude as Systolic," +
                    "b_d/data[at0001]/events[at0006]/data[at0003]/items[at0005]/value/magnitude as Diastolic," +
                    "b_f as Symptom, b_g/data[at0001]/events[at0002]/data[at0003]/items[at0004,'Comments']/value as Comments," +
                    "a/uid/value as uid," +
                    "a/context/start_time/value as Date " +
                    "from EHR e[ehr_id/value='\(ehrId)'] " +
                    "contains COMPOSITION a[openEHR-EHR-COMPOSITION.report.v1] " +
                    "contains (OBSERVATION b_a[openEHR-EHR-OBSERVATION.pulse.v0] or OBSERVATION b_b[openEHR-EHR-OBSERVATION.indirect_oximetry.v1] or OBSERVATION b_c[openEHR-EHR-OBSERVATION.body_temperature.v1] or     OBSERVATION b_d[openEHR-EHR-OBSERVATION.blood_pressure.v1] or CLUSTER b_f[openEHR-EHR-CLUSTER.symptom.v0] or OBSERVATION b_g[openEHR-EHR-OBSERVATION.story.v1]) " +
                    "where a/name/value='Patient Remote Chemo monitoring' " +
                    "order by a/context/start_time/value desc offset 0 limit 1"
                
                let query:EHRquery = EHRquery()
                query.run(aqlString,
                    success:{
                        (runResponse) -> () in
                        self.aqlResponse = runResponse["resultSet"]
                        self.tableView.reloadData()
                    },
                    failure:{ (errorMessage) -> () in
                        print(errorMessage)
                })
                
                
            },
            failure: {
                (errorMessage) -> () in
                print(errorMessage)
                
        })
        
        
        
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
  //      ReloadVoewTable()
        
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
