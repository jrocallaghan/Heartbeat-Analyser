//
//  ApexLDConditionViewController.swift
//  VoiceMemos
//
//  Created by Stepanie Lim on 06/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

class ApexLDConditionViewController: UIViewController {
    
//Global variables
    var condition = String()
    var details = String ()
    var diagnosis = String ()
    var siteclicked = String ()
    var googlesite = String ()
    var mayosite = String ()
    var medlinesite = String ()

//Target Connections
    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labeldetails: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailscond()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //  detailscond()
        labeldetails.text = details
        labelname.text = diagnosis
        
    }
    
    
    @IBAction func Aldmoreinfo(sender: UIButton) {
        
        // Create the alert controller
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        // Create the actions
        alert.addAction(UIAlertAction(title: "Google", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.siteclicked = self.googlesite
            self.performSegueWithIdentifier("aldsegue", sender:true)
        }))
        
        alert.addAction(UIAlertAction(title: "Mayoclinic", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            self.siteclicked = self.mayosite
            self.performSegueWithIdentifier("aldsegue", sender: true)
        }))
        
        alert.addAction(UIAlertAction(title: "MedlinePlus", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            self.siteclicked = self.medlinesite
            self.performSegueWithIdentifier("aldsegue", sender: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    //sending segue to display selected webpage
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "aldsegue") {
            let aldweb = segue.destinationViewController as! ALDWebViewController
            aldweb.ALDweb = self.siteclicked}
    }
    

    
    

    func detailscond(){
        
//referenced from http://www.mayoclinic.org/diseases-conditions/mitral-valve-stenosis/basics/symptoms/con-20022582
        if condition == "ALD-MOSnDM"{
            self.image.image = UIImage(named:"ALD-MOSnDM")
            diagnosis = "Mitral Stenosis"
            details = "This is a narrowing of the heart's mitral valve. This abnormal valve doesn't open properly, blocking blood flow into the main pumping chamber of your heart."+"\n"+"The main cause of mitral valve stenosis is an infection called rheumatic fever, which is related to strep infections."+"\n\n"+"Mitral stenosis can have little to no symptoms for decades. However, the issue can suddenly worsen. Common symptoms are:"+"\n"+"1. SSevere headache, trouble speaking or other symptoms of stroke"+"\n"+"2. Chest discomfort or chest pain"+"\n"+"3. Heavy coughing, sometimes with blood-tinged sputum"+"\n"+"4. Heart palpitations"+"\n"+"5. Dizziness or fainting"
            googlesite = "https://www.google.com.au/#q=Mitral+Stenosis"
            medlinesite = "https://medlineplus.gov/ency/article/000175.htm"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/mitral-valve-stenosis/basics/definition/con-20022582"
            
        }
        
//referenced from http://www.mayoclinic.org/diseases-conditions/dilated-cardiomyopathy/basics/definition/con-20032887
        else if condition == "ALD-S3Gallop"{
            self.image.image = UIImage(named:"ALD-S3Gallop")
            diagnosis = "Normal or Cardiomyopathy"
            details = "There has been a S3 Gallop detected which is normal sometimes. But that could also be a sign of cardiomyopathy. Check if the patient has any of these physical symptoms:"+"\n"+"1. dizziness"+"\n"+"2. Light-headedness"+"\n"+"3. Fainting during physical activity"+"\n"+"4. Swelling in the ankles, feet, legs, abdomen and veins in the neck"+"\n"+"5. Chest pain especially after physical exertion or heavy meals"
            googlesite = "https://www.google.com.au/#q=Cardiomyopathy"
            medlinesite = "https://medlineplus.gov/cardiomyopathy.html"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/cardiomyopathy/basics/definition/con-20026819"
            
        }
//referenced from http://ehjcimaging.oxfordjournals.org/content/ejechocard/10/1/133.full.pdf
        else if condition == "ALD-S3nHSM"{
            self.image.image = UIImage(named:"ALD-S3nHSM")
            diagnosis = "Dilated Cardiomyopathy with Mitral Regurgitation"
            details = "Dilated cardiomyopathy is a disease of the heart muscle where the ventricle stretches and thins (dilates) and can't pump blood as well as a healthy heart can. Mitral regurgitation refers to backflow of blood."+"\n\n"+"The symptoms usually developed by patients are:"+"\n"+"1. Fatigue"+"\n"+"2. Shortness of breath (dyspnea) when you're active or lying down"+"\n"+"3. Reduced ability to exercise"+"\n"+"4. Swelling (edema) in your legs, ankles and feet"+"\n"+"5. Swelling of your abdomen (ascites)"
            googlesite = "https://www.google.com.au/#q=Dilated+Cardiomyopathy+with+Mitral+Regurgitation"
            medlinesite = "https://medlineplus.gov/ency/article/000168.htm"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/dilated-cardiomyopathy/basics/definition/con-20032887"
            
        }
//referenced from http://my.clevelandclinic.org/services/heart/disorders/left-ventricular-hypertrophy-lvh
        else if condition == "ALD-S4Gallop"{
            self.image.image = UIImage(named:"ALD-S4Gallop")
            diagnosis = "Left Ventricular Hypertrophy"
            details = "Left ventricular hypertrophy is enlargement and thickening of the walls of your heart's main pumping chamber.This disease is more common in people who have uncontrolled high blood pressure. Left ventricular hypertrophy usually develops gradually. You may experience no signs or symptoms, especially during the early stages of the condition."+"\n\n"+"When the symptoms shows:"+"Shortness of breath"+"\n"+"2.Fatigue"+"\n"+"3. Chest pain, often after exercising"+"\n"+"4. Sensation of rapid, fluttering or pounding heartbeats"+"\n"+"5. Dizziness or fainting"
            googlesite = "https://www.google.com.au/#q=Left+Ventricular+Hypertrophy"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/left-ventricular-hypertrophy/basics/definition/con-20026690"
            medlinesite = "http://www.mayoclinic.org/diseases-conditions/left-ventricular-hypertrophy/basics/definition/CON-20026690?p=1"
        }
//referenced from http://www.healthline.com/health/ischemic-cardiomyopathy#Symptoms2
        else if condition == "ALD-S4nMSM"{
            self.image.image = UIImage(named:"ALD-S4nMSM")
            diagnosis = "Ischemic Cardiomyopathy with Mitral Regurgitation"
            details = "Ischemic cardiomyopathy (IC) occurs when your heart muscle becomes weakened. It can result from a heart attack or coronary artery disease. It is more likey to occur in men and women after menopause."+"/n/n"+"The symptoms are:"+"\n"+"1. Extreme fatigue"+"\n"+"2. Shortness of breath"+"\n"+"3. Dizziness, lightheadedness, or fainting"+"\n"+"4. Chest pain and pressure (Angina)"+"\n"+"5. Swelling in your abdomen"
            googlesite = "https://www.google.com.au/#q=Ischemic+Cardiomyopathy"
            medlinesite = "https://medlineplus.gov/ency/article/001105.htm"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/cardiomyopathy/basics/definition/con-20026819"

        }
        else if condition == "ALD-SCwLSM"{
            self.image.image = UIImage(named:"ALD-SCwLSM")
            diagnosis = "Mitral Valve Prolapse with Mitral Regurgitation"
            details = "Mitral valve prolapse is a common cause of a heart murmur caused by a leaky heart valve. It is the most common cause of mitral regurgitation. That's a condition in which some blood flows backward through the mitral valve with each heartbeat. Over years, moderate or severe mitral regurgitation can cause congestive heart failure."+"\n\n"+"The symptoms are:"+"\n"+"1. Shortness of breath with exertion"+"\n"+"2. Swelling in the legs and feet"+"\n"+"3. Passing out or fainting"+"\n"+"4. Numbness or tingling in the hands and feet"+"\n"+"5. Panic and anxiety"
            googlesite = "https://www.google.com.au/#q=Mitral+Valve+Prolapse+with+Mitral+Regurgitation"
            medlinesite = "https://medlineplus.gov/ency/article/000176.htm"
            mayosite = "http://www.mayoclinic.org/diseases-conditions/mitral-valve-regurgitation/home/ovc-20121849"
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
