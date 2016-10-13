//
//  ASWebViewController.swift
//  VoiceMemos
//
//  Created by Arnold Yong Cheng Yee on 13/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class ASWebViewController: UIViewController {
    
    @IBOutlet weak var asweb: UIWebView!
    var ASweb = String ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         asweb.loadRequest(NSURLRequest(URL: NSURL(string: ASweb)!))
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
