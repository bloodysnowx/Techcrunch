//
//  StartViewController.m
//  Melodies of Life
//
//  Created by 岩佐 淳史 on 2013/09/09.
//  Copyright (c) 2013年 BIGLOBE. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()
{
    AVAudioPlayer* player;
}
@end

@implementation StartViewController

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

@end
