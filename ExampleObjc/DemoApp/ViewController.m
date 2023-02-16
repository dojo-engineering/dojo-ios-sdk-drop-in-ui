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
    DojoThemeSettings *theme = [DojoThemeSettings getLightTheme];
    [self.dojoUI startPaymentFlowWithPaymentIntentId: @"payment-intent-id"
                                          controller: self
                                      customerSecret: nil
                                      applePayConfig: nil
                                       themeSettings: theme
                                          completion: ^(NSInteger result) {
        NSLog(@"%ld", (long)result);
    }];
}

@end
