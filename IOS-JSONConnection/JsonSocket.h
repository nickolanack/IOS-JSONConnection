//
//  JsonSocket.h
//  Abbisure
//
//  Created by Nick Blackwell on 2013-05-13.
//
//

#import <Foundation/Foundation.h>
#import "ConnectionListener.h"
#import <UIKit/UIKit.h>

@interface JsonSocket : NSObject

@property  (readonly) NSString *lastResponse;
@property  (readonly) NSString *lastQuery;
@property int timeout;

-(id) initWithServer:(NSString *)url;

- (NSDictionary *) queryTask:(NSString *)task;
- (void) queryTask:(NSString *)task completion: (void (^)(NSDictionary *))result;


- (NSDictionary *) queryTask:(NSString *)task WithJson:(NSDictionary *) json;
- (void) queryTask:(NSString *)task WithJson:(NSDictionary *) json completion: (void (^)(NSDictionary *))result;

- (bool) requestServerSession;

+(NSDictionary *) QueryServer:(NSString *)server Task:(NSString *)task WithJson:(NSDictionary *)json;
+(NSDictionary *) QueryServer:(NSString *)server Task:(NSString *)task;

+(void)QueryServer:(NSString *)server Task:(NSString *)task WithJson:(NSDictionary *)json Completion:(void (^)(NSDictionary *))result;
+(void)QueryServer:(NSString *)server Task:(NSString *)task Completion:(void (^)(NSDictionary *))result;


-(ConnectionListener *)uploadImage:(UIImage *)image;
-(ConnectionListener *)uploadVideo:(NSURL *)file;
@end

