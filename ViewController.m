//
//  ViewController.m
//  testGCD
//
//  Created by lixiang on 2018/3/20.
//  Copyright © 2018年 com.lixiang. All rights reserved.
//

/*
 在一个线程内可能有多个队列，这些队列可能是串行的或者是并行的，按照同步或者异步的方式工作
 异步的，则会开启新的线程工作
 同步的，会在当前线程内工作，不会创建新的线程
 
 主队列是主线程中的一个串行队列
 所有的和UI的操作(刷新或者点击按钮)都必须在主线程中的主队列中去执行
 否则无法更新UI
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self 异步主队列];
}

- (void)异步并行队列 {
    //异步：具备开启新线程的能力
    //并行：队列（数组）中的任务同时执行
    //组合结果：会自动开启一个或多个新的线程，队列中每个任务的执行顺序是随机的，任务之间不需要排队，且具有同时被执行的权利
    dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"---start---");
    
    dispatch_async(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    
    NSLog(@"---end---");
    
    /*
     2018-03-20 12:00:16.046059+0800 testGCD[5873:2664824] ---start---
     2018-03-20 12:00:16.046111+0800 testGCD[5873:2664824] ---end---
     2018-03-20 12:00:16.046414+0800 testGCD[5873:2664890] 任务2---<NSThread: 0x1c44778c0>{number = 4, name = (null)}
     2018-03-20 12:00:16.046453+0800 testGCD[5873:2664891] 任务1---<NSThread: 0x1c4477840>{number = 3, name = (null)}
     2018-03-20 12:00:16.046491+0800 testGCD[5873:2664890] 任务3---<NSThread: 0x1c44778c0>{number = 4, name = (null)}
    */
}

- (void)异步串行队列 {
    //异步：具备开启新线程的能力，在任务执行时不会阻塞当前线程，任务创建后可以先绕过
    //串行：队列（数组）中的任务依次执行
    //组合结果：开了一个新的子线程，加入到队列中的任务，会按照创建顺序依次执行，未加入到队列中的任务，会在主队列中依次执行。
    dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_SERIAL);
    NSLog(@"---start---");
    dispatch_async(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
    /*
     2018-03-20 12:08:35.362086+0800 testGCD[5880:2669015] ---start---
     2018-03-20 12:08:35.362139+0800 testGCD[5880:2669015] ---end---
     2018-03-20 12:08:35.362462+0800 testGCD[5880:2669080] 任务1---<NSThread: 0x1c407b180>{number = 3, name = (null)}
     2018-03-20 12:08:35.362495+0800 testGCD[5880:2669080] 任务2---<NSThread: 0x1c407b180>{number = 3, name = (null)}
     2018-03-20 12:08:35.362512+0800 testGCD[5880:2669080] 任务3---<NSThread: 0x1c407b180>{number = 3, name = (null)}
     */
}


- (void)同步并行队列 {
    //同步：不能开启新的线程，在任务执行时会阻塞当前线程，任务创建后必须执行完才能往下走
    //并行：队列（数组）中的任务同时执行
    //组合结果：所有任务都只能在主线程中执行，函数在执行时，必须按照代码的书写顺序一行一行地执行完才能继续
    dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"---start---");
    dispatch_sync(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
    /*
     2018-03-20 12:13:42.669237+0800 testGCD[5884:2670915] ---start---
     2018-03-20 12:13:42.669313+0800 testGCD[5884:2670915] 任务1---<NSThread: 0x1c0065180>{number = 1, name = main}
     2018-03-20 12:13:42.669340+0800 testGCD[5884:2670915] 任务2---<NSThread: 0x1c0065180>{number = 1, name = main}
     2018-03-20 12:13:42.669357+0800 testGCD[5884:2670915] 任务3---<NSThread: 0x1c0065180>{number = 1, name = main}
     2018-03-20 12:13:42.669364+0800 testGCD[5884:2670915] ---end---
     */
}

- (void)同步串行队列 {
    //同步：不能开启新的线程，在任务执行时会阻塞当前线程，任务创建后必须执行完才能往下走
    //串行：队列（数组）中的任务依次执行
    //组合结果：所有任务都只能在主线程中执行，函数在执行时，必须按照代码的书写顺序一行一行地执行完才能继续
    dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_SERIAL);
    NSLog(@"---start---");
    dispatch_sync(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
    /*
     2018-03-20 13:08:48.819827+0800 testGCD[5936:2694278] ---start---
     2018-03-20 13:08:48.820408+0800 testGCD[5936:2694278] 任务1---<NSThread: 0x1c407ddc0>{number = 1, name = main}
     2018-03-20 13:08:48.822084+0800 testGCD[5936:2694278] 任务2---<NSThread: 0x1c407ddc0>{number = 1, name = main}
     2018-03-20 13:08:48.822436+0800 testGCD[5936:2694278] 任务3---<NSThread: 0x1c407ddc0>{number = 1, name = main}
     2018-03-20 13:08:48.822546+0800 testGCD[5936:2694278] ---end---
     */
}

- (void)异步主队列 {
    //异步：具备开启新线程的能力，在任务执行时不会阻塞当前线程，任务创建后可以先绕过
    //主队列：是主线程中的一个串行队列，主队列中的任务必须在主线程中执行，不允许在子线程中执行
    //组合结果：加入主队列中的任务，因为是异步的，所以可以先绕过，稍候再按照创建顺序依次执行。其他任务不可以绕过，直接按顺序依次执行。
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"---start---");
    dispatch_async(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
    /*
     2018-03-20 13:19:57.986660+0800 testGCD[5947:2699541] ---start---
     2018-03-20 13:19:57.986702+0800 testGCD[5947:2699541] ---end---
     2018-03-20 13:19:57.988732+0800 testGCD[5947:2699541] 任务1---<NSThread: 0x1c006d680>{number = 1, name = main}
     2018-03-20 13:19:57.988780+0800 testGCD[5947:2699541] 任务2---<NSThread: 0x1c006d680>{number = 1, name = main}
     2018-03-20 13:19:57.988798+0800 testGCD[5947:2699541] 任务3---<NSThread: 0x1c006d680>{number = 1, name = main}
     */
}

- (void)同步主队列 {
    //同步：不能开启新的线程，在任务执行时会阻塞当前线程，任务创建后必须执行完才能往下走
    //主队列：是主线程中的一个串行队列，主队列中的任务必须在主线程中执行，不允许在子线程中执行
    //组合结果：任务1要等主队列中的所有任务执行完才能执行，主线程要执行完“打印end”的任务后才有空，“任务1”和“打印end”两个任务互相等待，造成死锁
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"---start---");
    dispatch_sync(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
}

@end











