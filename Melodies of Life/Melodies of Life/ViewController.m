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

- (void)playURL:(NSURL*)fileURL WillDelegate:(BOOL)flag
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    player.delegate = flag ? self : nil;
    [player prepareToPlay];
    [player play];
}

- (void)play:(NSString*)fileName WillDelegate:(BOOL)flag
{
    NSURL* fileURL = [self getURLfromBundle:fileName];
    [self playURL:fileURL WillDelegate:flag];
}

- (NSURL*)getURLfromBundle:(NSString*)path
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* filePath = [mainBundle pathForResource:path ofType:@"mp3"];
    return [NSURL fileURLWithPath:filePath];
}

-(IBAction)button1Pressed:(id)sender
{
    [self play:@"0645" WillDelegate:NO];
    [self judgePoint:self.imageView1 label:self.label1];
}

-(IBAction)button2Pressed:(id)sender
{
    [self play:@"horn1" WillDelegate:NO];
    [self judgePoint:self.imageView2 label:self.label2];
}

-(void)judgePoint:(UIImageView*)imageView label:(UILabel*)label
{
    int diff = imageView.frame.origin.x - 24;
    diff = diff / 10;
    if(abs(diff) < 1) label.text = @"Perfect!";
    else if(abs(diff) < 2) label.text = @"Great!";
    else if(abs(diff) < 4) label.text = @"good";
    else label.text = @"bad";

    [self performSelector:@selector(clearLabel:) withObject:label afterDelay:0.5];
}

-(void)clearLabel:(UILabel*)label
{
    label.text = @"";
}

-(void)moveImageView:(UIImageView*)imageView
{
    int x = imageView.frame.origin.x - 1;
    if(x < -imageView.frame.size.width) x = 320;
    imageView.frame = (CGRect){ x, imageView.frame.origin.y, imageView.frame.size };
}

-(void)moveImageViews
{
    [self moveImageView:self.imageView1];
    [self moveImageView:self.imageView2];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(moveImageViews) userInfo:nil repeats:YES];
}

@end
