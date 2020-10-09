//
//  LocationVM.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/8/20.
//

import UIKit


protocol LocationVMContract {
    var isLoading: Bool { get }
    var title: String { get }
    var currentLocation: Location { get set }
    var favoriteLocations: [Location] { get }
    var recentLocations: [Location] { get }
    var numberOfSections: Int { get }
    
    func didChangeLocationClosure(callback: @escaping () -> Void)
    func updateCurrent(location: Location)
    func addToFavorite(location: Location)
    func addToRecent(location: Location)
    func title(forSection section: Int) -> String
    func numberOfRows(forSection section: Int) -> Int
    func canEdit(section: Int) -> Bool
    func remove(location: Location, forSection section: LocationTableSection)
    func noRecordsFount(forSection section: LocationTableSection) -> String
}

class LocationVM: LocationVMContract {
    
    // private
    
    private var locationDataDidChange: (() -> Void)?
    
    // public
    
    public var isLoading: Bool = false
    
    public var title: String {
        return "Locations"
    }
    public var currentLocation: Location = Location() {
        didSet {
            locationDataDidChange?()
        }
    }
    public var favoriteLocations: [Location] = [] {
        didSet {
            locationDataDidChange?()
        }
    }
    public var recentLocations: [Location] = [] {
        didSet {
            locationDataDidChange?()
        }
    }
    public var numberOfSections: Int {
        return LocationTableSection.allCases.count
    }
    var hasFavorites: Bool {
        favoriteLocations.count > 0
    }
    var hasRecents: Bool {
        recentLocations.count > 0
    }
    
    // MARK: public methods
    
    public func updateCurrent(location: Location) {
        self.currentLocation = location
    }
    
    public func addToFavorite(location: Location) {
        favoriteLocations.append(location)
    }
    
    public func addToRecent(location: Location) {
        recentLocations .append(location)
    }
    
    public func didChangeLocationClosure(callback: @escaping () -> Void) {
        locationDataDidChange = callback
    }
    
    func title(forSection section: Int) -> String {
        guard let locationSection = LocationTableSection(rawValue: section) else {
            return ""
        }
        return locationSection.title
    }
    
    func noRecordsFount(forSection section: LocationTableSection) -> String {
        switch section {
            case .favorite: return "No Favorites Found"
            case .recent: return "No Recents Found"
            default: return ""
        }
    }
    
    func numberOfRows(forSection section: Int) -> Int {
        let locationSection = LocationTableSection(rawValue: section)
        switch locationSection {
            case .current: return 1
            case .favorite: return hasFavorites ? favoriteLocations.count : 1
            case .recent: return hasRecents ? recentLocations.count : 1
            case .none: return 0
        }
    }
    func canEdit(section: Int) -> Bool {
        let locationSection = LocationTableSection(rawValue: section)
        switch locationSection {
            case .favorite: return hasFavorites
            case .recent: return hasRecents
            default: return false
        }
    }
    func remove(location: Location, forSection section: LocationTableSection) {
        switch section {
            case .favorite:
                if favoriteLocations.contains(location) {
                    favoriteLocations.removeAll(where: { $0 == location })
                }
            case .recent:
                if recentLocations.contains(location) {
                    recentLocations.removeAll(where: { $0 == location })
                }
            default: break
        }
    }
    
    
    // MARK: Init
       
    init(withCurrent location: Location) {
        updateCurrent(location: location)
    }
}
