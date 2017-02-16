//
//  RDSocketManager.m
//  RDSocket
//
//  Created by 郭春城 on 16/10/25.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "RDSocketManager.h"

@interface RDSocketManager ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket * socket;

@end

@implementation RDSocketManager

+ (RDSocketManager *)defaultManager
{
    static dispatch_once_t once;
    static RDSocketManager *manager;
    dispatch_once(&once, ^ {
        manager = [[RDSocketManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)searchBox
{
    NSError *error = nil;
    if (![self.socket bindToPort:3336 error:&error])
    {
        return;
    }
    if (![self.socket joinMulticastGroup:@"239.11.2.6" error:&error])
    {
        return;
    }
    if (![self.socket beginReceiving:&error])
    {
        
        NSLog(@"Error receiving: %@", error);
        return;
    }
    NSData *data = [@"Hello from SavorX APP. Reply to port:1126" dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket sendData:data toHost:@"239.11.2.6" port:1126 withTimeout:-1 tag:1];
}

- (void)callQRCode
{
    NSData *data = [@"call qrcode" dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket sendData:data toHost:@"239.11.2.6" port:1126 withTimeout:-1 tag:1];
}

- (void)searchDLNASetting
{
    
}

- (void)closeSocket
{
    [self.socket close];
}

@end
