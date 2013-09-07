//
//  ViewController.m
//  Melodies of Life
//
//  Created by 岩佐 淳史 on 2013/09/08.
//  Copyright (c) 2013年 BIGLOBE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    AVAudioPlayer* player;
}
@end

@implementation ViewController

- (void)playChar:(const char* const)path WillDelegate:(BOOL)flag
{
    NSURL* fileURL = [self getURLfromBundleChar:path];
    [self play:fileURL WillDelegate:flag];
}

- (void)play:(NSURL*)fileURL WillDelegate:(BOOL)flag
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    player.delegate = flag ? self : nil;
    [player prepareToPlay];
    [player play];
}

- (NSURL*)getURLfromBundleChar:(const char* const)path
{
    NSString* str = [NSString stringWithCString:path encoding:NSASCIIStringEncoding];
    return [self getURLfromBundle:str];
}

- (NSURL*)getURLfromBundle:(NSString*)path
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* filePath = [mainBundle pathForResource:path ofType:@"mp3"];
    return [NSURL fileURLWithPath:filePath];
}

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

-(IBAction)button1Pressed:(id)sender
{
    [self play:[self getURLfromBundle:@"0645"] WillDelegate:NO];
}

-(IBAction)button2Pressed:(id)sender
{
    [self play:[self getURLfromBundle:@"horn1"] WillDelegate:NO];
}

@end
