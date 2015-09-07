//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, FiltersViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var businesses: [Business]!
    var filteredBusinessess: [Business]!
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // These two properties must be set in order to use auto layout and ensure the scroll bar appears at a sane size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense.  Should set probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        // Creates a sized-to-fit search bar in place of the navigation controller header
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Filter by name"
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: [], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            println("Initial Search")
            self.businesses = businesses
//            self.filteredBusinessess = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinessess != nil {
            return filteredBusinessess.count
        } else if  businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if filteredBusinessess != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
            
            cell.business = filteredBusinessess[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
            
            cell.business = businesses[indexPath.row]
            
            return cell
        }
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        filteredBusinessess = searchText.isEmpty ? businesses : businesses.filter() {
            if let name = ($0 as Business).name as String! {
                return name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            } else {
                return false
            }
        }
        
//        Debugging to make sure this works. It does.
        var debugBusinessStrings = [String]()
        
        for businessname in filteredBusinessess {
            debugBusinessStrings.append(businessname.name!)
        }
        
        println(debugBusinessStrings)
        println(filteredBusinessess.count)
        
        tableView.reloadData()
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        var categories = filters["categories"] as? [String]
        
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.filteredBusinessess = businesses
            self.tableView.reloadData()
        }
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
}
