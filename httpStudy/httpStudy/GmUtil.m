//
//  GmUtil.m
//  httpStudy
//
//  Created by chrome on 13/09/07.
//  Copyright (c) 2013年 chrome. All rights reserved.
//

#import "GmUtil.h"

//static NSString * const API_KEY = @"9d08629ada6256e49b2bb72ea";
//static NSString * const SECRET_KEY = @"7d5edef65dec4542";
static NSString * const API_KEY = @"e79b7b3c9ace383d55cdd9dcb";
static NSString * const SECRET_KEY = @"d4c4e72fda56267c";

@implementation GmToken

-(id)initWithAccessToken:(NSString*)token expiresIn:(NSString*)expires tokenType:(NSString*)type {
    self = [super init];
    if (self) {
        _accessToken = token;
        _expiresIn = expires;
        _tokenType = type;
    }
    return self;
}

@end

@implementation GmUtil

static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

- (id)initAndGetToken {
    self = [super init];
    if (self) {
        _token = [self getGmTokenSynchronous];
    }
    return self;
}

- (GmToken*)getGmTokenSynchronous
{
    NSURL *url = [NSURL URLWithString:@"https://developer.gm.com/api/v1/oauth/access_token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_KEY, SECRET_KEY];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(authStr)];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    return [[GmToken alloc] initWithAccessToken:json[@"access_token"] expiresIn:json[@"expires_in"] tokenType:json[@"token_type"]];
}

- (NSDictionary*)getVehiclesDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://developer.gm.com/api/v1/account/vehicles?offset=%d&size=%d", offset, size]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *authStr = [NSString stringWithFormat:@"%@ %@", self.token.tokenType, self.token.accessToken];
    NSLog(@"authValue: %@", authStr);
    [request setValue:authStr forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    return json;
}

- (NSDictionary*)invokeVehicleCommand:(NSString*)command {
    NSString *urlStr = [NSString stringWithFormat:@"https://developer.gm.com/api/v1/account/vehicles/1GKUKKEEF9AR000010/command/%@", command];
    NSLog(@"urlStr: %@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    NSString *authStr = [NSString stringWithFormat:@"%@ %@", self.token.tokenType, self.token.accessToken];
    NSLog(@"authValue: %@", authStr);
    [request setValue:authStr forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

/*
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"response: %@", [response debugDescription]);
    
    return json;
*/

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        /*NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:NSJSONReadingMutableContainers
                          error:&error];
        NSLog(@"%@", [json description]);*/
        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", s);
    }];
    
    return nil;
    
}

@end
