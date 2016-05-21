//
//  ViewController.swift
//  LINE
//
//  Created by HARADA REO on 2015/09/14.
//  Copyright (c) 2015年 reo harada. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var lineTableView: UITableView!
    var data:Array<String> = []
    var dataType:Array<String> = []
    var someOneData:Array<String> = [
        "今度の日曜日はどこにいく？",
        "旅行行きたいな〜。旅行行きたいとこある？",
        "この前の土曜日のドラマみた？ｗ\nまさかあの人が犯人だと思わないよね？ｗ",
        "渋谷に美味しいステーキのお店あるんだけど一緒に行かない？\n値段も安いよ(*´ω｀*)",
        "おはよう〜",
        "こんにちは",
        "こんばんはm(_ _)m",
        "ヽ(#ﾟДﾟ)ﾉ┌┛(ノ´Д｀)ノ",
        "ε-(/･ω･)/ ﾄｫｰｯ!!",
        "o(｀ω´*)oﾌﾟﾝｽｶﾌﾟﾝｽｶ!!",
    ]
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.lineTableView.delegate = self
        self.lineTableView.dataSource = self
        
        self.lineTableView.backgroundColor = UIColor.clearColor()
        
        let cell = UINib(nibName: "LineMessageTableViewCell", bundle: nil)
        self.lineTableView.registerNib(cell, forCellReuseIdentifier: "messageCell")
        let leftCell = UINib(nibName: "LeftTableViewCell", bundle: nil)
        self.lineTableView.registerNib(leftCell, forCellReuseIdentifier: "LeftTableViewCell")

        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: "hideKyeboard:", name: UIKeyboardWillHideNotification, object: nil)
        //nc.addObserver(self, selector: "showKeyboard:", name: UITextInputCurrentInputModeDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(self.dataType[indexPath.row] == "right"){
            let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! LineMessageTableViewCell
            let width = cell.messageLabel.frame.size.width
            cell.messageLabel.text = self.data[indexPath.row]
            cell.messageLabel.sizeToFit()
            cell.messageLabel.frame.size.width = width
            cell.messageImageView.frame.size.height = CGRectGetHeight(cell.messageLabel.frame) + 20
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("LeftTableViewCell", forIndexPath: indexPath) as! LeftTableViewCell
            let width = cell.messageLabel.frame.size.width
            cell.messageLabel.text = self.data[indexPath.row]
            cell.messageLabel.sizeToFit()
            cell.messageLabel.frame.size.width = width
            cell.messageImageView.frame.size.height = CGRectGetHeight(cell.messageLabel.frame) + 20
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(self.dataType[indexPath.row] == "right"){
            let cell = self.lineTableView.dequeueReusableCellWithIdentifier("messageCell") as! LineMessageTableViewCell
            //let width = cell.messageLabel.frame.size.width
            cell.messageLabel.text = self.data[indexPath.row]
            cell.messageLabel.sizeToFit()
            //cell.messageLabel.frame.size.width = width
            return cell.messageLabel.frame.size.height + 35
        }else{
            let cell = self.lineTableView.dequeueReusableCellWithIdentifier("LeftTableViewCell") as! LeftTableViewCell
            let width = cell.messageLabel.frame.size.width
            cell.messageLabel.text = self.data[indexPath.row]
            cell.messageLabel.sizeToFit()
            cell.messageLabel.frame.size.width = width
            return cell.messageLabel.frame.size.height + 35
        }
    }
    
    func showKeyboard(notification: NSNotification!) {
        let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration:NSTimeInterval = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.commentView.frame.origin.y = self.view.frame.size.height - rect.size.height - self.commentView.frame.size.height
            
            self.lineTableView.frame = CGRectMake(self.lineTableView.frame.origin.x, self.lineTableView.frame.origin.y, self.lineTableView.frame.size.width, self.commentView.frame.origin.y - self.lineTableView.frame.origin.y)
        })
        if(self.lineTableView.contentSize.height - self.lineTableView.frame.size.height > 0){
            self.lineTableView.contentOffset.y = self.lineTableView.contentSize.height - self.lineTableView.frame.size.height
        }
    }
    
    func hideKyeboard(notification: NSNotification!) {
        let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration:NSTimeInterval = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.commentView.frame.origin.y = self.view.frame.size.height - self.commentView.frame.size.height
            
            self.lineTableView.frame = CGRectMake(self.lineTableView.frame.origin.x, self.lineTableView.frame.origin.y, self.lineTableView.frame.size.width, self.commentView.frame.origin.y - self.lineTableView.frame.origin.y)
        })
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        self.data.append(self.commentTextField.text!)
        self.dataType.append("right")
        
        self.commentTextField.endEditing(true)
        self.commentTextField.text = ""
        
        self.lineTableView.reloadData()
        if(self.lineTableView.contentSize.height - self.lineTableView.frame.size.height > 0){
            self.lineTableView.contentOffset.y = self.lineTableView.contentSize.height - self.lineTableView.frame.size.height
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "someoneTalk", userInfo: nil, repeats: false)
    }
    
    func someoneTalk() {
        let dataCount = self.someOneData.count
        let randomNum = arc4random() % UInt32(dataCount)
        let message = self.someOneData[Int(randomNum)]
        self.data.append(message)
        self.dataType.append("left")
        self.lineTableView.reloadData()
        if(self.lineTableView.contentSize.height - self.lineTableView.frame.size.height > 0){
            self.lineTableView.contentOffset.y = self.lineTableView.contentSize.height - self.lineTableView.frame.size.height
        }
    }
}

