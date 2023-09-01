//
//  Network.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 30/08/23.
//

import Foundation
import SystemConfiguration

final class Network {
    static let shared = Network()
    private init() {
        
    }
    
    func makeApiRequest<T: Decodable>(url: String, expecting: T.Type, completion: @escaping ((T?, String?)->()) ) {
        
        guard let urlRequest = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            do {
                guard let data = data else {
                    completion(nil, "data not found")
                    return
                }
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    var isConnectedToNetwork : Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        }) else {
            
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
}
