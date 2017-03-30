//
//  GCCAirPlayServer.h
//  AirPlayTest
//
//  Created by 郭春城 on 17/3/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCCAirPlayServer : NSObject

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) BOOL overscanned;
@property (nonatomic, assign) float refreshRate;
@property (nonatomic, copy) NSString * version;

@end
