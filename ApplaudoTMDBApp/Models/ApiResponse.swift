//
//  ApiResponse.swift
//  ApplaudoTMDBApp
//
//  Created by Gabriel Rico on 5/2/21.
//

import Foundation
import UIKit

class ApiResponse: NSObject {
  
  var status = Bool()
  var statusCode = HTTPResponseCode(rawValue: 0)
  var data = [String:Any]()
  var responseFor : ApiResponseType
  var message = ""
  
  init(status:Bool, response:[String:Any], responseType:ApiResponseType, msg:String) {
    self.status = status
    self.data = response
    self.responseFor = responseType
    self.message = msg
  }
  
}
