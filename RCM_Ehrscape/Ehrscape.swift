//
//  ehrscape.swift
//  RCM_Ehrscape
//  Code4Health Ehrscape Library in Swift
//
//  Created by Ian McNicoll on 17/10/2015.
//  Copyright © 2015 Ian McNicoll.


import Foundation
import Alamofire
import SwiftyJSON

let rootURL = "https://ehrscape.code-4-health.org/rest/v1"

let defaultApiHeaders = [
    "Authorization": "Basic YzRoX3JpcHBsZV9yY206T01lU2NoQVI="]

public class EhrscapeTemplate {
    
    
    var templateId: String?
    var createdOn: String?
    
    init(pTemplateId : String, pCreatedOn : String) {
        templateId = pTemplateId;
        createdOn = pCreatedOn;
    }
}

public class EhrscapeTemplateList {
    public var count: Int = 0;
    public var templates: [EhrscapeTemplate] = [];

    public func readList(success: (JSON) -> (), failure: (String) -> ()){
     
        let Endpoint: String =  rootURL + "/template";
    
        Alamofire.request(.GET, Endpoint, headers : defaultApiHeaders)
              .responseJSON { response in
                // hate this but responseJSON gives us AnyObject? while JSON() expects AnyObject
                if let data: AnyObject = response.result.value
                {
                    let post = JSON(data)["templates"]
                    self.count = post.count;
                    for index in 0...self.count-1 {
                        self.templates.append(EhrscapeTemplate(pTemplateId: post[index]["templateId"].string!, pCreatedOn: post[index]["createdOn"].string!))
                    }
                    success(JSON(data))
                }
                else
                {
                    failure("error parsing templateList")
                }
            }
        }
    }


public class EHRquery {
    
    let endPoint: String =  rootURL + "/query"

    public func run (aqlString : String,success: (JSON) -> (), failure: (String) -> ()){
        
        Alamofire.request(.GET, endPoint, parameters: ["aql": aqlString], headers : defaultApiHeaders)
            .responseJSON { response in
                // hate this but responseJSON gives us AnyObject? while JSON() expects AnyObject
                if let data: AnyObject = response.result.value
                {
                   success(JSON(data))
                }
                else
                {
                    failure("error parsing query")
                }
           }
    }

}


public class  EHR{
    
    let endPoint: String =  rootURL + "/ehr"
    
    public func getEHRStatus (subjectId : String,subjectNamespace: String, success: (JSON) -> (), failure: (String) -> ()){
        
        Alamofire.request(.GET, endPoint, parameters: ["subjectId": subjectId,"subjectNamespace":subjectNamespace], headers : defaultApiHeaders)
            .responseJSON { response in
                // hate this but responseJSON gives us AnyObject? while JSON() expects AnyObject
                
                print("Request: \(response.request)")
                print("Response: \(response.result)")
                if let data: AnyObject = response.result.value
                {
                    success(JSON(data)["ehrId"])
                }
                else
                {
                    failure("error parsing query")
                }
        }
    }
    
    public func getEHRId (subjectId : String,subjectNamespace: String, success: (String) -> (), failure: (String) -> ()){
        
        print (defaultApiHeaders)
        Alamofire.request(.GET, endPoint, parameters: ["subjectId": subjectId,"subjectNamespace":subjectNamespace], headers : defaultApiHeaders)
                   .responseJSON { response in
               
                
            //    print("Request: \(response.request)")
            //    print("Response: \(response.result)")

                // hate this but responseJSON gives us AnyObject? while JSON() expects AnyObject
                if let data: AnyObject = response.result.value
                {
                    success(JSON(data)["ehrId"].string!)
                }
                else
                {
                    failure("error parsing query")
                }
            }
//     .response { request, response, data, error in
//                print("REQ:\(request)")
//                print("")
//                print("RSP:\(response)")
//                   print("")
//                print(data)
//                print(error)
//            }
    
    }

}

public class  EHRcomposition{
    
    let endPoint: String =  rootURL + "/composition"
    
    public func getJSONComposition (compositionId: String, format: String, success: (JSON) -> (), failure: (String) -> ()){
        
        Alamofire.request(.GET, endPoint + "/" + compositionId, parameters: ["format":format], headers : defaultApiHeaders)
            .responseJSON { response in
                // hate this but responseJSON gives us AnyObject? while JSON() expects AnyObject
                if let data: AnyObject = response.result.value
                {
                    success(JSON(data))
                }
                else
                {
                    failure("error parsing composition")
                }
        }
    }
    
    public func postEHRComposition (ehrId: String, templateId: String,format: String, committerName: String,committerId: String, composition: String, success: (JSON) -> (), failure: (String) -> ()){
        
        Alamofire.request(.POST, endPoint + "/" + ehrId, parameters: ["templateId":templateId,"format":format,"committerName":committerName, "committerId":committerId],
            headers : defaultApiHeaders)
            .responseJSON { response in
                // hate this but responseJSON gives us AnyObject? while JSON() expects AnyObject
                if let data: AnyObject = response.result.value
                {
                    success(JSON(data))
                }
                else
                {
                    failure("error parsing composition")
                }
        }
    }
    
    public func putEHRComposition (compositionId: String,templateId: String,format: String, committerName: String,committerId: String, composition: String, success: (JSON) -> (), failure: (String) -> ()){
        
        Alamofire.request(.PUT, endPoint + "/" + compositionId, parameters: ["templateId":templateId,"format":format,"committerName":committerName, "committerId":committerId],
            headers : defaultApiHeaders)
            .responseJSON { response in
                // hate this but responseJSON gives us AnyObject? while JSON() expects AnyObject
                if let data: AnyObject = response.result.value
                {
                    success(JSON(data))
                }
                else
                {
                    failure("error parsing composition")
                }
        }
    }
    
    
}
