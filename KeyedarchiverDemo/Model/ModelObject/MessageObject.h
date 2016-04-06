//
//  MessageObject.h
//  KeyedarchiverDemo
//
//  Created by YueWen on 16/3/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject <NSCoding>

@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSArray < NSString *> * pictures;

@end
