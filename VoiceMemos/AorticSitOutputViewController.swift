//
//  AorticSitOutputViewController.swift
//  VoiceMemos
//
//  Created by Stephanie Lim on 09/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class AorticSitOutputViewController: UIViewController {

    var aorticsit = "sss"
    
    //Target Connections
    
    @IBOutlet weak var waveform: UIView!
    @IBOutlet weak var diagnosis1: UILabel!
    @IBOutlet weak var diagnosis2: UILabel!
    @IBOutlet weak var diagnosis3: UILabel!
    @IBOutlet weak var diagnosis4: UILabel!
    @IBOutlet weak var diagnosis5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

 
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //preparing data for 2nd VC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let VC2 : AorticSitConditionViewController = segue.destinationViewController as! AorticSitConditionViewController
        VC2.condition = aorticsit
        
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
