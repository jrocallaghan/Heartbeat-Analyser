//
//  ApexSupineOutputViewController.swift
//  VoiceMemos
//
//  Created by Stephanie Lim on 02/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit
import FDWaveformView
import Foundation


class ApexSupineOutputViewController: UIViewController {
    
    var URL : NSURL!

    ///TEST ONLY/////
    ////CHANGE AFTER////////
    var apexsup = "nothing"
    var supine = ["AS-ESM", "AS-HSM","AS-LSM", "AS-MSC","AS-MSM","AS-Normal","AS-SplitS1"]
    //var supine = ["AS-SplitS1"]
    
    
    //unwind segue
    @IBAction func unwindtoASOutput(segue: UIStoryboardSegue){
    }
    
    //Setting up waveform view and waeform target connection
    @IBOutlet weak var WaveformView: FDWaveformView!
    

    
    //Diagnosis labels target connections
    @IBOutlet weak var Diagnosis1: UILabel!

    
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
            if segue.identifier == "asout" {
            let VC2 : ApexSupineConditionViewController = segue.destinationViewController as! ApexSupineConditionViewController
            VC2.condition = apexsup
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
        
       signalCompare(self.supine)
    }

    func signalCompare(type: [String]){
    
        
        var bundle = NSBundle.mainBundle()
        var matchArray = [Float]()

        var match: Float = 0.0
        for name in type {
            var sequenceURL = bundle.URLForResource(name, withExtension: "aiff")!
            match = compareFingerprint(self.URL, sequenceURL)
            print("Match =  \(match)")
            matchArray.append(match)
        }
        
        
        var maxMatch = matchArray.maxElement()  //this is the max match
        var maxLocationIndex = matchArray.indexOf(maxMatch!) //this is the index of the max match if you want to use it for something
        //var maxLocationInt = matchArray.startIndex.distanceTo(maxLocationIndex!)   //this is the index cast as an int if you need to use it
        
        
        if (maxMatch<0.4) {
            self.Diagnosis1 = "error no good match found"
        }
        else{
            self.Diagnosis1 = "maxmatch"
        }
        self.apexsup = type[maxLocationIndex!]
        
        
        
    }

}

            
  /*
            
            self.Diagnosis1.text = type[0] + ": \(matchArray[0])"
            self.Diagnosis2.text = type[1] + ": \(matchArray[1])"
            self.Diagnosis3.text = type[2] + ": \(matchArray[2])"
            self.Diagnosis4.text = type[3] + ": \(matchArray[3])"
            if (typeSize>4){
                self.Diagnosis5.text = type[4] + ": \(matchArray[4])"
                self.Diagnosis6.text = type[5] + ": \(matchArray[5])"
                if (typeSize>6){                                            // These if statements make sure the data shows properly since we have
                    self.Diagnosis7.text = type[6] + ": \(matchArray[6])"   //different amounts of audio files for each category
                    
                }
            }
            self.apexsup = type[maxLocationIndex!]
            
            switch maxLocationInt {
            case 0:
                self.Diagnosis1.textColor = UIColor.redColor()
            case 1:
                self.Diagnosis2.textColor = UIColor.redColor()
            case 2:
                self.Diagnosis3.textColor = UIColor.redColor()
            case 3:
                self.Diagnosis4.textColor = UIColor.redColor()
            case 4:
                self.Diagnosis5.textColor = UIColor.redColor()
            case 5:
                self.Diagnosis6.textColor = UIColor.redColor()
            case 6:
                self.Diagnosis7.textColor = UIColor.redColor()
            default:
                print("error has occurred changing text colour") //This probably wont happen
            }
            
            //let diagnosisAlert = UIAlertController(title: "Diagnosis", message: "\(type[maxLocation!])", preferredStyle: .Alert)
            //let okButton = UIAlertAction(title: "OK", style: .Default){(diagnosisAlert: UIAlertAction!)->Void in }
            //diagnosisAlert.addAction(okButton)
            //self.presentViewController(diagnosisAlert, animated: true, completion: nil)

        })


}
*/
