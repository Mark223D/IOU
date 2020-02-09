//
//  NotificationHandler.swift
//  IOU
//
//  Created by Mark Debbane on 2/7/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import Foundation
import Firebase

class NotifHandler {
    
    final let server_key = "AAAAT2l5884:APA91bE-QLZCJvn1QZ-Zu3Gf-_On3SA2Orim7skrKQWYqZXYzzLkpOdviGAPZk0LZTnBy3nFEIGDGUsM9ULhseRTzr7f0cNx4mSe-tm5EYe3xNXtPW4sLcwNP6ZmWDjlPqGwauEMK8pQ"
   func sendPushNotification(to token: String, title: String, body: String) {
       let urlString = "https://fcm.googleapis.com/fcm/send"
       let url = NSURL(string: urlString)!
       let paramString: [String : Any] = ["to" : token,
                                          "notification" : ["title" : title, "body" : body,"sound": "default", "alert": true],
                                          "data" : ["user" : "test_id"]
       ]
       let request = NSMutableURLRequest(url: url as URL)
       request.httpMethod = "POST"
       request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       request.setValue("key=\(server_key)", forHTTPHeaderField: "Authorization")
       let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
           do {
               if let jsonData = data {
                   if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                       NSLog("Received data:\n\(jsonDataDict))")
                   }
               }
           } catch let err as NSError {
               print(err.debugDescription)
           }
       }
       task.resume()
   }

    
//    let userToken = "your specific user's firebase registration token"
//    let notifPayload: [String: Any] = ["to": userToken,"notification": ["title":"You got a new meassage.","body":"This message is sent for you","badge":1,"sound":"default"]]
//   self.sendPushNotification(payloadDict: notifPayload)
   
}
