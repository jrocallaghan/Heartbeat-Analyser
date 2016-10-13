//
//  PSWebViewController.swift
//  VoiceMemos
//
//  Created by Arnold Yong Cheng Yee on 10/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class PSWebViewController: UIViewController {

    @IBOutlet var psweb: UIWebView!
    var PSweb = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

 psweb.loadRequest(NSURLRequest(URL: NSURL(string: PSweb)!))
        
    
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
