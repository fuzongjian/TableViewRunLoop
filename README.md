### 当`TableView`展示大量高质量图片时造成卡顿，用`RunLoop`进行优化。
`思路如下：`
- 注册观察者，观察当前`RunLoop`即将进入休眠这个状态
```
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
```
- 任务封装

`闭包定义`
```
typealias RunloopBlock = () -> ()
```
`任务添加`
```
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
```
`任务执行`
```
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
```
- 当前`RunLoop`添加`timer`事件，防止任务没有执行完成便进入休眠了
```
// 添加定时器，让当前RunLoop持续不断运行,防止任务没有执行完毕就进入休眠状态，此处可删除定时器进行测试
Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
}
```
