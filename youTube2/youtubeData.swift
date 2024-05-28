//
//  youtubeData.swift
//  youTube
//
//  Created by sunny on 20/10/2018.
//  Copyright © 2018 sunny. All rights reserved.
//

import Foundation
import Alamofire

struct YoutubeData:Codable {
    var kind:String!
    var etag:String
    
    var pageInfo:PAGEINFO!
    var items:[ITEMS]!
}
struct PAGEINFO:Codable{
    var totalResults:Int!
    var resultsPerPage:Int!
    
    
}

struct ITEMS:Codable {
    var kind:String!
   var etag:String!
    var id:String!
    var snippet:SNIPPET!
    init(itm: [String:Any]) {
         kind = itm["kind"] as! String ?? ""
         etag = itm["etag"] as! String ?? ""
         id = itm["id"] as! String ?? ""
         snippet = itm["snippet"] as! SNIPPET
    }
}
struct SNIPPET:Codable {
   var  publishedAt:String!
    var channelId:String!
    var title:String!
   var description:String!
   var thumbnails:DEFAULT!
    var channelTitle:String!
    var tags:[String]!
    var categoryId :String!
    var liveBroadcastContent : String!
    var localized : LOCALIZED!
   
    init(SNIPP: [String:Any]) {
        publishedAt = SNIPP["publishedAt"] as! String ?? ""
        channelId = SNIPP["channelId"] as! String ?? ""
        title = SNIPP["title"] as! String ?? ""
        description = SNIPP["description"] as! String ?? ""
        thumbnails = SNIPP["thumbnails"] as! DEFAULT
        tags = SNIPP["tags"] as! [String] ?? [""]
        categoryId = SNIPP["categoryId"] as! String ?? ""
        liveBroadcastContent = SNIPP["liveBroadcastContent"] as! String ?? ""
        localized = SNIPP["localized"] as! LOCALIZED
        publishedAt = SNIPP["publishedAt"] as! String ?? ""

    }
    
}

struct LOCALIZED:Codable {
    var title : String!
    var description: String!
    init(LOCALIZ:[String:Any]) {
        title = LOCALIZ["title"] as! String ?? ""
        description = LOCALIZ["description"] as! String ?? ""
    }
}
struct  DEFAULT:Codable {
    var `default`:DefaultOBject!
    var medium:DefaultOBject!
    var high:DefaultOBject!
   var standard: DefaultOBject!
    var maxres: DefaultOBject!
    
    init (def:[String:Any]){
        `default` = def["default"] as! DefaultOBject
        medium = def["medium"] as! DefaultOBject
        high = def["high"] as! DefaultOBject
        standard = def["standard"] as! DefaultOBject
        maxres = def["maxres"] as! DefaultOBject
    }
}

struct DefaultOBject:Codable {
    
    var url:String!
    var width:Int!
    var height:Int!
    init(DefaultOBj: [String:Any]) {
        
        url = DefaultOBj["url"] as! String ?? ""
        width = DefaultOBj["width"] as! Int ?? -1
        height = DefaultOBj["height"] as! Int ?? -1
    }
}
struct TableDAta {
    
    // MARK: Properties
    
    let title: String
    let thumb: String
    let vidID: String

    // MARK: Initializer
    
    // Generate a Villain from a three entry dictionary
    
    init(title:String,thumb:String,vidID:String){
        
        self.title = title
        self.thumb = thumb
        self.vidID = vidID
      
}
}


