//
//  NetworkService.swift
//  NoticeNotifier
//
//  Created by Sai Sharan Raj Parepalli on 11/02/21.
//

import Foundation

final class NetworkService: NSObject {
    
    static let sharedInstance = NetworkService()
    
    
    /// Used to Fetch the Notices data from Server
    /// - Parameters:
    ///   - _URLString: The Server URL String
    ///   - completion: The completion closure which sends back the Notice Model data
    func getNotices(from _URLString: String?, completion: @escaping(NoticeModel?) -> Void) {
        guard let noticeUrlString = _URLString, let noticesURL = URL(string: noticeUrlString) else {
            completion(fetchLocalData())
            return
        }
        let noticeRequest = URLRequest(url: noticesURL)
        let dataTask = URLSession.shared.dataTask(with: noticeRequest) { data, response, error in
            if let error = error {
                print("ERROR:" + error.localizedDescription)
                completion(self.fetchLocalData())
            }
            if let noticesData = data, let parsedData = self.parseDataFromJson(data: noticesData) {
                completion(parsedData)
            }
        }
        dataTask.resume()
    }
    
    
    /// This function fetches the notices from locally saved NoticeModel Json file
    /// - Returns: Data object of Notice Model
    func fetchLocalData() -> NoticeModel? {
        guard let localJsonData = self.readFromLocalFile(forName: "Notices"), let notices = self.parseDataFromJson(data: localJsonData) else {
                return nil
        }
        return notices
    }
    
    
    /// This function reads the data from local file
    /// - Parameter name: Local file name
    /// - Returns: Data read
    private func readFromLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"), let jsonData = try String(contentsOfFile:bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    
    /// This function parses the data sent
    /// - Parameter data: Data that needs to be parsed
    /// - Returns: NoticeModel Data object
    private func parseDataFromJson(data: Data) -> NoticeModel? {
        do {
            let decodedData = try JSONDecoder().decode(NoticeModel.self, from: data)
            return decodedData
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
}
