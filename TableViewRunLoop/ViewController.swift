//
//  ViewController.swift
//  TableViewRunLoop
//
//  Created by deltalpha on 2020/5/19.
//  Copyright © 2020 付宗建. All rights reserved.
//

import UIKit
typealias RunloopBlock = () -> ()
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    lazy var tableView = {() -> UITableView in
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let table = UITableView(frame: frame, style: .plain)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    lazy var taskArray: [RunloopBlock] = { return NSMutableArray() }() as! [RunloopBlock]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        addRunloopOberserver()
        view.addSubview(tableView)
        tableView.register(CustomCell.classForCoder(), forCellReuseIdentifier: "custom-cell")
        // 添加定时器，让当前RunLoop持续不断运行,防止任务没有执行完毕就进入休眠状态，此处可删除定时器进行测试
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
        }
    }
    func addRunloopOberserver() -> Void {
        // 获取当前的RunLoop
        let runloop: CFRunLoop = CFRunLoopGetCurrent()
        // 定义一个上下文
        var context: CFRunLoopObserverContext = CFRunLoopObserverContext(version: 0, info: unsafeBitCast(self, to: UnsafeMutableRawPointer.self), retain: nil, release: nil, copyDescription: nil)
        // 定义一个观察者，观察即将进入休眠状态
        if let observer = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, self.observerCallbackFunc(), &context) {
            // 添加当前RunLoop的观察者  这里可自行测试 defaultMode
            CFRunLoopAddObserver(runloop, observer, .commonModes)
        }
    }
    func observerCallbackFunc() -> CFRunLoopObserverCallBack{
        return {(observer, activity, context) -> Void in
            // 没有获取到，直接返回
            if context == nil {
               return
            }
            let VC = unsafeBitCast(context, to: ViewController.self)
            NSLog(" === %d", VC.taskArray.count)
            if VC.taskArray.count == 0 {
               return
            }
            let block: RunloopBlock = VC.taskArray.first!
            block()
            _ = VC.taskArray.remove(at: 0)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "custom-cell"
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomCell
        cell.selectionStyle = .none
        let task1: RunloopBlock = {() -> Void in
            cell.imageView1.image = UIImage(named: "car")
        }
        taskArray.append(task1)
        let task2: RunloopBlock = {() -> Void in
           cell.imageView2.image = UIImage(named: "car")
        }
        taskArray.append(task2)
        let task3: RunloopBlock = {() -> Void in
           cell.imageView3.image = UIImage(named: "car")
        }
        taskArray.append(task3)
        // 此处保证拿到的是最新的任务，可做修改
        if taskArray.count > 45 {
            _ = taskArray.remove(at: 0)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

