//
//  PulmSupineConditionViewController.swift
//  VoiceMemos
//
//  Created by Stephanie on 05/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class PulmSupineConditionViewController: UIViewController {
//Global variables
    var condition = String()
    var details = String ()
    var diagnosis = String ()
    var siteclicked = String ()
    var URL : NSURL!
    
//Site variables
    var googlesite = String ()
    var mayosite = String()
    var medlinesite = String ()
    
    
//Target Connections
    @IBOutlet weak var WaveformView: FDWaveformView!
    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var labeldetails: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    //unwind segue
    @IBAction func unwindtoPSCond(segue: UIStoryboardSegue){
    }
    
    
    @IBAction func PSweb(sender: AnyObject) {
//        let alert = UIAlertController(title: "Tryout", message: "Message", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "cancel", style: .Destructive, handler: nil))
        
   
        
        // Create the alert controller
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        // Create the actions
        alert.addAction(UIAlertAction(title: "Google", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.siteclicked = self.googlesite
            self.performSegueWithIdentifier("PSsegue", sender:true)
        }))
        
        alert.addAction(UIAlertAction(title: "Mayoclinic", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            self.siteclicked = self.mayosite
            self.performSegueWithIdentifier("PSsegue", sender: true)
        }))
        
        alert.addAction(UIAlertAction(title: "MedlinePlus", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            self.siteclicked = self.medlinesite
            self.performSegueWithIdentifier("PSsegue", sender: true)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    //sending segue to display selected webpage
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
            if(segue.identifier == "PSsegue") {
            let psweb = segue.destinationViewController as! PSWebViewController 
            psweb.PSweb = self.siteclicked}
        }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailscond()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.WaveformView.audioURL = URL
        self.WaveformView.progressSamples = 0
        self.WaveformView.doesAllowScroll = true
        self.WaveformView.doesAllowStretch = true
        self.WaveformView.doesAllowScrubbing = false
        self.WaveformView.wavesColor = UIColor.darkGrayColor()
        labelname.text = diagnosis
        labeldetails.text = details
    }
    
    func detailscond(){
        if details == "PS-ESMwPSS2"{
//referenced from http://www.mayoclinic.org/diseases-conditions/atrial-septal-defect/basics/symptoms/con-20027034
            self.image.image = UIImage(named:"PS-ESMwPSS2")
            diagnosis = "Arterial Septal Defect"
            details = "An ASD is a hole in the wall between the two upper chambers of the heart. Small atrial septal defects may close on their own during infancy or early childhood. Large and long-standing atrial septal defects can damage your heart and lungs. Small defects may never cause a problem and may be found incidentally. An adult who has had an undetected atrial septal defect for decades may have a shortened life span from heart failure."+"\n\n"+"The symptoms may include:"+"\n"+"Shortness of breath, especially when exercising"+"\n"+"1. Fatigue"+"\n"+"2. Swelling of legs, feet or abdomen"+"\n"+"3. Heart palpitations or skipped beats"+"\n"+"4. Frequent lung infections"+"\n"+"5. Stroke"
            googlesite = "https://www.google.com.au/#q=Arterial+Septal+Defect"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/atrial-septal-defect/basics/definition/con-20027034"
            medlinesite = "https://medlineplus.gov/ency/article/000157.htm"
            
        }
//referenced from http://www.mayoclinic.org/diseases-conditions/pulmonary-valve-stenosis/basics/symptoms/con-20013659
        else if details == "PS-ESMwSS2"{
            self.image.image = UIImage(named:"PS-ESMwSS2")
            diagnosis = "Pulmonary Valve Stenosis"
            details = "Pulmonary valve stenosis is a condition in which a deformity on or near your pulmonary valve, the valve that influences the blood flow from your heart to your lungs, slows the blood flow. Adults occasionally have the condition as a complication of another illness, but mostly, pulmonary valve stenosis develops before birth as a congenital heart defect."+"\n"+"The symptoms vary, depending on the extent of the obstruction.Those with more significant stenosis often first notice symptoms while exercising"+"\n\n"+"Symptoms are:"+"\n"+"1. Shortness of breath, especially during exertion"+"\n"+"2. Chest pain"+"\n"+"3. Loss of consciousness"+"\n"+"4. Fatigue"
            googlesite = "https://www.google.com.au/#q=Pulmonary+Valve+Stenosis"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/pulmonary-valve-stenosis/basics/definition/con-20013659"
            medlinesite = "http://www.mayoclinic.org/diseases-conditions/pulmonary-valve-stenosis/basics/definition/con-20013659"
        }
        else if details == "PS-ESMwTSS2"{
//referenced from http://www.heart.org/HEARTORG/Conditions/More/HeartValveProblemsandDisease/Innocent-Heart-Murmur_UCM_450621_Article.jsp#.V_kR0GVKCAY
            self.image.image = UIImage(named:"PS-ESMwTSS2")
            diagnosis = "Innocent Murmur"
            details = "Innocent heart murmurs are harmless sounds made by the blood circulating normally through the heart's chambers and valves or through blood vessels near the heart. Innocent murmurs are common in children and are quite harmless. Innocent murmurs also may disappear and then reappear."+"\n"+"Innocent murmurs do not require medication, do not create cardiac symptoms, and is not a sign of heart problem or heart disease."
            googlesite = "https://www.google.com.au/#q=Innocent+Murmur+"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/heart-murmurs/basics/causes/con-20028706"
            medlinesite = "https://medlineplus.gov/ency/article/003266.htm"
        }
        else if details == "PS-SingleS2"{
            self.image.image = UIImage(named:"PS-SingleS2")
            diagnosis = "Heart Sound of Single S2: Normal in Elderly"
            details = "These is normal among elderly. This is not a sign of heart problem or heart disease. But further test should be runned to elimate the possibility of heart problem or heart diseases. However, patients with obesity, emphysema, pericardial fluid, the pulmonic valve closure(P2) may be too hard to hear causing a single (A2) heart sound."+"\n\n"+"NOTE: Further test should be run on the patient to further classify possible heart risk."
            googlesite = "https://www.google.com.au/#q=single+s2"
            mayosite = "http://www.mayoclinic.org/"
            medlinesite = "http://medlineplus.gov"
            
        }
        else if details == "PS-SplitS2P"{
//referenced from http://www.mayoclinic.org/diseases-conditions/bundle-branch-block/basics/symptoms/con-20027273
            self.image.image = UIImage(named:"PS-SplitS2P")
            diagnosis = "Complete Right Bundle Branch Block"
            details = "In most people, bundle branch block doesn't cause any symptoms. Sometimes, people with the condition don't even know they have a bundle branch block."+"\n"+"A right bundle branck block is normally caused by:"+"\n"+"1. A heart abnormality that's present at birth such as atrial septal defect"+"\n"+"2. A heart attack"+"\n"+"3. A viral or bacterial infection of the heart muscle"+"\n"+"4. High blood pressure (hypertension)"+"\n"+"5. A blood clot in the lungs"+"\n\n"+"This heart condition should be confirmed using ECG."
            googlesite = "https://www.google.com.au/search?client=safari&rls=en&q=Complete+Right+Bundle+Branch+Block&ie=UTF-8&oe=UTF-8&gfe_rd=cr&ei=DfX-V6MZqOvwB9Ofj9gJ"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/bundle-branch-block/basics/definition/con-20027273"
            medlinesite = "http://emedicine.medscape.com/article/894927-differential"
        }
        else if details == "PS-SplitS2T"{
            self.image.image = UIImage(named:"PS-SplitS2T")
            diagnosis = "Normal"
             details = "This person has a normal heartsound. No heart issues found."
            mayosite = "http://www.mayoclinic.org/diseases-conditions/heart-disease/in-depth/heart-disease-prevention/art-20046502"
            googlesite = "https://www.google.com.au/#q=keep+a+healthy+heart"
            medlinesite = "https://medlineplus.gov/magazine/issues/winter10/articles/winter10pg8.html"
        }
        else {
            diagnosis = "This sound file is corrupted"
            self.image.image = UIImage(named:"error")
            details = "Error! Please re-record a new sound file."+"\n\n\n"+"Notice: Please ensure patient is not talking and breathing normally when heart sound is taken."
            googlesite = "http://www.wikihow.com/Take-Your-Own-Pulse-With-a-Stethoscope"
            mayosite = "http://www.livestrong.com/article/252191-how-to-listen-to-a-heartbeat/"
            medlinesite = "http://www.livestrong.com/article/252191-how-to-listen-to-a-heartbeat/"
            
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
