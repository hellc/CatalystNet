//
//  URLRequest+MultipartFormData.swift
//
//  Created by Ivan Manov on 04.08.2020.
//  Copyright © 2020 @hellc. All rights reserved.
//

import Foundation

extension URLRequest {
    
    public mutating func setMultipartFormData(parameters: [String: Any] = [:], files: [CatalystFile] = []) throws {
        let boundary = "Boundary-\(UUID().uuidString)"
        self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        httpBody = {
            let body = NSMutableData()

            for (key, value) in parameters {
                body.appendString(convertFormField(named: key, value: value, using: boundary))
            }
            
            for file in files {
                body.append(self.convertFileData(fieldName: file.fieldName,
                                                 fileName: file.fileName,
                                                 mimeType: file.mimeType,
                                                 fileData: file.data,
                                                 using: boundary))
            }
            
            body.appendString("--\(boundary)--")

            return body as Data
        }()
    }
    
    private func convertFormField(named name: String,
                                  value: Any,
                                  using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    private func convertFileData(fieldName: String,
                                 fileName: String,
                                 mimeType: String,
                                 fileData: Data,
                                 using  boundary: String) -> Data {
        let data = NSMutableData()

        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")

        return data as Data
    }
    
}

public extension NSMutableData {

    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
          self.append(data)
        }
    }

}
