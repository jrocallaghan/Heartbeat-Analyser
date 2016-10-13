//
//  PulmSupineOutputViewController.swift
//  VoiceMemos
//
//  Created by Stephanie Lim on 09/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class PulmSupineOutputViewController: UIViewController {

    var pulm = "PS-ESMwPSS2"
//Target Connections
    @IBOutlet weak var waveform: UIView!
    @IBOutlet weak var diagnosis1: UILabel!
    @IBOutlet weak var diagnosis2: UILabel!
    @IBOutlet weak var diagnosis3: UILabel!
    @IBOutlet weak var diagnosis4: UILabel!
    @IBOutlet weak var diagnosis5: UILabel!
    @IBOutlet weak var diagnosis6: UILabel!
    @IBOutlet weak var diagnosis7: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let PSVC : PulmSupineConditionViewController = segue.destinationViewController as! PulmSupineConditionViewController
        PSVC.condition = pulm
        
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
