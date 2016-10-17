//
//  ApexLDOutputViewController.swift
//  VoiceMemos
//
//  Created by Stepanie Lim on 07/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class ApexLDOutputViewController: UIViewController {
    
    var apexld = "ALD-S3Gallop"
    var URL : NSURL!
    
    //Target Connections
    @IBOutlet weak var waveform: FDWaveformView!
    @IBOutlet weak var diagnosis1: UILabel!
    
    //unwind segue
    @IBAction func unwindtoALDOutput(segue: UIStoryboardSegue){
    }
    
   
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
        if segue.identifier == "aldout" {
        let VC2 : ApexLDConditionViewController = segue.destinationViewController as! ApexLDConditionViewController
        VC2.condition = apexld
        VC2.URL = self.URL
        }
        
    }

    
    override func viewDidAppear(animated: Bool) {
        
        self.waveform.audioURL = URL
        self.waveform.progressSamples = 0
        self.waveform.doesAllowScroll = true
        self.waveform.doesAllowStretch = true
        self.waveform.doesAllowScrubbing = false
        self.waveform.wavesColor = UIColor.blueColor()

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
