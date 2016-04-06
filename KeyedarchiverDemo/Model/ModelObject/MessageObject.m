//
//  MessageObject.m
//  KeyedarchiverDemo
//
//  Created by YueWen on 16/3/23.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "MessageObject.h"

@interface MessageObject ()



@end


@implementation MessageObject


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //编码
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.pictures forKey:@"pictures"];
}



- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    //解码
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.pictures = [aDecoder decodeObjectForKey:@"pictures"];
    }
    
    return self;
}


//打印
-(NSString *)description
{
    return [NSString stringWithFormat:@"name = %@,time = %@,pictures = %@",self.name,self.time,[self picturesName]];
}


//将数据的数据拼接成字符串
- (NSString *)picturesName
{
    NSMutableString * pictures = [NSMutableString string];
    
    for (NSString * pictureURL in self.pictures)
    {
        [pictures appendString:pictureURL];
        [pictures appendString:@"||"];
    }
    
    return [NSString stringWithString:pictures];
}

@end
