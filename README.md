# KeyedarchiverDemo
归档存储的练习

iOS下有很多中本地存储方式，但相比于CoreData，很多情况下还只是轻量级的数据，对于不是很复杂的数据，个人还是比较喜欢直接用归档或者plist文件来存储信息，毕竟存储的信息量没有那么大，用归档会比较轻便。

说到本地存储，不得不说NSUserDefaults，它是系统提供给我们很好的本地存储容器，比如单个的基础属性的存储用NSUserDefaults也很方便，但是如果存的是一个我们自己自定义的Model或者存放Model的数组字典的时候，用NSUserDefaults就会感觉比较麻烦，虽然一个属性一个属性的存也不是太麻烦，主要是害怕在不知情的时候存数据会把原数据覆盖掉，造成不小的麻烦。

归档是什么呢，是将数据序列化与反序列化，个人觉得还是比较喜欢理解成对数据进行编码与解码，在存入本地的时候按照固有的编码规则进行编码，在取得时候按照反编码进行编译，返回到存数据之前的数据，这里只说明一下如何对自定义的Model进行归档，其实单个属性的存档是一样的。

创建一个MessageObject的测试类，里面存放三个测试属性，要说一下，要完成归档存储的对象，必须履行一个叫做`NSCoding`的协议，声明文件如下:
``` Objective-C
#import <Foundation/Foundation.h>

@interface MessageObject : NSObject <NSCoding>

@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSArray < NSString *> * pictures;

@end
```

在实现文件中实现协议的两个方法:`-encodeWithCoder:`和`-initWithCoder:`实现方法如下:
```Objective-C
//进行编码的协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //编码
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.pictures forKey:@"pictures"];
}

//进行解码的协议方法
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

```
这里算是无用的代码，因为测试的时候需要打印看一下数据，以下的方法全是为方便打印进行的:
```Objective-C
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
```

既然是本地存储，肯定就是需要对本地文件进行操作了，说到本地操作，必然会请到`NSFileManager`这个功能强大的类，因此这里会封装一个对文件进行操作的类`FileManager`

声明只需要声明存数据以及获取数据的方法即可，这里声明了两对方法，一对是对单个Model的存和取，另一对是对存放Model数组的存和取
```Objective-C
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
```

在这里是将数据存到沙盒路径下的一个目录中(毕竟从目录中找是很方便的，不然多个文件会显得非常的乱),因此写了几个属性的Getter方法，方便取值:
```Objective-C
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
```

既然是存沙盒中的一个自定义文件夹中，那么就需要一开始创建一个文件夹，创建方法如下:
```Objective-C
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
```

准备工作已经完毕，接下来就是存数据与取数据的方法了，在创建对象的时候创建存储的文件夹，就是调用`createFolder`方法即可:
```Objective-C
- (instancetype)init
{
    if (self = [super init])
    {
        //创建文件夹
        [self createFolder];
    }
    
    return self;
}
```

最后就是存数据，大同小异:
```
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
```

测试的时候就只需要在ViewController进行测试即可，代码如下:
```Objective-C
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
```

打印结果如下:
```ruby
2016-04-06 17:07:13.012 KeyedarchiverDemo[39225:439050] 我是单个数据:
2016-04-06 17:07:13.013 KeyedarchiverDemo[39225:439050] messObject = name = Yue,time = 2016-03-23,pictures = 1111111||2222222||3333333||
2016-04-06 17:07:13.013 KeyedarchiverDemo[39225:439050] 

多个数据:
2016-04-06 17:07:13.013 KeyedarchiverDemo[39225:439050] message = name = Yue,time = 2016-03-23,pictures = 1111111||2222222||3333333||
2016-04-06 17:07:13.014 KeyedarchiverDemo[39225:439050] message = name = Yue,time = 2016-03-23,pictures = AAAAAA||BBBBBB||CCCCCC||
```

最后看一下本地文件夹以及文件都已经存在:
![这里写图片描述](http://img.blog.csdn.net/20160406171000388)
