//
//  ConnectionListener.h
//  GeoliveFramework
//
//  Created by Nick Blackwell on 2013-10-09.
//  Copyright (c) 2013 Nick Blackwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionListener : NSObject<NSURLConnectionDelegate>
@property (weak, nonatomic) void (^callback)(NSDictionary * response, id target);
@property (weak, nonatomic) void (^progressHandler)(float percentFinished, id target);
@property (weak, nonatomic) NSURLConnection *connection;
@property (weak, nonatomic) id callbackTarget;
@property NSString *nameForQueue;

-(void)start;
-(void)startWithTarget:(id)target andCallback:(void (^)(NSDictionary * response , id target)) completion;
-(void)startWithTarget:(id)target callback:(void (^)(NSDictionary * response , id target)) completion andProgressHandler:(void (^)(float percentFinished, id target)) progress;
@end
