//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Editted by Jason Wong 
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit


class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var term: String?
    
    
    var filterbusinesses: [Business]!
    var offset = 0
    var isMoreDataLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //search bar init()
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search for restaurants"
        searchBar.delegate = self
        
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem()
        
        
        
        //searchDisplayController?.displaysSearchBarInNavigationBar = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        
        Business.searchWithTerm(term: "Thai", limit: nil, offset: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filterbusinesses = businesses
            print("initial count \(businesses!.count)")
            //self.offset += 20
            self.tableView.reloadData()
            
            
            
            
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.searchBar.text!.isEmpty
        {
            return businesses?.count ?? 0
        }
        return filterbusinesses?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        //let business = self.searchBar.text!.isEmpty ? businesses![indexPath.row] : filterbusinesses![indexPath.row]
        
        cell.business = filterbusinesses[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    //searchs through businesses[]
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.isEmpty {
            filterbusinesses = businesses
        }else {
            filterbusinesses = searchText.isEmpty ? businesses: businesses!.filter { (business: Business) -> Bool in
                return (business.name! as String).range(of: searchText, options: .caseInsensitive) != nil
            }
            
            tableView.reloadData()
            
        }
        
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
            
        }
        
        
    }
    
    func loadMoreData(){
        
        self.offset += 20
        
        Business.searchWithTerm(term: "Thai", limit: nil, offset: self.offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            print("offset is!!!!!! \(self.offset)")
            self.businesses.append(contentsOf: businesses!)
            self.filterbusinesses = self.businesses
            self.isMoreDataLoading = false
            self.tableView.reloadData()
        
            
        })
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


// SearchBar
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    
    }
    
}





