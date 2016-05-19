//
//  HelpVC.m
//  StackDosh
//
//  Created by Surender on 24/03/15.
//  Copyright (c) 2015 trigma. All rights reserved.
//

#import "HelpVC.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"


@interface HelpVC ()

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[proxyService sharedProxy]showActivityIndicatorInView:self.view withLabel:@"Please wait..."];
    
    NSURL *targetURL = [NSURL URLWithString:@"http://payusapp.com/FAQ?"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [HelpWebView loadRequest:request];

    // Do any additional setup after loading the view.
}

- (IBAction)TappedOnback:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[proxyService sharedProxy]hideActivityIndicatorInView];
    //Stop or remove progressbar
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[proxyService sharedProxy]hideActivityIndicatorInView];
    //Stop or remove progressbar and show error
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
