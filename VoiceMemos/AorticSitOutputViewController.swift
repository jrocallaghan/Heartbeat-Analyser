//
//  AorticSitOutputViewController.swift
//  VoiceMemos
//
//  Created by Stephanie Lim on 09/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class AorticSitOutputViewController: UIViewController {

    var aorticsit = "darkness"
    var URL : NSURL!
    var aortic = ["AoS-EDM","AoS-Normal","AoS-SMwAS2","AoS-SnDM"]
    
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
        
        signalCompare(aortic)
        
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
            self.aorticsit = type[maxLocationIndex!]
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
