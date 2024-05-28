//
//  addUrlViewController.swift
//  youTube2
//
//  Created by sunny on 18/10/2018.
//  Copyright © 2018 sunny. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import APESuperHUD
import YouTubePlayer

protocol videoDelegate {
    func addVideos(title:String,thumb:String,vidID:String)
    
}

class addUrlViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: videoDelegate?
    
    
    @IBOutlet weak var addUrl: UIButton!
    @IBOutlet weak var cancelURL: UIButton!
    

    @IBOutlet weak var textUrl: UITextField!
    
    let kUserDefault = UserDefaults.standard
    var saveTitle:String = ""
    var saveThumnail:String = ""
    var saveVideoId:String = ""
    let image = UIImage(named: "loading1")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textUrl.delegate = self
        self.addUrl.layer.cornerRadius = 8
        self.cancelURL.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.addUrl.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        APESuperHUD.dismissAll(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveUrl(_ sender: Any) {
      
       self.addUrl.isEnabled = false
       APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        
        if let url = URL(string: textUrl.text!) {
            do {
                
                let videoid = videoIDFromYouTubeURL(url)
                if videoid != nil {
                    
                    if let vidIDSave = kUserDefault.value(forKey: videoid!){
               
                        alertError(title: "Already saved", message: "Already saved")
                }else{
                        getdata(videoId: videoid!)
                }
                    
                } else{
                        alertError(title: "Invalid URL", message: "Incorrect Url found")
                }
                
            } catch {
                        alertError(title: "Invalid URL", message: "Incorrect Url found")
                
                print(" contents could not be loaded")
            }
        } else {
            alertError(title: "Invalid URL", message: "Incorrect Url found")
            print("the URL was bad!")
        }
       
        }
    
    func alertError(title:String,message:String){
         APESuperHUD.dismissAll(animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.addUrl.isEnabled = true
            })
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
 
    
    func getdata(videoId:String){
        
        let viewCont = ViewController()
        print(viewCont)
        var user:TableDAta = TableDAta(title: "", thumb: "", vidID: "")
        let url = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=\(videoId)&key=AIzaSyDm1jW-1XR9KxHOThBc_piWiHYemE_qaRI"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
          
        
            if response.error == nil{
                print("res1",response)
                let jsondata = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                let haris = try! JSONDecoder().decode(YoutubeData.self, from: jsondata)
                if haris.items != nil{
                for item1 in haris.items{
                    let videoId1 = item1.id
                    self.saveVideoId = videoId1!
                    var snippet1 = item1.snippet
                    for snippet11 in (snippet1?.title)!{
                        var title1 = snippet1?.title
                        var thumbnail1 = snippet1?.thumbnails
                        self.saveTitle = title1!
                        var def = thumbnail1?.default
                        var med = thumbnail1?.medium
                        var high = thumbnail1?.high
                        var stand = thumbnail1?.standard
                        var maxre = thumbnail1?.maxres
                    for defUrl in (def?.url)!{
                        var url12 = high?.url
                      self.saveThumnail = url12!
                        user =  TableDAta(title: title1!, thumb: url12!, vidID: videoId1!)
                        
                        }
                       
                    
                }
               
                    }}
                else{
                    self.alertError(title: "Alert", message: "No Video")
                    
                }
            
                DispatchQueue.main.async {
                    print(user)
                   
                    if user.vidID != "" {   self.delegate?.addVideos(title: user.title, thumb: user.thumb, vidID: user.vidID)
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        self.alertError(title: "error", message: "No Video Found")
                        }

                }
                
            }else{
                self.alertError(title: "Alert", message: "No Network")
               
                print("nodata found")
            }
       // self.kUserDefault.synchronize()
            
        }
        
        
        
    }
    
}
