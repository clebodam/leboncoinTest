//
//  NetWorkService.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation
import SystemConfiguration
enum NetworkError: Error {
    case badUrl(url: String)
    case invalidStatusCode(status: Int)
    case invalidResponse(url: String)
    case noData(url: String)
    case serialization(error: Error)
}

protocol NetWorkManagerProtocol {
    func getData(completion: @escaping ()->())
    func registerDao(_ dao: DaoProtocol)
}

class NetWorkManager<I:ItemProtocol,C:CategoryProtocol>: NetWorkManagerProtocol {

    var session: URLSession
    var sessionCfg: URLSessionConfiguration
    private var dao: DaoProtocol?


    private let ITEMS_URL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"

    private let CATEGORIES_URL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
    private var _currentTask: URLSessionDataTask?

    init() {
        sessionCfg = URLSessionConfiguration.default
        sessionCfg.timeoutIntervalForRequest = 10.0
        session = URLSession(configuration: sessionCfg)
    }

    internal  func get<T>(_ type: T.Type, route: String, callback: ((Result<T, Error>) -> Void)?) where T: Decodable {

        if let task = _currentTask { task.cancel() }

        if let url = URL(string: route) {
            _currentTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let e = error {
                    callback?(Result.failure(e))
                }else {
                    if let r = response as? HTTPURLResponse {
                        if  r.statusCode == 200{
                            if let data = data {
                                do {
                                    print(String(data: data, encoding: .utf8) ?? "")
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                                   let model = try decoder.decode(type, from: data)
                                    callback?(Result.success(model))
                                } catch {
                                    print(error)
                                    callback?(Result.failure(NetworkError.serialization(error: error)))
                                }
                            } else {
                                callback?(Result.failure(NetworkError.noData(url: route)))
                            }
                        }else {
                            callback?(Result.failure(NetworkError.invalidStatusCode(status: r.statusCode)))
                        }
                    }else {
                        callback?(Result.failure(NetworkError.invalidResponse(url: route)))
                    }
                }
            })

            _currentTask?.resume()

        }else {
            callback?(Result.failure(NetworkError.badUrl(url: route)))
        }
    }

   private func getItems(callback: ((Result<[I], Error>) -> Void)?) {
       self.get([I].self, route: ITEMS_URL, callback: callback )
    }

    private func getCategories(callback: ((Result<[C], Error>) -> Void)?) {
        self.get([C].self, route: CATEGORIES_URL, callback: callback )
     }

   public  func getData(completion: @escaping ()->()) {
        getCategories { (catResult) in
            switch catResult {
            case .success(let response):
                self.dao?.saveCategoriesData(items: response)
            case .failure:
               print("fetch categories fail from intenet")
            }
            self.getItems { (ItemsResult) in
                switch ItemsResult {
                case .success(let response):
                    self.dao?.saveItemsData(items: response)
                case .failure:
                   print("fetch items fail from intenet")
                }
                completion()
            }
        }
    }

    public func registerDao(_ dao: DaoProtocol) {
        self.dao = dao
    }
}

public class Reachability {
    public static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* ------- Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         return isReachable && !needsConnection
         */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
}
