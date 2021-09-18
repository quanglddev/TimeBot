//
//  SearchHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/20/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension HomeVC: UISearchBarDelegate, UISearchResultsUpdating {
    func setupSearch() {
        //For search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["By words", "By letters"]
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "By letters") {
        
        //Get Missions
        missions.removeAll()
        
        for i in 0..<weekCollection.count {
            for j in 0..<weekCollection[i].count {
                missions += [weekCollection[i][j]]
            }
        }
        
        //Filter same missions
        missions = Array(Set(missions))
        
        filteredMissions = missions.filter { mission in
            let categoryMatch = (scope == "By words")
            if categoryMatch {
                return mission.title.lowercased()[0..<searchText.characters.count].contains(searchText.lowercased())
            }
            else {
                return mission.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        weekTableView.reloadData()
        
        
    }

}
