//
//  ViewController.m
//  Melodies of Life
//
//  Created by 岩佐 淳史 on 2013/09/08.
//  Copyright (c) 2013年 BIGLOBE. All rights reserved.
//

#import "GmUtil.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"

@interface ViewController ()
{
    AVAudioPlayer* player;
    AVAudioPlayer *player1, *player2;
    NSMutableArray* imageViews;
    GmUtil *gmUtil;
    MPMoviePlayerController *moviePlayer;
    NSTimer *theTimer;
    NSInteger stepCounter;
    NSArray *steps;
    NSInteger score;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    imageViews = [NSMutableArray array];
    //gmUtil = [[GmUtil alloc] initAndGetToken];
    [self setupSteps];
    [self setupAudio];
}

- (void)setupSteps
{
    steps = @[
  @{@"duration":@1.498090, @"type": @1},
  // @{@"duration":@2.635984, @"type": @1},
  @{@"duration":@3.471449, @"type": @1},
  // @{@"duration":@4.237781, @"type": @0},
  @{@"duration":@5.061984, @"type": @0},
  // @{@"duration":@5.793411, @"type": @1},
  @{@"duration":@6.710620, @"type": @0},
  // @{@"duration":@8.312818, @"type": @1},
  @{@"duration":@9.044172, @"type": @0},
  // @{@"duration":@9.857301, @"type": @1},
  @{@"duration":@10.669471, @"type": @0},
  // @{@"duration":@11.656390, @"type": @1},
  @{@"duration":@12.318046, @"type": @1},
  // @{@"duration":@13.003049, @"type": @1},
  @{@"duration":@14.709781, @"type": @0},
  // @{@"duration":@15.394612, @"type": @1},
  @{@"duration":@16.242636, @"type": @1},
  // @{@"duration":@17.089748, @"type": @1},
  @{@"duration":@17.844327, @"type": @0},
  // @{@"duration":@18.703439, @"type": @0},
  @{@"duration":@19.434877, @"type": @0},
  // @{@"duration":@20.189686, @"type": @1},
  @{@"duration":@21.048668, @"type": @0},
  // @{@"duration":@21.803149, @"type": @0},
  @{@"duration":@22.604252, @"type": @1},
  // @{@"duration":@23.347251, @"type": @0},
  @{@"duration":@24.171720, @"type": @0},
  // @{@"duration":@24.949583, @"type": @1},
  @{@"duration":@25.727314, @"type": @0},
  // @{@"duration":@26.540042, @"type": @1},
  @{@"duration":@27.329568, @"type": @0},
  // @{@"duration":@28.281469, @"type": @1},
  @{@"duration":@29.012878, @"type": @1},
  @{@"duration":@29.860427, @"type": @1},
              ];
}

-(void)setupAudio1
{
    NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"0645" ofType:@"mp3"]];
    player1 = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
    player1.volume = 0.2f;

}

-(void)setupAudio2
{
    NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"horn1" ofType:@"mp3"]];
    player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    player2.volume = 0.3f;
}

- (void)setupAudio
{
    [self setupAudio1];
    [self setupAudio2];
}

- (void)play:(NSInteger)type
{
    if (type == 0) {
        [self setupAudio1];
        [player1 play];
    } else {
        [self setupAudio2];
        [player2 play];
    }
}

-(IBAction)button1Pressed:(id)sender
{
    [self highlightTargetView];
    //[self play:@"0645" WillDelegate:NO];
    //[self judgePoint:self.imageView1 label:self.label1];
    [self play:0];
    [self judgePoint:0];
    [self playHorn];
    NSLog(@"%f", moviePlayer.currentPlaybackTime);
}

-(IBAction)button2Pressed:(id)sender
{
    [self highlightTargetView];
    //[self play:@"horn1" WillDelegate:NO];
    //[self judgePoint:self.imageView2 label:self.label2];
    [self play:1];
    [self judgePoint:1];
    [self playHorn];
}

-(void)judgePoint:(UIImageView*)imageView label:(UILabel*)label
{
    int diff = imageView.frame.origin.x - 24;
    diff = diff / 10;
    if(abs(diff) < 1) label.text = @"Perfect!";
    else if(abs(diff) < 2) label.text = @"Great!";
    else if(abs(diff) < 4) label.text = @"Good";
    else label.text = @"Bad";

    [self performSelector:@selector(clearLabel:) withObject:label afterDelay:0.5];
}

