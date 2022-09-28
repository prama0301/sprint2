//
//  NotificationViewController.swift
//  sprint2
//
//  Created by Capgemini-DA164 on 9/26/22.
//

import UIKit
import Framework_Notification

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func localNotification(_ sender: Any) {
        Notification().localNotification()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
