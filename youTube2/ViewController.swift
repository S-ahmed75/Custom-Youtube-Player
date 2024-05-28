//
//  ViewController.swift
//  youTube2
//
//  Created by sunny on 18/10/2018.
//  Copyright © 2018 sunny. All rights reserved.
//

import UIKit
import APESuperHUD
import SDWebImage

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, videoDelegate {
 
    

    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!

    @IBOutlet weak var colView: UICollectionView!
    
    static let shareViewCont = ViewController()
    var currentUSer = [TableDAta]()
    let image = UIImage(named: "loading1")!
    
//demo data can be used  for testing!!!
    var video1 = TableDAta(title: "\"No Sleep\" - Hard Trap Hip Hop Beat Instrumental (Prod: dannyebtracks)", thumb: "https://i.ytimg.com/vi/-_Qq1VB6H3g/default.jpg", vidID: "-_Qq1VB6H3g")
     var video2 = TableDAta(title: "ALONE - Deep Soulful Piano Rap Instrumental [prod. by Magestick Records]", thumb: "https://i.ytimg.com/vi/_6FccJXk9t4/default.jpg", vidID: "_6FccJXk9t4")
    
    let kUserDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colView.delegate = self
        self.colView.dataSource = self
  
     
    APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
         initialState()
    }

    override func viewWillAppear(_ animated: Bool) {
        
      
        if(self.navigationItem.rightBarButtonItem?.title == "Done"){
            addBarButtonItem.isEnabled = true
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            
        }
        
        
    
        
        print("reloaded data")
       
    }
    
    @IBAction func addTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAddURL", sender: nil)
    }
    
    @IBAction func EditAlbumPressed(sender : AnyObject) {
        
        if(self.navigationItem.rightBarButtonItem?.title == "Edit"){
            addBarButtonItem.isEnabled = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
            
            //Looping through CollectionView Cells in Swift
            //http://stackoverflow.com/questions/25490380/looping-through-collectionview-cells-in-swift
            
            for item in self.colView!.visibleCells as! [CollectionViewCell] {
                
                var indexpath : NSIndexPath = self.colView!.indexPath(for: item as! CollectionViewCell) as! NSIndexPath
                var cell : CollectionViewCell = self.colView!.cellForItem(at: indexpath as IndexPath) as! CollectionViewCell
                
                
                //Close Button
               var close : UIButton = cell.closeButton
                close.isHidden = false
            }
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            addBarButtonItem.isEnabled = true
            self.colView?.reloadData()
        }
    }
    
    func initialState(){
        
        for keys in kUserDefault.dictionaryRepresentation() {
            
            var apptitle = ""
            var appThumb = ""
            var appVidid = ""
            
            let key = keys.value
            if let key12 = key as? [String:Any]{
                for key1 in key12{
                    let keyfinal = key1.value as! String
                    let key2 = key1.key
                    if  key2 == "title" {
                        apptitle = keyfinal
                        print(key2,"keyssss")
                    }
                    if  key2 == "thumb" {
                        appThumb = keyfinal
                        print(key2,"keyssss")
                    }
                    if  key2 == "vidID" {
                        appVidid = keyfinal
                        print(key2,"keyssss")
                    }
                    
                }
                let tit = TableDAta(title: apptitle, thumb: appThumb, vidID: appVidid)
                print("appedede",tit.vidID, tit.title)
                currentUSer.append(tit)
            }
            
        }
        
    }
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddURL" {
            let dest = segue.destination as! addUrlViewController
            dest.delegate = self
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUSer.count//self.collectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let image = NSURL(string: self.currentUSer[indexPath.row].thumb )! as URL
        
        
        cell.VideoTitle.text = currentUSer[indexPath.row].title;
        cell.backGroundImage.sd_setImage(with: image, placeholderImage:#imageLiteral(resourceName: "notFound"))
        
       
        
        if self.navigationItem.rightBarButtonItem!.title == "Edit" {
            
            cell.closeButton?.isHidden = true
            self.addBarButtonItem.isEnabled = true
            
        } else {
            self.addBarButtonItem.isEnabled = false
            cell.closeButton?.isHidden = false
        }
        cell.closeButton?.layer.setValue(indexPath.row, forKey: "index")
        
        
        cell.closeButton?.addTarget(self, action: #selector(ViewController.deletePhoto(_:)), for: UIControlEvents.touchUpInside)
      
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
              APESuperHUD.dismissAll(animated: true)
        })
        
        return cell
        
    }
    @objc func deletePhoto(_ sender:UIButton) {
        
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        let indexPath = IndexPath(item: i, section: 0)
      
        if currentUSer[indexPath.row].vidID != "" {

            kUserDefault.removeObject(forKey: currentUSer[indexPath.row].vidID)
            kUserDefault.synchronize()
            print("delete done")
        }
        currentUSer.remove(at:i)
        self.colView!.reloadData()
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       
         if self.navigationItem.rightBarButtonItem!.title == "Edit" {
        let vidViewContr = storyboard.instantiateViewController(withIdentifier: "idSeguePlayer") as! videoPlayerController
        vidViewContr.playSongID = currentUSer[indexPath.row].vidID
        

        self.navigationController?.pushViewController(vidViewContr, animated: true)

        }
    }
     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
       
        
        currentUSer.remove(at: indexPath.row)
      
        colView.deleteItems(at: [indexPath])
    }

    
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func addVideos(title: String, thumb: String, vidID: String) {
     
      let user2 = ["title": title, "thumb": thumb, "vidID": vidID]
        kUserDefault.set(user2, forKey: vidID)
        let dicti = kUserDefault.object(forKey: vidID)  as! Dictionary<String,String>
        var title123 = ""
        var thumb123 = ""
        var vidid123 = ""

        for value in dicti{
            if value.key == "title" {
                title123 = value.value
            }
            if value.key == "thumb"{
                thumb123 = value.value
            }
            if value.key == "vidID"{
                vidid123 = value.value
                
            }
           
        }
        let tit = TableDAta(title: title123, thumb: thumb123, vidID: vidid123)
        print("printing",tit.vidID)

        kUserDefault.synchronize()
        currentUSer.append(tit)
        
        colView.reloadData()
    }

   
}
    
    

