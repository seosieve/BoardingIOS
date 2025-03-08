//
//  LocationInfoViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class LocationInfoViewModel {
    
    let locationAddress = PublishRelay<String>()
    let marker = PublishRelay<(String,String)>()
    
    init(latitude: Double, longitude: Double) {
        getAddress(latitude: latitude, longitude: longitude)
    }
    
    func geocodingUrl(_ latitude: Double, _ longitude: Double) -> URL? {
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json"
        let location = "\(latitude),\(longitude)"
        let key = APIKey.googleMap
        let urlString = "\(baseUrl)?latlng=\(location)&key=\(key)"
        return URL(string: urlString)
    }
    
    func getAddress(latitude: Double, longitude: Double) {
        if let url = geocodingUrl(latitude, longitude) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("dataTask error: \(error)")
                } else if let data = data {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Geo.self, from: data) {
                        if let firstResult = json.results.first {
                            let address = firstResult.formatted_address
                            self?.locationAddress.accept(address)
                            
                            let placeID = firstResult.place_id
                            self?.getAddressInfo(placeID: placeID)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func placesUrl(_ placeID: String) -> URL? {
        let baseUrl = "https://maps.googleapis.com/maps/api/place/details/json"
        let placeID = "\(placeID)"
        let key = APIKey.googleMap
        let urlString = "\(baseUrl)?language=ko&placeid=\(placeID)&key=\(key)"
        return URL(string: urlString)
    }
    
    func getAddressInfo(placeID: String) {
        if let url = placesUrl(placeID) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("dataTask error: \(error)")
                } else if let data = data {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Place.self, from: data) {
                        let name = json.result.name
                        let vicinity = json.result.vicinity
                        self?.marker.accept((name, vicinity))
                    }
                }
            }
            task.resume()
        }
    }
    
    func showGoogleMap(location: String?) {
        guard let location = location else { return }
        if let encodedQuery = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "comgooglemaps://?q=\(encodedQuery)") {
            if UIApplication.shared.canOpenURL(url) {
                //GoogleMap 깔려있을때
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                //GoogleMap 깔려있지않을때
                if let url = URL(string: "https://www.google.com/maps?q=\(encodedQuery)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
