//
//  MainViewController.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "MainViewController.h"
#import "VKSdk.h"
#import "VKFriendListTVC.h"

static NSString * const UFSVK_SHOW_LIST_SEGUE_ID = @"showList";
static NSString * const TOKEN_KEY = @"app_access_token";
static NSString * const UFSVK_APP_ID = @"5490691";
static NSArray *SCOPE = nil;

@interface MainViewController () <VKSdkDelegate, VKSdkUIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation MainViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    SCOPE = @[VK_PER_FRIENDS, VK_PER_GROUPS];
    [[VKSdk initializeWithAppId:UFSVK_APP_ID] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        switch (state) {
            case VKAuthorizationAuthorized: {
                    [self updateUISetHiddenloginButton:YES andMessage:@"Session exists. Wait for load."];
                    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
//                        [VKSdk forceLogout];
                        [self performSegueWithIdentifier:UFSVK_SHOW_LIST_SEGUE_ID sender:self];
                    }]; }
                break;
            case VKAuthorizationInitialized:
                [self updateUISetHiddenloginButton:NO andMessage:@"Wait a bit, proceed with login."];
                [VKSdk authorize:SCOPE];
                break;
                case VKAuthorizationError:
                [self updateUISetHiddenloginButton:NO andMessage:@"Proceed with login."];
                break;
            default:
                [self updateUISetHiddenloginButton:NO andMessage:@"Try again later"];
                break;
        }
    }];
}


#pragma mark - User Actions
- (IBAction)tapToLogin:(UIButton*)sender {
    [self updateUISetHiddenloginButton:YES andMessage:@" "];
    [VKSdk authorize:SCOPE];
}

#pragma mark - VKSdkDelegate and VKSdkUIDelegate arbitrary methods
- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self performSegueWithIdentifier:UFSVK_SHOW_LIST_SEGUE_ID sender:self];
    } else if (result.error) {
        self.loginButton.hidden = NO;
        self.loginLabel.text = @" ";
    }
    
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

- (void)vkSdkAccessTokenUpdated:(VKAccessToken *)newToken oldToken:(VKAccessToken *)oldToken {
    //
}

#pragma mark - Helpers
- (void)updateUISetHiddenloginButton:(BOOL)buttonState andMessage:(NSString *)messsage {
    self.loginButton.hidden = buttonState;
    self.loginLabel.text = messsage;
}

@end
