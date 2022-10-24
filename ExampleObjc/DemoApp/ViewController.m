//
//  ViewController.m
//  DemoApp
//
//  Created by Deniss Kaibagarovs on 24/10/2022.
//

#import "ViewController.h"
#import <dojo_ios_sdk_drop_in_ui-Swift.h>

@interface ViewController ()
@property DojoSDKDropInUI *dojoUI;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onStartPaymentFlowPress:(id)sender {
    self.dojoUI = [[DojoSDKDropInUI alloc] init];
    [self.dojoUI startPaymentFlowWithPaymentIntentId:@"pi_sandbox_TppuC1x2q06PEfRnagLVfA"
                                          controller: self
                                      customerSecret: nil
                                      applePayConfig: nil
                                       themeSettings: nil
                                          completion:^(NSInteger result) {
        
    }];
}


@end
