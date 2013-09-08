//
//  GmUtil.h
//  httpStudy
//
//  Created by chrome on 13/09/07.
//  Copyright (c) 2013年 chrome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GmToken : NSObject

@property NSString *accessToken;
@property NSString *expiresIn;
@property NSString *tokenType;
-(id)initWithAccessToken:(NSString*)token expiresIn:(NSString*)expires tokenType:(NSString*)type;

@end


@interface GmUtil : NSObject

@property GmToken *token;

- (id)initAndGetToken;
- (GmToken*)getGmTokenSynchronous;
- (NSDictionary*)getVehiclesDataWithOffset:(NSInteger)offset size:(NSInteger)size;
- (NSDictionary*)invokeVehicleCommand:(NSString*)command;

@end
