//
//  ViewController.swift
//  LINE
//
//  Created by HARADA REO on 2015/09/14.
//  Copyright (c) 2015年 reo harada. All rights reserved.
//

import UIKit

// tableViewを使う準備その１
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var lineTableView: UITableView!
    @IBOutlet weak var marginBottomCommentView: NSLayoutConstraint!
    // データをDictionaryで用意
    var data: [[String: String]] = []
    // 返信用データをDictionaryで用意
    var someOneData: [String] = [
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
    // 返信用タイマーを用意
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // tableViewを利用する準備その２
        self.lineTableView.delegate = self
        self.lineTableView.dataSource = self
        
        // tableViewの背景を透明にする
        self.lineTableView.backgroundColor = UIColor.clear
        
        //カスタムセルの登録
        let cell = UINib(nibName: "LineMessageTableViewCell", bundle: nil)
        self.lineTableView.register(cell, forCellReuseIdentifier: "messageCell")
        let leftCell = UINib(nibName: "LeftTableViewCell", bundle: nil)
        self.lineTableView.register(leftCell, forCellReuseIdentifier: "LeftTableViewCell")

        // キーボード出現のNotificationを登録
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ViewController.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(ViewController.hideKyeboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.translatesAutoresizingMaskIntoConstraints = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // tableViewと相談↓
    // セクションの数どうする？
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの数どうする？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    // セルの中身どうする？
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 自分の投稿と他人の投稿でセルを分ける
        if self.data[indexPath.row]["who"] == "my" {
            // セルを呼んでくる
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! LineMessageTableViewCell
            // 部品を設定
            cell.messageLabel.text = self.data[indexPath.row]["message"]
            // labelのサイズを文字数で調節
            cell.messageLabel.sizeToFit()
            // 吹き出し画像の高さ調整
            cell.heightMessageImageView.constant = cell.messageLabel.frame.height + 22
            // 背景を透明にする
            cell.backgroundColor = UIColor.clear
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
            cell.messageLabel.text = self.data[indexPath.row]["message"]
            cell.messageLabel.sizeToFit()
            cell.heightMessageImageView.constant = cell.messageLabel.frame.height + 22
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    // セルの高さどうする？
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.data[indexPath.row]["who"] == "my" {
            // セルを呼んでくる
            let cell = self.lineTableView.dequeueReusableCell(withIdentifier: "messageCell") as! LineMessageTableViewCell
            // データを入れて高さを計算
            print(cell.messageLabel.frame)
            cell.messageLabel.text = self.data[indexPath.row]["message"]
            cell.messageLabel.sizeToFit()
            print(cell.messageLabel.frame)
            return cell.messageLabel.frame.size.height + 40
        }
        else{
            let cell = self.lineTableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell") as! LeftTableViewCell
            cell.messageLabel.text = self.data[indexPath.row]["message"]
            cell.messageLabel.sizeToFit()
            return cell.messageLabel.frame.size.height + 40
        }
    }
    
    // キーボードのNotification
    func showKeyboard(_ notification: Notification!) {
        // キーボードのframe情報取得
        let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // キーボードの移動速度
        let duration:TimeInterval = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        // キーボードの移動速度に合わせて移動する
        self.marginBottomCommentView.constant = -rect.size.height
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        // tableViewを最終地点までスクロールさせる
        if(self.lineTableView.contentSize.height - self.lineTableView.frame.size.height > 0){
            self.lineTableView.contentOffset.y = self.lineTableView.contentSize.height - self.lineTableView.frame.size.height
        }
    }
    
    func hideKyeboard(_ notification: Notification!) {
        // キーボードの移動速度
        let duration:TimeInterval = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        // キーボードの移動速度に合わせて隠す
        self.marginBottomCommentView.constant = 0
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        // textFieldのデータ取得
        let message = self.commentTextField.text
        // データを追加する
        let addData: [String: String] = [
            "message": message!,
            "who": "my"
        ]
        self.data.append(addData)
        
        // textFieldの編集終了
        self.commentTextField.endEditing(true)
        self.commentTextField.text = ""
        
        // tableViewと相談し直す
        self.lineTableView.reloadData()
        // tableViewを最終地点までスクロールする
        if(self.lineTableView.contentSize.height - self.lineTableView.frame.size.height > 0){
            self.lineTableView.contentOffset.y = self.lineTableView.contentSize.height - self.lineTableView.frame.size.height
        }
        
        // 返信用のタイマーをセットする
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.someoneTalk), userInfo: nil, repeats: false)
    }
    
    func someoneTalk() {
        // 乱数を生成して、返信を選ぶ
        let dataCount = self.someOneData.count
        let randomNum = arc4random() % UInt32(dataCount)
        let message = self.someOneData[Int(randomNum)]
        
        // データを追加する
        let addData: [String: String] = [
            "message": message,
            "who": "other"
        ]
        self.data.append(addData)
        
        // tableViewと相談し直す
        self.lineTableView.reloadData()
        // 最終地点までスクロールする
        if(self.lineTableView.contentSize.height - self.lineTableView.frame.size.height > 0){
            self.lineTableView.contentOffset.y = self.lineTableView.contentSize.height - self.lineTableView.frame.size.height
        }
    }
}

