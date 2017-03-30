//
//  GCCAirPlayDevice.h
//  AirPlayTest
//
//  Created by 郭春城 on 17/3/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCCAirPlayDevice : NSObject

- (instancetype)initWithService:(NSNetService *)service;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *domain;

@property (nonatomic, copy) NSString *hostName;

@property (nonatomic, copy) NSArray<NSData *> *addresses;

@property (nonatomic, assign) NSInteger port;

@property (nonatomic, copy) NSString * streamURL;

@end
