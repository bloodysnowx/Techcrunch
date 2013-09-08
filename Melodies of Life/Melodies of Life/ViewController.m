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
}

-(IBAction)button2Pressed:(id)sender
{
    [self play:@"horn1" WillDelegate:NO];
}

-(void)moveImageView1
{
    self.imageView1.frame = (CGRect){ ((int)self.imageView1.frame.origin.x - 1 + 320) % 320, self.imageView1.frame.origin.y, self.imageView1.frame.size };
    self.imageView2.frame = (CGRect){ ((int)self.imageView2.frame.origin.x - 1 + 320) % 320, self.imageView2.frame.origin.y, self.imageView2.frame.size };
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(moveImageView1) userInfo:nil repeats:YES];
}

@end
