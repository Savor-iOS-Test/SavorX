//
//  GCCAirPlayDevice.m
//  AirPlayTest
//
//  Created by 郭春城 on 17/3/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GCCAirPlayDevice.h"

@implementation GCCAirPlayDevice

- (instancetype)initWithService:(NSNetService *)service
{
    if (self = [super init]) {
        self.name = service.name;
        self.type = service.type;
        self.domain = service.domain;
        self.hostName = service.hostName;
        self.addresses = service.addresses;
        self.port = service.port;
        self.streamURL = [NSString stringWithFormat:@"http://%@:7100/stream.xml", service.hostName];
    }
    return self;
}

@end
