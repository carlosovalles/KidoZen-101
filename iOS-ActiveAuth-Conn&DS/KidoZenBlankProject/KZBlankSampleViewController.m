//
//  KZBlankSampleViewController.m
//  KidoZenBlankProject
//
//  Created by KidoZen Inc on 7/1/14.
//  Copyright (c) 2014 KidoZen. All rights reserved.
//

#import "KZBlankSampleViewController.h"
#import "KZConnectionManager.h"
#import "KZResponse.h"

#define KidoZenAppCenterUrl @"https://public.kidocloud.com"
#define KidoZenAppName @"tasks"
#define KidoZenProvider @"Kidozen"
#define KidoZenSecretSDK_Key @"vI672FJGweb0MG457fkNA8SDzxS08kOTOdQcHVon6+w="


@interface KZBlankSampleViewController () <KZConnectionManagerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) KZConnectionManager *kidoZenConector;
@property (nonatomic,strong) UITextView *helloKidoLabel;
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *pass;
@property (nonatomic, strong) KZResponse *kzResponse;

@end

@implementation KZBlankSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _kidoZenConector = [[KZConnectionManager alloc]initWithAppCenterUrl:KidoZenAppCenterUrl
                                                                AppName:KidoZenAppName
                                                                SDK_Key:KidoZenSecretSDK_Key];
    _kidoZenConector.delegate = self;
    
    _helloKidoLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width-20, 300)];
    [_helloKidoLabel setText:@"Hello Kido . . ."];
    [_helloKidoLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:_helloKidoLabel];
    

}

- (void)conectionSuccessfulWithResponse:(KZResponse *)response{
    
    self.kzResponse = response;
    
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(40, 30, 200, 38)];
//    _userName.text = @"public@kidozen.com";
    _userName.placeholder =  @"user@email.com";	
    _userName.delegate = self;
    [self.view addSubview:_userName];
    
    _pass = [[UITextField alloc]initWithFrame:CGRectMake(40, 70, 200, 38)];
    _pass.placeholder = @"password";
    _pass.secureTextEntry = YES;
    _pass.delegate = self;
    [self.view addSubview:_pass];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(authenticateUser)forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Authenticate" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0, 110.0, self.view.bounds.size.width, 40.0)];
    [self.view addSubview:button];
}



- (void)authenticateUser{
    
    UIActivityIndicatorView * waitingGear = [[UIActivityIndicatorView alloc]initWithFrame:self.view.bounds];
    [waitingGear startAnimating];
    [waitingGear setBackgroundColor:[UIColor colorWithWhite:0 alpha:.7]];
    [self.view addSubview:waitingGear];
    [_pass resignFirstResponder];


     [_kzResponse.application authenticateUser:_userName.text
                                  withProvider:KidoZenProvider
                                   andPassword:_pass.text
                                    completion:^(id authenticationToken) {
        if (authenticationToken) {
            
            NSString *user= [authenticationToken description];
               if(![user hasPrefix:@"Error"])
               {
//                    [self queryConnector];
                    [self queryDataSource];
               }
               else
               {
                   [_helloKidoLabel setText:@"Invalid User or Pass.."];
               }
            
            [waitingGear stopAnimating];
            [waitingGear removeFromSuperview];
        }
    }];
}

-(void)queryConnector{
    
    NSString *jsonString = @"{\"sql\":\"select * from products\"}";
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    id myService = [_kzResponse.application LOBServiceWithName:@"kido-mysql"];
    [myService invokeMethod:@"query" withData:myDictionary completion:^(KZResponse * r) {
        
        [_helloKidoLabel setText:[NSString stringWithFormat:@"Response from Connector:\n\n%@",r.response]];

    }];
    
}


-(void)queryDataSource{

    KZDatasource *ds = [_kzResponse.application DataSourceWithName:@"getAllProducts"];
    
    [ds Query:^(KZResponse *r) {
        NSLog(@"Response: %@",r.response);
        [_helloKidoLabel setText:[NSString stringWithFormat:@"Response from DataSource:\n\n%@",r.response]];
    }];
    
    
//    KZDatasource *ds = [_kzResponse.application DataSourceWithName:@"testDataSource"];
//    [ds Query:^(KZResponse *r) {
//       [_helloKidoLabel setText:[NSString stringWithFormat:@"Response from DataSource:\n\n%@",r.response]];
//    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _pass.placeholder = @"";
}

@end
