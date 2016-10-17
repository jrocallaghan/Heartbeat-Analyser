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
    var URL : NSURL!
    
//Target Connections
    @IBOutlet weak var diagnosis1: UILabel!
    @IBOutlet weak var WaveformView: FDWaveformView!
    
    //unwind segue
    @IBAction func unwindtoPSOutput(segue: UIStoryboardSegue){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "psout" {
        let PSVC : PulmSupineConditionViewController = segue.destinationViewController as! PulmSupineConditionViewController
        PSVC.condition = pulm
            PSVC.URL = self.URL
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.WaveformView.audioURL = URL
        self.WaveformView.progressSamples = 0
        self.WaveformView.doesAllowScroll = true
        self.WaveformView.doesAllowStretch = true
        self.WaveformView.doesAllowScrubbing = false
        self.WaveformView.wavesColor = UIColor.blueColor()
        
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
