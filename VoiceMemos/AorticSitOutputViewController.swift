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
    var URL : NSURL!
    
    //Target Connections
    
    @IBOutlet weak var WaveformView: FDWaveformView!
    @IBOutlet weak var diagnosis1: UILabel!
    //unwind segue
    @IBAction func unwindtoAOSOutput(segue: UIStoryboardSegue){
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
        if segue.identifier == "aosout" {
        let VC2 : AorticSitConditionViewController = segue.destinationViewController as! AorticSitConditionViewController
        VC2.condition = aorticsit
        VC2.URL = self.URL
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
