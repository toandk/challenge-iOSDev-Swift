//
//  APIController.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftyJSON

class APIController {
    func bodyForSTTRequest(_ filePath: String) -> Data? {
//        let filePath = Bundle.main.path(forResource: "sound1", ofType: "caf")!
        let configRequest: [String: Any] = [
            "encoding": "LINEAR16",
            "sampleRateHertz": String(AppConstants.SAMPLE_RATE),
            "languageCode": "en-US",
            "maxAlternatives": "30"]
        let audioData = NSData(contentsOfFile: filePath)
        let audioRequest: [String: Any] = ["content": audioData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) ?? ""]
        let params = ["config": configRequest,
                      "audio": audioRequest]
        
        return try? JSONSerialization.data(withJSONObject: params, options: [])
    }
    
    func createRequest(url: URL, method: String, body: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getTextFromAudio(filePath: String) -> SignalProducer<String?, NSError> {
        let url = URL(string: String(format: "%@?key=%@", AppConstants.GG_SPEECH_TO_TEXT_URL, AppConstants.GG_API_KEY))!
        let request = createRequest(url: url, method: "POST", body: bodyForSTTRequest(filePath))
        
        return URLSession.shared.reactive.data(with: request)
            .flatMapError { error in
                print("Network error occurred: \(error.localizedDescription)")
                return SignalProducer.empty
            }
            .map { (data, response) -> String? in
                if let json = try? JSON(data: data) {
                    if let result = json["results"][0]["alternatives"][0]["transcript"].string {
                        return result
                    }
                }
                return nil
        }
    }
}
