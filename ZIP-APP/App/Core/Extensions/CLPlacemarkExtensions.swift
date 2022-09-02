//
//  CLPlacemarkExtensions.swift
//
//

import Foundation
import CoreLocation

public extension CLPlacemark {
    func friendlyAddress() -> String {
        var components = [String]()

        if let name = self.name {
            components.append(name)
        }

        if let subLocality = self.subLocality {
            components.append(subLocality)
        }

        if let locality = self.locality {
            components.append(locality)
        }

        if let country = self.country {
            components.append(country)
        }

        return components.joined(separator: ", ")
    }
}
