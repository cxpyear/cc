//
//  ViewController.swift
//  spdbapp
//
//  Created by tommy on 15/5/7.
//  Copyright (c) 2015年 shgbit. All rights reserved.
//

import UIKit

class AgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIToolbarDelegate,HttpProtocol {
   
    @IBOutlet weak var lbConfType: UILabel!
    @IBOutlet weak var tvAgenda: UITableView!
    
    
    @IBOutlet weak var tbTop: UIToolbar!
    @IBOutlet var gesTap: UITapGestureRecognizer!
    
    
    
    var filesDataInfo:[JSON] = []
    var eHTTP: HTTPController = HTTPController()
    var baseURl = "http://192.168.16.141:8080/meeting/current"
    
//    var items = ["上海浦东发展银行股份有限公司第二届董事会第一次会议上海浦东发展银行股份有限公司第二届董事会第一次会议上海浦东发展银行股份有限公司第二届董事会第一次会议",
//        "上海浦东发展银行股份有限公司第二届董事会第二次会议",
//        "上海浦东发展银行股份有限公司第二届董事会第三次会议",
//        "上海浦东发展银行股份有限公司第二届董事会第四次会议",
//        "上海浦东发展银行股份有限公司第二届董事会第五次会议",
//        "上海浦东发展银行股份有限公司第二届董事会第六次会议",
//        "上海浦东发展银行股份有限公司第二届董事会第七次会议",
//        "上海浦东发展银行股份有限公司第二届董事会第八次会议",
//        "上海浦东发展银行股份有限公司第二届董事会第九次会议"]
    //var index = ["一、","二十一、","三、","四、","五、","六、","七十、","八、","九、","十、","二十一、"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbConfType.text = "党政联系会议"
        tvAgenda?.dataSource = self
        tvAgenda?.delegate = self
        tvAgenda?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tvAgenda.backgroundColor = UIColor(red: 34/255, green: 63/255, blue: 117/255, alpha: 1)
        tvAgenda.separatorStyle = UITableViewCellSeparatorStyle.None
        var cell = UINib(nibName: "AgendaTableViewCell", bundle: nil)
        self.tvAgenda.registerNib(cell, forCellReuseIdentifier: "cell")
        
        eHTTP.delegate = self
        eHTTP.onSearch(baseURl)
        
        
        //初始化时候隐藏tab bar
        hideBar()
        
        // 点击该区域内，添加手势，弹出tabbar
        var topView = UIView(frame: CGRectMake(0, 0, 768, 155))
        topView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(topView)
        
        //为uitabbar添加代理
        tbTop.delegate = self
        gesTap.addTarget(self, action: "actionBar")
        topView.addGestureRecognizer(gesTap)
        
        //添加定时器，每隔5s自动隐藏tar bar
        var timer = Poller()
        timer.start(self, method: "timerDidFire:")
        
        
    }
    
    func didReceiveResult(results: AnyObject) {
        let json = JSON(results)
        
        if let filesInfo = json["files"].array
        {
            //获取所有的文件信息
            self.filesDataInfo = filesInfo
            //println("fileInfo = \(self.filesDataInfo)")
            self.tvAgenda.reloadData()
        }
        
    }
    
    
    //屏幕滚动时，触发该事件
    func scrollViewDidScroll(scrollView: UIScrollView){
        hideBar()
    }
    
    
    //定时器函数，每隔5s自动隐藏tab bar
    func timerDidFire(timer: NSTimer!){
        if tbTop.hidden == false
        {
            tbTop.hidden = true
        }
    }
    
    func actionBar(){
        tbTop.hidden = !tbTop.hidden
    }
    
    func hideBar(){
        tbTop.hidden = true
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return self.items.count
        return filesDataInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AgendaTableViewCell
        var row = indexPath.row as Int
        //cell.lbAgenda.text = self.items[row]
        var rowData = filesDataInfo[indexPath.row]
        
        cell.lbAgenda.text = rowData["name"].stringValue
        cell.lbAgendaIndex.text = (String)(indexPath.row + 1)
        
        var customColorView = UIView();
        customColorView.backgroundColor = UIColor(red: 34/255, green: 63/255, blue: 117/255, alpha: 0.85)
        cell.selectedBackgroundView =  customColorView;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       self.performSegueWithIdentifier("toDoc", sender: self)
    }
    
    @IBAction func btnBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnGoToHistory(sender: UIBarButtonItem) {
        
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Create a new variable to store the instance of DocViewController
        let c = segue.destinationViewController as! DocViewController
        c.url = "/Users/gbtouchg3/Desktop/spdbapp65524/spdbapp/spdbapp/H2_AN201503180008803514_1.pdf"

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
