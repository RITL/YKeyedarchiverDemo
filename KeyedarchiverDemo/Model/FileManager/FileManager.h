//
//  FileManager.h
//  KeyedarchiverDemo
//
//  Created by YueWen on 16/3/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageObject.h"

@interface FileManager : NSObject

/*
 *  存数据
 */
- (void)storgaeObject:(MessageObject * _Nonnull)messageObject;
- (void)storgaeObjects:(NSArray <MessageObject *> * _Nonnull)messageObjects;

/*
 *  获取数据
 */
- ( MessageObject * _Nullable )readMessageObject;
- ( NSArray<MessageObject *> * _Nullable )readMessageObjects;

@end
