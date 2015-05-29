//
//  ConnectionListener.m
//  GeoliveFramework
//
//  Created by Nick Blackwell on 2013-10-09.
//  Copyright (c) 2013 Nick Blackwell. All rights reserved.
//

#import "ConnectionListener.h"
@interface ConnectionListener()

@property int sent;

@property bool shouldStart;

@end
@implementation ConnectionListener

@synthesize connection, callback, progressHandler, nameForQueue, callbackTarget;


-(void)start{
    if(self.connection!=nil){
        
        if(self.nameForQueue==nil){
            self.nameForQueue=[NSString stringWithFormat:@"%@:Url Connection Listener Queue",[self class]];
        }
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = self.nameForQueue;
   
        [connection setDelegateQueue:queue];
        [connection start];
    }else{
        self.shouldStart=true;
    }
}
-(void)setConnection:(NSURLConnection *)con{
    connection=con;
    if(self.shouldStart)[self start];
}
-(void)startWithTarget:(id)target andCallback:(void (^)(NSDictionary * response, id target)) completion{
    [self setCallbackTarget:target];
    [self setCallback:completion];
    [self start];
}
-(void)startWithTarget:(id)target callback:(void (^)(NSDictionary * response, id target)) completion andProgressHandler:(void (^)(float percentFinished, id target)) progress{
    [self setCallbackTarget:target];
    [self setCallback:completion];
    [self setProgressHandler:progress];
    [self start];

}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *dataString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",dataString);
    
    
    NSError *decodeError=nil;
    NSDictionary *json =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&decodeError];
    
    if(decodeError.code==0){
        
        if(self.callback!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.callback(json, self.callbackTarget);
            });
            
        }else{
            NSLog(@"%s: Finished without data handler",__PRETTY_FUNCTION__);
        }
        
        
    }else{
        //NSLog(@"%@: Response:  %@", [self class], [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        // NSLog(@"%@: Error %i %@ %@ for[%@]", [self class], [decodeError code],[decodeError description],[decodeError debugDescription],url );
        
        // @throw [[NSException alloc] initWithName:[NSString stringWithFormat:@"%@: Json Query Exception: %@ - %@",[self class], decodeError.domain, url] reason:decodeError.description userInfo: decodeError.userInfo];
    }
}


- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    //NSLog(@"%ld, %ld, %ld", (long)bytesWritten, (long)totalBytesWritten, (long)totalBytesExpectedToWrite);
    int unit=100;
    int s=(int)round(((float)totalBytesWritten/(float)totalBytesExpectedToWrite)*unit);
    if(self.sent!=s){
        self.sent=s;
        if(self.progressHandler!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressHandler(s/(float)unit, self.callbackTarget);
            });
        }
    }
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}


@end
