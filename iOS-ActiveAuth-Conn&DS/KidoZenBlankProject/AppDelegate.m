//
//  AppDelegate.m
//  KidoZenBlankProject
//
//  Created by KidoZen Inc on 6/30/14.
//  Copyright (c) 2014 KidoZen. All rights reserved.
//

#import "AppDelegate.h"
#import "KZBlankSampleViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    KZBlankSampleViewController * sampleView = [[KZBlankSampleViewController alloc]init];
    self.window.rootViewController = sampleView;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
