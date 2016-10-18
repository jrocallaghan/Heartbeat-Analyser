//
//  ApexLDOutputViewController.swift
//  VoiceMemos
//
//  Created by Stepanie Lim on 07/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class ApexLDOutputViewController: UIViewController {
    
    var apexld = "emptiness"
    var URL : NSURL!
    var ald = ["ALD-MOSnDM", "ALD-S3Gallop", "ALD-S3nHSM", "ALD-S4Gallop", "ALD-S4nMSM", "ALD-SCwLSM"]
    
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
         signalCompare(self.ald)
   
    }
    func signalCompare(type: [String]){
        
        
        let bundle = NSBundle.mainBundle()
        var matchArray = [Float]()
        
        var match: Float = 0.0
        for name in type {
            let sequenceURL = bundle.URLForResource(name, withExtension: "aiff")!
            match = compareFingerprint(self.URL, sequenceURL)
            print("Match =  \(match)")
            matchArray.append(match)
        }
        
        
        let maxMatch = matchArray.maxElement()  //this is the max match
        let maxLocationIndex = matchArray.indexOf(maxMatch!) //this is the index of the max match if you want to use it for something
        //var maxLocationInt = matchArray.startIndex.distanceTo(maxLocationIndex!)   //this is the index cast as an int if you need to use it
        
        if (maxMatch<0.6) {
            self.diagnosis1.text = "Error have occured. Please re-record the audio file."
        }
        else{
            self.diagnosis1.text = type[maxLocationIndex!]
            apexld = type[maxLocationIndex!]
        }
        
        
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
