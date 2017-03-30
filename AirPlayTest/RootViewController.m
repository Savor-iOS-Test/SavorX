//
//  RootViewController.m
//  AirPlayTest
//
//  Created by 郭春城 on 17/3/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RootViewController.h"
#import "GCDAsyncSocket.h"
#import "GCCAirPlayDevice.h"
#import "GDataXMLNode.h"
#import "GCCAirPlayServer.h"

@interface RootViewController ()<NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSNetServiceBrowser * brower;
@property (nonatomic, strong) GCDAsyncSocket * ascyncSocket;
@property (nonatomic, strong) NSMutableArray * serviceArray;
@property (nonatomic, strong) NSMutableArray * deviceArray;
@property (nonatomic, strong) GCCAirPlayServer * server;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Air Play";
    
    [self setUpViews];
    [self setUpAirPlay];
}

- (void)setUpViews
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELLID"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
}

- (void)refresh
{
    [self.deviceArray removeAllObjects];
    [self.serviceArray removeAllObjects];
    [self.tableView reloadData];
    [self.brower stop];
    [self.brower searchForServicesOfType:@"_airplay._tcp" inDomain:@""];
    [self.brower performSelector:@selector(stop) withObject:nil afterDelay:6.f];
}

- (void)setUpAirPlay
{
    self.serviceArray = [NSMutableArray new];
    self.deviceArray = [NSMutableArray new];
    self.server = [[GCCAirPlayServer alloc] init];
    
    self.brower = [[NSNetServiceBrowser alloc] init];
    self.brower.delegate = self;
    [self.brower searchForServicesOfType:@"_airplay._tcp" inDomain:@"local."];
    
    self.ascyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    [service setDelegate:self];
    [service resolveWithTimeout:20.f];
    [self.serviceArray addObject:service];
    if(!moreComing)
    {
        [self.brower stop];
    }
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    GCCAirPlayDevice * device = [[GCCAirPlayDevice alloc] initWithService:sender];
    [self.deviceArray addObject:device];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
    
    GCCAirPlayDevice * device = [self.deviceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = device.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCCAirPlayDevice * device = [self.deviceArray objectAtIndex:indexPath.row];
    if (self.ascyncSocket.isConnected) {
        [self.ascyncSocket disconnect];
    }
    [self.ascyncSocket connectToHost:device.hostName onPort:device.port error:NULL];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:device.streamURL]];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:GDataXMLAttributeKind error:nil];
            GDataXMLElement *xmlEle = [xmlDoc rootElement];
            NSArray *bigArray = [xmlEle children];
            for (int i = 0; i < [bigArray count]; i++) {
                GDataXMLElement *element = [bigArray objectAtIndex:i];
                NSArray *needArr = [element children];
                for (int j = 0; j < needArr.count; j++) {
                    GDataXMLElement *needEle = [needArr objectAtIndex:j];
                    if ([needEle.name isEqualToString:@"key"]) {
                        if ([needEle.stringValue isEqualToString:@"height"]) {
                            j++;
                            needEle = [needArr objectAtIndex:j];
                            self.server.height = [needEle.stringValue integerValue];
                        }
                        if ([needEle.stringValue isEqualToString:@"width"]) {
                            j++;
                            needEle = [needArr objectAtIndex:j];
                            self.server.width = [needEle.stringValue integerValue];
                        }
                        if ([needEle.stringValue isEqualToString:@"overscanned"]) {
                            j++;
                            needEle = [needArr objectAtIndex:j];
                            self.server.overscanned = [needEle.name boolValue];
                        }
                        if ([needEle.stringValue isEqualToString:@"refreshRate"]) {
                            j++;
                            needEle = [needArr objectAtIndex:j];
                            self.server.refreshRate = [needEle.stringValue floatValue];
                        }
                        if ([needEle.stringValue isEqualToString:@"version"]) {
                            j++;
                            needEle = [needArr objectAtIndex:j];
                            self.server.version = needEle.stringValue;
                        }
                    }
                }
            }
        }
    }];
    [dataTask resume];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接到%@", host);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
