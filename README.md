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
