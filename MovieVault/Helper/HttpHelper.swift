//
//  HttpHelper.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 21/05/25.
//

import RxSwift
import Alamofire
import Foundation

struct ErrorResponse: Decodable {
    let success: Bool?
    let message: String?
}


class HttpHelper{
    static func request<T: Decodable >(_ endpoint: String, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> Observable<T> {
 
        return Observable.create { observer in

            let apiKey = Secrets.apiKey
            let urlString = "https://api.themoviedb.org/3\(endpoint)api_key=\(apiKey)"
            
            let request = AF.request(urlString, method: method, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        observer.onNext(decodedData)
                        observer.onCompleted()
                    case .failure(let error):
                        if let err = error.asAFError, err.isSessionTaskError{
                            let nsError = NSError(
                                domain: "No Connection", code: 404
                            )
                            observer.onError(nsError)
                        } else {
                            if let data = response.data {
                                do {
                                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                    
                                    let statusCode = response.response?.statusCode ?? 404
                                    let nsError = NSError(
                                        domain: errorResponse.message ?? "Invalid Response",
                                        code: statusCode,
                                        userInfo: [NSLocalizedDescriptionKey: errorResponse.message ?? "Invalid Response"]
                                    )
                                    observer.onError(nsError)
                                } catch {
                                    observer.onError(error)
                                }
                            } else {
                                observer.onError(error)
                            }
                        }
                    }
                }
        
            return Disposables.create {
                request.cancel()
            }

        }
    }

}
