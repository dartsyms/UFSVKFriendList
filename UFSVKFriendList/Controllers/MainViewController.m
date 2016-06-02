//
//  MainViewController.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "VKSdk.h"

@interface MainViewController () <VKSdkDelegate, VKSdkUIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *loginStatus;

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    VKSdk *instance = [VKSdk initializeWithAppId:UFSVK_APP_IDENTIFIER];
    [instance registerDelegate:self];
    [instance setUiDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateUISetHiddenloginButton:YES andMessage:@" "];
    
    [VKSdk wakeUpSession:@[] completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self performSegueWithIdentifier:UFSVK_SHOW_LIST_SEGUE_ID sender:self];
        } else if (error) {
            [self updateUISetHiddenloginButton:NO andMessage:@"Something nasty happend. Try again later"];
        } else {
            [self updateUISetHiddenloginButton:NO andMessage:@"Authorization needed. Click the button."];
            
        }
    }];
}

#pragma mark - User Actions

- (IBAction)tapToLogin:(UIButton*)sender {
    [self updateUISetHiddenloginButton:YES andMessage:@" "];
    [VKSdk authorize:@[]];
}

#pragma mark - VKSdkDelegate and VKSdkUIDelegate arbitrary methods

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    self.loginButton.hidden = NO;
    self.loginLabel.text = @" ";
    [self performSegueWithIdentifier:UFSVK_SHOW_LIST_SEGUE_ID sender:self];
}

- (void)vkSdkUserAuthorizationFailed {
    [self updateUISetHiddenloginButton:NO andMessage:@"You are not authorized. Try again."];
    self.loginLabel.textColor = [UIColor redColor];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

#pragma mark - Helpers

- (void)updateUISetHiddenloginButton:(BOOL)buttonState andMessage:(NSString *)messsage {
    self.loginButton.hidden = buttonState;
    self.loginLabel.text = messsage;
}

@end
