//
//  FileManager.m
//  KeyedarchiverDemo
//
//  Created by YueWen on 16/3/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "FileManager.h"

@interface FileManager ()

@property (nonatomic, copy) NSString * documentPath;//沙盒路径

@end

@implementation FileManager


- (instancetype)init
{
    if (self = [super init])
    {
        //创建文件夹
        [self createFolder];
    }
    
    return self;
}


#pragma mark - 存储-获取单个数据
-(void)storgaeObject:(MessageObject * _Nonnull)messageObject
{
    //拼接路径，格式随意
    NSString * path = [[self documentAchiverPath] stringByAppendingPathComponent:@"messageObject.achiver"];
    
    //开始编码存数据
    [NSKeyedArchiver archiveRootObject:messageObject toFile:path];
}


-(MessageObject * _Nullable)readMessageObject
{
    //拼接路径
    NSString * path = [[self documentAchiverPath] stringByAppendingPathComponent:@"messageObject.achiver"];
    
    //开始解码获取
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}


#pragma mark - 存储-获取数组数据
-(void)storgaeObjects:(NSArray<MessageObject *> * _Nonnull)messageObjects
{
    //拼接路径
    NSString * path = [[self documentAchiverPath] stringByAppendingPathComponent:@"messageObjects.achiver"];
    
    //开始编码存数据
    [NSKeyedArchiver archiveRootObject:messageObjects toFile:path];
}


-(NSArray<MessageObject *> * _Nullable)readMessageObjects
{
    //拼接路径
    NSString * path = [[self documentAchiverPath] stringByAppendingPathComponent:@"messageObjects.achiver"];
    
    //开始解码获取
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}


#pragma mark - Getter Function
//沙盒目录
-(NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
}

//沙盒目录下的存储目录，文件夹名可以随便取
- (NSString *)documentAchiverPath
{
    return [self.documentPath stringByAppendingPathComponent:@"Achiver"];
}


#pragma mark - CreateFolder
- (void)createFolder
{
    //拼接路径
    NSString * path = [self documentAchiverPath];
    
    BOOL isDirectory;
    
    //查找是否存在这个文件夹,isDirectory用来判断是文件夹还是文件，如果路径不存在，返回为undefined，表示不能确定
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory])
    {
        //存在这个文件夹
        return;//不做操作
    }
    
    //不存在创建文件夹
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    }
}


@end
