//
//  ProductViewController.swift
//  sprint2
//
//  Created by Capgemini-DA164 on 9/26/22.
//

import UIKit
import Alamofire
import AlamofireImage

class ProductViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    
//MARK: Outlets
    var productArray =  NSArray()
    @IBOutlet weak var productTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
getProductDetail()
        // Do any additional setup after loading the view.
    }
   
    // function to fetch product detail from Alamofire
    func getProductDetail() {
        let url = "https://dummyjson.com/products/category/smartphones"
        //requesting Alamofire to fetch Data from Alamofire
         Alamofire.request(url, method: .get).responseJSON(completionHandler: {
             response in
             let json = response.result.value as! NSDictionary
             self.productArray = json.value(forKey: "products") as! NSArray
             
             DispatchQueue.main.async {
                 self.productTable.delegate = self
                 self.productTable.dataSource = self
                 self.productTable.reloadData()
             }
         })
        
    }
    
    //MARK: TableView DataSource and Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTable.dequeueReusableCell(withIdentifier: "ProductTable", for: indexPath) as! ProductTableViewCell
        let product = productArray[indexPath.row] as! NSDictionary
        cell.productTitle?.text = product.value(forKey: "title") as? String
        cell.productBrand?.text = product.value(forKey: "brand") as? String
        cell.productDescription?.text = product.value(forKey: "description") as? String
        
        let url = URL(string: (product.value(forKey: "thumbnail") as! String))
        if let imageData = try? Data(contentsOf: url!) {
            if let loadImage = UIImage(data: imageData){
                cell.productImage.image = loadImage
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productTable.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "Location", sender: self)
    }
    
}
