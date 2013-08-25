//
//  ViewController.m
//  ZYPopoverView
//
//  Created by Xinling Zhang on 8/25/13.
//  Copyright (c) 2013 Xinling Zhang. All rights reserved.
//

#import "ViewController.h"
#import "ZYPopoverView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 20, 60, 40);
    [button addTarget:self action:@selector(showPopoverView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPopoverView:(UIButton *)button
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor lightGrayColor];
    [ZYPopoverView showPopoverAtView:button withContentView:view delegate:nil];
    [view release];
}

@end
