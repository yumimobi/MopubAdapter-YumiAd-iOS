//
//  MPYUMIInterstitialViewController.m
//  YumiMediationMopubAdDemo-iOS
//
//  Created by Michael Tang on 2019/3/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MPYUMIInterstitialViewController.h"
#import "MPInterstitialAdController.h"

@interface MPYUMIInterstitialViewController ()<MPInterstitialAdControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (nonatomic) MPInterstitialAdController *interstitial;

@end

@implementation MPYUMIInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addLog:(NSString *)newLog {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.logTextView.layoutManager.allowsNonContiguousLayout = NO;
        NSString *oldLog = weakSelf.logTextView.text;
        NSString *text = [NSString stringWithFormat:@"%@\n%@", oldLog, newLog];
        if (oldLog.length == 0) {
            text = [NSString stringWithFormat:@"%@", newLog];
        }
        [weakSelf.logTextView scrollRangeToVisible:NSMakeRange(text.length, 1)];
        weakSelf.logTextView.text = text;
    });
}

- (IBAction)handleRequestInterstitial:(UIButton *)sender {
    // Instantiate the interstitial using the class convenience method.
    self.interstitial = [MPInterstitialAdController
                         interstitialAdControllerForAdUnitId:@"d925e06e15dc4e648bb21635639ec340"];
    
    self.interstitial.delegate = self;
    
    // Fetch the interstitial ad.
    [self.interstitial loadAd];
}

- (IBAction)handlePresentInterstitial:(UIButton *)sender {
    if (self.interstitial.ready){
        [self.interstitial showFromViewController:self];
    }
    else {
        [self addLog:@"interstitial not ready"];
    }
}

#pragma mark: MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial{
    [self addLog:@"interstitialDidLoadAd"];
}
- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
                          withError:(NSError *)error{
     [self addLog:[NSString stringWithFormat:@"interstitialDidFailToLoadAd error: %@",error.localizedDescription]];
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial{
    [self addLog:@"interstitialDidAppear"];
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial{
    [self addLog:@"interstitialDidDisappear"];
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial{
    [self addLog:@"interstitialDidReceiveTapEvent"];
}
@end
