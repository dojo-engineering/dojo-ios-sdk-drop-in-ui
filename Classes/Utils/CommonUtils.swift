//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

struct CommonUtils {
    static func evaluateRegex(regex: String, textToVerify: String?) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: textToVerify)
    }
    
    static func parseResponse<T: Decodable>(_ stringData: String, objectType: T.Type) throws -> T? {
        guard let data = stringData.data(using: .utf8) else {
            // String failed to be converted to data. Very unlikely but just in case.
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func parseResponseToCompletion<T: Decodable>(stringData: String?,
                                                        fetchError: Error?,
                                                        objectType: T.Type,
                                                        completion: ((T?, Error?) -> Void)?) {
        // check for an error
        if let error = fetchError {
            completion?(nil, error)
            return
        }
        // verify that we have data from backed
        guard let stringData = stringData else {
            completion?(nil, NSError(domain: #function, code: 7770, userInfo: nil))
            return
        }
        // try to parse backend raw data into object
        do {
            completion?(try CommonUtils.parseResponse(stringData,
                                                      objectType: T.self), nil)
        } catch {
            completion?(nil, error)
        }
    }
}
