//
//  ViewController.h
//  Melodies of Life
//
//  Created by 岩佐 淳史 on 2013/09/08.
//  Copyright (c) 2013年 BIGLOBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate>

-(IBAction)button1Pressed:(id)sender;
-(IBAction)button2Pressed:(id)sender;
-(IBAction)startButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *targetView;
@end
