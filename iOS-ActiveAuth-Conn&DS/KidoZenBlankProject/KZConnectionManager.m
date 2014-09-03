//
//  KidoZenConnectionManager.m
//  KidoZenBlankProject
//
//  Created by KidoZen Inc on 6/30/14.
//  Copyright (c) 2014 KidoZen. All rights reserved.
//

#import "KZConnectionManager.h"
#import "KZResponse.h"
#import "KZApplication.h"

#define KidoZenAppCenterUrl @"https://public.kidocloud.com"
#define KidoZenAppName @"tasks"
#define KidoZenAppSDKKey @"vI672FJGweb0MG457fkNA8SDzxS08kOTOdQcHVon6"


@interface KZConnectionManager ()
@property (nonatomic,strong) KZApplication *kzApp;
@property (nonatomic,strong) NSString *kzAppCenterURL;
@property (nonatomic,strong) NSString *kzAppName;

@end


@implementation KZConnectionManager
@synthesize delegate;

- (id)initWithAppCenterUrl:(NSString*)appCenterUrl andAppName:(NSString*)appNameUrl
{
    if (self = [super init]) {

        self.kzAppCenterURL = appCenterUrl;
        self.kzAppName = appNameUrl;
        [self connectToKidoZenServices];

    }
    
    return self;
}

- (void)connectToKidoZenServices
{
    self.kzApp = [[KZApplication alloc] initWithTennantMarketPlace:_kzAppCenterURL
                                                   applicationName:_kzAppName
                                                    applicationKey:KidoZenAppSDKKey
                                                         strictSSL:NO
                                                       andCallback:^(KZResponse * response) {
                                                           if (response.response!=nil) {
                                                               [self conectionSuccessfulWithResponse:response];
                                                           }else {
                                                               NSLog(@"**** ERROR MESSAGE: Unable to reach the kidozen server. Make sure your KidoZenAppCenterUrl and KidoZenAppName are correct");
                                                           }
                                                       }];

    
}

- (void)conectionSuccessfulWithResponse:(KZResponse*)response{
    if ([delegate respondsToSelector:@selector(conectionSuccessfulWithResponse:)])
    {
        [delegate conectionSuccessfulWithResponse:response];
    }
}

@end
