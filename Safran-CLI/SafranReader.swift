//
//  Reader.swift
//  Safran
//
//  Created by Sedat ÇİFTÇİ on 09/08/14.
//  Copyright (c) 2014 Sedat ÇİFTÇİ. All rights reserved.
//

import Foundation

enum Colors {
    case Red, Green
}

extension String {
    func color(color: Colors) -> String{
        var selectedColor = ""
        
        switch color {
        case .Red:
            selectedColor = "\u{1b}[31m"
        case .Green:
            selectedColor = "\u{1b}[32m"
        default:
            selectedColor = ""
        }
        
        return "\(selectedColor)\(self)"
    }
}


class SafranReader: NSObject, NSXMLParserDelegate {
    
    var parser: NSXMLParser!
    var key: NSString!
    var title: NSMutableString!
    var link: NSMutableString!
    var feeds: NSMutableArray!
    var feed: NSMutableDictionary!
    
    init(url: String){
        super.init()
        self.feeds = NSMutableArray()
        self.parser = NSXMLParser(contentsOfURL: NSURL(string: url))
        self.parser.delegate = self
        self.parser.parse()
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        self.key = elementName
        if elementName == "title" {
            self.feed = NSMutableDictionary()
            self.title = NSMutableString()
            self.link = NSMutableString()
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        switch self.key {
        case "title":
            self.title.appendString(string)
        case "link":
            self.link.appendString(string)
        default:
            return
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == "item" {
            feed.setObject(self.title, forKey: "title")
            feed.setObject(self.link, forKey: "link")
            feeds.addObject(feed)
        }
    }
    
    func show(){
        for item in feeds {
            println("- "+String(item.valueForKey("title") as NSString).color(.Red))
            println(String(item.valueForKey("link") as NSString).color(.Green))
        }
    }
    
}
