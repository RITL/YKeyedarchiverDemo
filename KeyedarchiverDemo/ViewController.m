//
//  ViewController.m
//  KeyedarchiverDemo
//
//  Created by YueWen on 16/3/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "ViewController.h"
#import "FileManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //初始化一个FileManager
    FileManager * fileManager = [[FileManager alloc]init];
    
    //初始化一个Object对象
    MessageObject * messageObject1 = [[MessageObject alloc]init];
    messageObject1.name = @"Yue";
    messageObject1.time = @"2016-03-23";
    messageObject1.pictures = @[@"1111111",@"2222222",@"3333333"];
    
    MessageObject * messageObject2 = [[MessageObject alloc]init];
    messageObject2.name = @"Yue";
    messageObject2.time = @"2016-03-23";
    messageObject2.pictures = @[@"AAAAAA",@"BBBBBB",@"CCCCCC"];
    
    NSArray <MessageObject *> *  messageObjects = @[messageObject1,messageObject2];
    
    
    //开始存数据
    [fileManager storgaeObject:messageObject1];
    [fileManager storgaeObjects:messageObjects];
    
    //打印
    NSLog(@"我是单个数据:");
    NSLog(@"messObject = %@",[fileManager readMessageObject]);
    
    
    NSLog(@"\n\n多个数据:");
    //获取数组
    NSArray * datas = [fileManager readMessageObjects];
    
    for (MessageObject * message in datas)
    {
        NSLog(@"message = %@",message);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