- (void)judgePoint:(NSInteger)type
{
    NSInteger point = 0;

    UIImageView *nearestView = [self findNearestImageView];
    if (nearestView) {
        NSInteger targetIndex = nearestView.tag - 1000;
        NSInteger targetType = [steps[targetIndex][@"type"] intValue];
    
        if (type == targetType) {
            //NSLog(@"OK");
            CGFloat distance = abs(nearestView.frame.origin.x - self.targetView.frame.origin.x) / 5;
            if(distance < 1) {
                score += 100;
                self.label1.text = @"Perfect!";
            } else if(distance < 2) {
                score += 60;
                self.label1.text = @"Great!";
            } else if(distance < 4) {
                score += 30;
                self.label1.text = @"Good";
            } else {
                self.label1.text = @"Bad";
            }
            
        } else {
            //NSLog(@"NG");
            self.label1.text = @"Bad";
        }
        [self updateScoreLabel];
        
        [self performSelector:@selector(clearLabel:) withObject:self.label1 afterDelay:0.5];
    }
}

- (void)updateScoreLabel
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", score];
}

- (UIImageView*)findNearestImageView
{
    UIImageView *result = nil;
    CGFloat nearest = 1.0e10f;
    for (UIImageView *iv in imageViews) {
        CGFloat distance = iv.frame.origin.x - self.targetView.frame.origin.x;
        if (distance > -20 && distance <= nearest) {
            nearest = distance;
            result = iv;
        }
    }
    return result;
}

-(void)clearLabel:(UILabel*)label
{
    label.text = @"";
}
	
-(void)moveImageView:(UIImageView*)imageView
{
    int x = imageView.frame.origin.x - 10;
    imageView.frame = (CGRect){ x, imageView.frame.origin.y, imageView.frame.size };
    if(x < -imageView.frame.size.width) {
        [imageViews removeObject:imageView];
        [imageView removeFromSuperview];
    }
}

-(void)moveImageViews
{
    //[self moveImageView:self.imageView1];
    //[self moveImageView:self.imageView2];
    for (int i = imageViews.count - 1; i >= 0; --i)
    {
        UIImageView* iv = imageViews[i];
        [self moveImageView:iv];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.startButton setFrame:CGRectMake(0, 0, 568, 320)];
    [self countDown:@3];
}

-(void)frameProc:(NSTimer*)timer{
    //NSLog(@"time: %f", moviePlayer.currentPlaybackTime);
    [self putImageViews];
    [self moveImageViews];
}

-(void)countDown:(NSNumber*)count
{
    [self.startButton setTitle:[NSString stringWithFormat:@"%@", count] forState:UIControlStateNormal];
    if([count integerValue] == 0) {
        self.startButton.hidden = YES;
        self.imageView1.hidden = self.imageView2.hidden = NO;
        //[NSTimer scheduledTimerWithTimeInterval:0.0075f target:self selector:@selector(moveImageViews) userInfo:nil repeats:YES];
        [self startGame];
    }
    else {
        [self performSelector:@selector(countDown:) withObject:@([count integerValue] - 1) afterDelay:1];
    }
}

-(IBAction)startButtonPressed:(id)sender
{
    [self countDown:@3];
}

- (void)playHorn
{
    //[gmUtil invokeVehicleCommand:@"alert"];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tetris" ofType:@"mp4"];
    NSLog(@"%@", path);
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    [moviePlayer setControlStyle:MPMovieControlStyleNone];
    moviePlayer.view.frame = self.movieView.bounds;
    [self.movieView addSubview:moviePlayer.view];
}

- (void)startGame
{
    [moviePlayer play];
    [self startTimer];
    stepCounter = 0;
}

- (void)startTimer
{
    theTimer = [NSTimer scheduledTimerWithTimeInterval:0.01666f * 4 target:self selector:@selector(frameProc:) userInfo:nil repeats:YES];
}

- (void)putImageViews
{
    if (stepCounter < [steps count]) {
        NSDictionary *step = steps[stepCounter];
        if ([step[@"duration"] floatValue] <= moviePlayer.currentPlaybackTime + 1.5) {
            NSString *imageName = [step[@"type"] intValue] == 0 ? @"circle1.png" : @"circle2.png";
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(568, 60, 72, 72)];
            [iv setImage:[UIImage imageNamed:imageName]];
            [iv setTag:stepCounter + 1000];
            [imageViews addObject:iv];
            [self.view insertSubview:iv belowSubview:self.targetView];
            stepCounter++;
        }
    }
}

- (void)highlightTargetView
{
    self.targetView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.2 animations:^{
        self.targetView.transform = CGAffineTransformIdentity;
    }];
}

@end
