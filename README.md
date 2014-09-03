KidoZen-101
===========

This Kidozen Sample project demostrates how to authenticate and perform some Basic Connector and DataSource Operations:

The project first excecutes from the app delegate the KZBlankSampleViewController in the AppDelegate.m file:

 KZBlankSampleViewController * sampleView = [[KZBlankSampleViewController alloc]init];
 self.window.rootViewController = sampleView;
 
 
 The loaded sample view controller called KZBlankSampleViewController executes the connection to the Kidozen platform and over the KZConnectionManagerDelegate, delegates with the protocol:
 
KZConnectionManager.h
.
@protocol KZConnectionManagerDelegate <NSObject>
- (void)conectionSuccessfulWithResponse:(KZResponse*)response;
@end
.
.

In the interface we register the delegate method from the ConnectionManager Class.

KZBlankSampleViewController.m
 
 @interface KZBlankSampleViewController () <KZConnectionManagerDelegate,UITextFieldDelegate>

// Add the properties for the class
@property (nonatomic,strong) KZConnectionManager *kidoZenConector;
@property (nonatomic,strong) UITextView *helloKidoLabel;
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *pass;
@property (nonatomic, strong) KZResponse *kzResponse;

@end

@implementation KZBlankSampleViewController


// The view did Load will excecute the KZConnectionManager.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _kidoZenConector = [[KZConnectionManager alloc]initWithAppCenterUrl:KidoZenAppCenterUrl andAppName:KidoZenAppName];
    _kidoZenConector.delegate = self;
    
    _helloKidoLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width-20, 300)];
    [_helloKidoLabel setText:@"Hello Kido . . ."];
    [_helloKidoLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:_helloKidoLabel];
    

}

Connection successful from delegate:
-----------------------------------

In this method we will create the TextFields needed for the authentication View with the respective Login and Password.

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
 
 
 
Authentication 
==============

[_kzResponse.application authenticateUser:_userName.text
                                  withProvider:@"Kidozen"
                                   andPassword:_pass.text
                                    completion:^(id c) {
        if (c) {
          // continue after authentication
          [self queryConnector];
//                    [self queryDS];
        }
    }]; 
 
 
 
Data Virtualization:
===============
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

Data Sources:
=============
-(void)queryDS{

    KZDatasource *ds = [_kzResponse.application DataSourceWithName:@"getAllProducts"];
    [ds Query:^(KZResponse *r) {
       [_helloKidoLabel setText:[NSString stringWithFormat:@"Response from DataSource:\n\n%@",r.response]];
    }];
    
}
