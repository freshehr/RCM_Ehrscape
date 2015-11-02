//
//  RCM_ehrscape.swift
//  RCM_Ehrscape
//
//  Created by Ian McNicoll on 01/11/2015.
//  Copyright © 2015 Ian McNicoll. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ChemoMonitorComposition
{
    public var subjectId : String = ""
    public var subjectNamespace: String = ""
    public var startDate : NSDate
    public var composer: String = ""
    public var systolicBP : Float = 0.0
    public var diastolicBP: Float = 0.0
    public var heartRate: Float = 0.0
    public var respirations: Float = 0.0
    public var temperature: Float = 0.0
    public var spO2: Float = 0.0
    public var howRUCode: String = ""
    public var Comments: String = ""
    
    private var ehrId : String = ""
    public var compositionId : String = ""
    
    
    init(){
        startDate = NSDate()
    };
}

public class ChemoMonitorList
{
    public var compositions :[ChemoMonitorComposition] = []
    private var aqlResponse:JSON = []

    public func readCompositions(maxRows: Int, success:(Int) -> ()){
        
        let ehr:EHR = EHR()
        
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
                    "a/context/start_time/value as Date, " +
                    "a/composer/name as Composer_name " +
                    "from EHR e[ehr_id/value='\(ehrId)'] " +
                    "contains COMPOSITION a[openEHR-EHR-COMPOSITION.report.v1] " +
                    "contains (OBSERVATION b_a[openEHR-EHR-OBSERVATION.pulse.v0] or OBSERVATION b_b[openEHR-EHR-OBSERVATION.indirect_oximetry.v1] or OBSERVATION b_c[openEHR-EHR-OBSERVATION.body_temperature.v1] or OBSERVATION b_d[openEHR-EHR-OBSERVATION.blood_pressure.v1] or CLUSTER b_f[openEHR-EHR-CLUSTER.symptom.v0] or OBSERVATION b_g[openEHR-EHR-OBSERVATION.story.v1]) " +
                    "where a/name/value='Patient Remote Chemo monitoring' " +
                    "order by a/context/start_time/value desc offset 0 limit \(maxRows)"
                
  //              print(aqlString)
                let query:EHRquery = EHRquery()
                query.run(aqlString,
                    success:{
                        (runResponse) -> () in
                        self.aqlResponse = runResponse["resultSet"]
                        for index in 0...self.aqlResponse.count-1 {
                            
                            let newComp = ChemoMonitorComposition()
                            
                            newComp.compositionId = self.aqlResponse[index]["uid"].string!
                            newComp.startDate = returnNSDate(self.aqlResponse[index]["Date"].string!)
 //                           newComp.composer = self.aqlResponse[index]["Composer"].string!
                            newComp.systolicBP = self.aqlResponse[index]["Systolic"].float!
                            newComp.diastolicBP = self.aqlResponse[index]["Diastolic"].float!
                            newComp.temperature = self.aqlResponse[index]["Temp"].float!
                            newComp.spO2 = self.aqlResponse[index]["spO2"].float!
                            newComp.heartRate = self.aqlResponse[index]["HR"].float!
  //                          newComp.Comments = self.aqlResponse[index]["Comments"].string!
                            //      newComp.howRUCode = aqlResponse[index]["Composer"].string!
                            
                            self.compositions.append(newComp)
                            success(self.compositions.count);
                        }

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
    
    public func writeCompositions(){
        
    }
}


public func returnIsoDate(nsDate: NSDate)-> String {
    let dateFormatter = NSDateFormatter()
    let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    return dateFormatter.stringFromDate(NSDate())
}

public func returnNSDate(isoDate: String)-> NSDate {
 //   let dateFormatter = NSDateFormatter()
 //   dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
 //   dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
 //   let testDate = "2015-06-04T04:00"
 //   return dateFormatter.dateFromString(testDate)!
    
    let dateString = "2014-07-06T07:59:00Z"
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    return dateFormatter.dateFromString(dateString)!
    
}