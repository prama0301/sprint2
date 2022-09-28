//
//  CategoryViewController.swift
//  sprint2
//
//  Created by Capgemini-DA164 on 9/25/22.
//

import UIKit
import Alamofire

class CategoryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
  
  
    
//creating a category arrray to save the fetch data
    var categoryArray : [String] = []
 //   var productUrl: String = "https://dummyjson.com/products/category/"
  //  var category: String = ""
    @IBOutlet weak var categoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "Category"
        self.title = "Categories"
jasonParsing()
        // Do any additional setup after loading the view.
    }
    
    func jasonParsing() {
        Alamofire.request("https://dummyjson.com/products/categories", method: .get).responseJSON { (response) in
            //creating a json response
            if let json = response.result.value {
                self.categoryArray = json as! [String]
            }
            DispatchQueue.main.async {
                self.categoryTable.delegate = self
                self.categoryTable.dataSource = self
                self.categoryTable.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.categoryTable.dequeueReusableCell(withIdentifier: "Category", for: indexPath) as! CategoryTableViewCell
       
         cell.categoryLabel.text = (categoryArray[indexPath.row] as AnyObject) as? String
         
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90.0
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
      // categoryTable.deselectRow(at: indexPath, animated: true)
        
      // performSegue(withIdentifier: "Product", sender: self)
        
        let productVC = self.storyboard?.instantiateViewController(withIdentifier: "Product") as! ProductViewController
        productVC.category = categoryArray[indexPath.row] 
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}
