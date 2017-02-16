//
//  RDSocketManager.h
//  RDSocket
//
//  Created by 郭春城 on 16/10/25.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface RDSocketManager : NSObject

+ (RDSocketManager *)defaultManager;

- (void)searchBox;
- (void)callQRCode;
- (void)searchDLNASetting;
- (void)closeSocket;

@end
