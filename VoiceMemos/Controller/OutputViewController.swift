//
//  OutputViewController.swift
//  VoiceMemos
//
//  Created by Jordan O'Callaghan on 10/09/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit
import FDWaveformView
import Foundation

class OutputViewController: UIViewController {

    @IBOutlet weak var Diagnosis1: UILabel!
    @IBOutlet weak var Diagnosis2: UILabel!
    @IBOutlet weak var Diagnosis3: UILabel!
    @IBOutlet weak var Diagnosis4: UILabel!
    @IBOutlet weak var Diagnosis5: UILabel!
    @IBOutlet weak var Diagnosis6: UILabel!
    @IBOutlet weak var Diagnosis7: UILabel!
    
    @IBOutlet weak var waveform: FDWaveformView!
    var inputURL: NSURL!
    var supine = ["Apex Supine Early Sys Mur", "Apex Supine Holo Sys Mur", "Apex Supine Late Sys Mur", "Apex Supine Mid Sys Click", "Apex Supine Mid Sys Mur", "Apex Supine Single S1 S2", "Apex Supine Split S1"]
    var diagnosisname = String ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    //preparing data for 2nd VC
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let VC2 : ConditionViewController = segue.destinationViewController as! ConditionViewController
//        VC2.highname = diagnosisname
//    
//    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
//        self.Diagnosis1.text = ""
//        self.Diagnosis2.text = ""
//        self.Diagnosis3.text = ""
//        self.Diagnosis4.text = ""
//        self.Diagnosis5.text = ""
//        self.Diagnosis6.text = ""
//        self.Diagnosis7.text = ""
        
//        self.waveform.audioURL = inputURL             ////////UNCOMMMENT THIS BLOCK FOR WAVEFORM
//        self.waveform.progressSamples = 0
//        self.waveform.doesAllowScroll = true          ////////UNCOMMMENT THIS BLOCK FOR WAVEFORM
//        self.waveform.doesAllowStretch = true
//        self.waveform.doesAllowScrubbing = false
//        self.waveform.wavesColor = UIColor.blueColor()     ////////UNCOMMMENT THIS BLOCK FOR WAVEFORM
      

        
       /*
        self.Diagnosis3.text = supine[0] //+" \(match variable)"
        self.Diagnosis4.text = supine[1]
        */
 
        //compareHeartbeat()
        
        self.signalCompare(self.supine)
    }
    
    
    
//    func compareHeartbeat(){
//        
//        
//        let alertController = UIAlertController(title: "Select Measurement Type", message: "Press one of these buttons", preferredStyle: .Alert)
//        //We add buttons to the alert controller by creating UIAlertActions:
//        
//        let actionSupine = UIAlertAction(title: "Apex Supine",
//                                         style: .Default)
//        {(alertController: UIAlertAction!)->Void in
//            
//            self.signalCompare(self.supine)
//            
//        }
//        
//        
//        alertController.addAction(actionSupine)
//        
//        let actionDucubitus = UIAlertAction(title: "Apex Left Ducubitus",
//                                            style: .Default)
//        {(alertController: UIAlertAction!)->Void in
//            
//            self.signalCompare(self.supine)
//        }
//        
//        alertController.addAction(actionDucubitus)
//        
//        let actionAortic = UIAlertAction(title: "Aortic",
//                                         style: .Default)
//        {(alertController: UIAlertAction!)->Void in
//            
//            self.signalCompare(self.supine)
//        }
//        
//        alertController.addAction(actionAortic)
//        
//        let actionPulmonic = UIAlertAction(title: "Pulmonic",
//                                           style: .Default)
//        {(alertController: UIAlertAction!)->Void in
//            
//            self.signalCompare(self.supine)
//        }
//        
//        alertController.addAction(actionPulmonic)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
//        
//        
//    }

        
        func signalCompare(type: [String]){
            
            var detective = LBAudioDetectiveNew()
            var bundle = NSBundle.mainBundle()
            var matchArray = [Float32]()
            
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                (type as NSArray).enumerateObjectsUsingBlock({(sequenceType: Any, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    if let str = sequenceType as? String {
                        
                        var sequenceURL = bundle.URLForResource(str, withExtension: "caf")!
                        
                        var match: Float32 = 0.0
                        LBAudioDetectiveCompareAudioURLs(detective, self.inputURL, sequenceURL, 0, &match)
                        print("Match =  \(match)")
                        matchArray.append(match)
                    }
                })
                
                var maxMatch = matchArray.maxElement()
                var maxLocationIndex = matchArray.indexOf(maxMatch!)
                var maxLocationInt = matchArray.startIndex.distanceTo(maxLocationIndex!)
                var typeSize = type.count
                
                
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
                 self.diagnosisname = type[maxLocationIndex!]
                
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
}