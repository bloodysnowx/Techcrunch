//
//  ViewController.m
//  httpStudy
//
//  Created by chrome on 13/09/07.
//  Copyright (c) 2013年 chrome. All rights reserved.
//

#import "ViewController.h"
#import "GmUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animate
{
    GmUtil *util = [[GmUtil alloc] initAndGetToken];
    
    NSDictionary *d = [util getVehiclesDataWithOffset:0 size:2];
    NSLog(@"%@", [d description]);
    
    NSDictionary *d2 = [util invokeVehicleCommand:@"alert"];
    NSLog(@"%@", [d2 description]);
}

@end
