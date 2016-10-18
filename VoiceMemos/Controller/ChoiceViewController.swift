//
//  ChoiceViewController.swift
//  VoiceMemos
//
//  Created by Stephanie Lim on 30/09/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {

    var inputURL : NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "choicetoas"{
            let controller = segue.destinationViewController as! ApexSupineOutputViewController
            controller.URL = self.inputURL
        }
        else if segue.identifier == "choicetoaos"{
            let controller = segue.destinationViewController as! AorticSitOutputViewController
            controller.URL = self.inputURL
        }
        else if segue.identifier == "choicetoald"{
            let controller = segue.destinationViewController as! ApexLDOutputViewController
            controller.URL = self.inputURL
        }
        else if segue.identifier == "choicetops"{
            let controller = segue.destinationViewController as! PulmSupineOutputViewController
            controller.URL = self.inputURL
        }
        
    }
    
    //unwind segue
    
    @IBAction func unwindtochoice (segue: UIStoryboardSegue){
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

