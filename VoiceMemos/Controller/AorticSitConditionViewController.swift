//
//  AorticSitConditionViewController.swift
//  VoiceMemos
//
//  Created by Stepanie Lim on 07/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class AorticSitConditionViewController: UIViewController {
    
//Global variables
    @IBOutlet weak var waveform: FDWaveformView!
    var condition = String()
    var details = String ()
    var diagnosis = String ()
    var siteclicked  = String ()
    var googlesite = String ()
    var mayosite = String ()
    var medlinesite  = String ()
    var URL : NSURL!
    //unwind segue
    @IBAction func unwindtoAOSCond(segue: UIStoryboardSegue){
    }
    
//Target Connection
    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var labeldetail: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBAction func aosweb(sender: AnyObject) {
        // Create the alert controller
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        // Create the actions
        alert.addAction(UIAlertAction(title: "Google", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.siteclicked = self.googlesite
            self.performSegueWithIdentifier("aossegue", sender:true)
        }))
        
        alert.addAction(UIAlertAction(title: "Mayoclinic", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            self.siteclicked = self.mayosite
            self.performSegueWithIdentifier("aossegue", sender: true)
        }))
        
        alert.addAction(UIAlertAction(title: "MedlinePlus", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            self.siteclicked = self.medlinesite
            self.performSegueWithIdentifier("aossegue", sender: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    //sending segue to display selected webpage
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "aossegue") {
            let aosweb = segue.destinationViewController as! AoSWebViewController
            aosweb.AoSweb = self.siteclicked}
    }
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        detailscond()
        
        self.waveform.audioURL = URL
        self.waveform.progressSamples = 0
        self.waveform.doesAllowScroll = true
        self.waveform.doesAllowStretch = true
        self.waveform.doesAllowScrubbing = false
        self.waveform.wavesColor = UIColor.darkGrayColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
     labelname.text = diagnosis
     labeldetail.text = details
    }
    
    func detailscond(){
        if condition == "AoS-EDM"{
//referenced from http://patient.info/health/aortic-regurgitation-leaflet
            self.image.image = UIImage(named:"AoS-EDM")
            diagnosis = "Aortic Regurgitation"
            details = "Aortic regurgitation is a condition in which blood leaks back through the aortic valve. This is because the valve does not close properly."+"\n"+"There would be no symptoms if the leak is small. However, if the backflow of blood becomes worse, the symptoms are:"+"\n"+"1. Dizziness"+"\n"+"2. Chest pain"+"\n"+"3. Forceful thumping heartbeats"
            googlesite = "https://www.google.com.au/#q=Aortic+Regurgitation%27"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/aortic-valve-regurgitation/basics/definition/con-20022523"
            medlinesite = "https://medlineplus.gov/ency/article/000179.htm"
        }
        else if condition == "AoS-Normal"{
            self.image.image = UIImage(named:"AoS-Normal")
            diagnosis = "Normal"
            details = "This person has a normal heartsound. No heart issues is found."
            mayosite = "http://www.mayoclinic.org/diseases-conditions/heart-disease/in-depth/heart-disease-prevention/art-20046502"
            googlesite = "https://www.google.com.au/#q=keep+a+healthy+heart"
            medlinesite = "https://medlineplus.gov/magazine/issues/winter10/articles/winter10pg8.html"
            
        }
        else if condition == "AoS-SMwAS2"{
//referenced from http://www.heart.org/HEARTORG/Conditions/More/HeartValveProblemsandDisease/Problem-Aortic-Valve-Stenosis_UCM_450437_Article.jsp#.V_kllGVKCAY
            self.image.image = UIImage(named:"AoS-SMwAS2")
            diagnosis = "Severe Aortic Stenosis"
            details = "Aortic stenosis is a narrowing of the aortic valve opening. Aortic stenosis restricts the blood flow from the left ventricle to the aorta and may also affect the pressure in the left atrium. The amount of the blood flow is significantly reduced."+"\n\n"+"The symptoms are:"+"\n"+"1. Breathlessness"+"\n"+"2. Chest pain, or feeling pressure or tightness in the heart"+"\n"+"3. Fainting"+"\n"+"4. Palpitations or a feeling of heavy, pounding, or noticeable heartbeats"+"\n"+"5. Decline in activity level or reduced ability to do normal activities requiring mild exertion"
            googlesite = "https://www.google.com.au/webhp?hl=en&sa=X&ved=0ahUKEwjU-rq_jdfPAhVoxlQKHWr9CR4QPAgD#hl=en&q=Severe+Aortic+Stenosis"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/aortic-stenosis/basics/definition/con-20026329"
            medlinesite = "https://medlineplus.gov/ency/article/000178.htm"
        }
        else if condition == "AoS-SnDM"{
//referenced from https://www.heart.org/idc/groups/heart-public/@wcm/@hcm/documents/downloadable/ucm_307677.pdf
            self.image.image = UIImage(named:"AoS-SnDM")
            diagnosis = "Combined Aortic Stenosis and Regurgitation"
            details = "This condition occurs when there is an obstruction to the aortic valve and leakage of valve as it closes after heartbeat."+"\n"+"There is little symptoms that occur for patients with mild obstruction. The most common symptoms are:"+"\n"+"1. Shortness of breath with exertion"+"\n"+"2. Chest pain"+"\n"+"3. Lightheadedness"+"\n"+"4. Fainting"+"\n"+"5. Reccurent fever (if the valve of the heart has become infected)"
            googlesite = "https://www.google.com.au/search?client=safari&rls=en&q=Combined+Aortic+Stenosis+and+Regurgitation+-+Google+Search&ie=UTF-8&oe=UTF-8&gfe_rd=cr&ei=4CP_V6vbNrLr8Afylae4Cg"
            medlinesite = "https://medlineplus.gov/ency/article/000179.htm"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/aortic-valve-regurgitation/basics/definition/con-20022523"
        }
        else {
            diagnosis = "This sound file is corrupted"
            self.image.image = UIImage(named:"error")
            details = "Error!"+"\n"+"Please re-record a new sound file."+"\n\n\n"+"Notice:"+"\n"+"Please ensure patient is not talking and breathing normally when heart sound is taken."
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
