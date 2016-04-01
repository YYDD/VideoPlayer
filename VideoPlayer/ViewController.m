//
//  ViewController.m
//  VideoPlayer
//
//  Created by YYDD on 16/4/1.
//  Copyright © 2016年 com.video.test. All rights reserved.
//

#import "ViewController.h"
#import "VideoView.h"

@interface ViewController ()

@property(nonatomic,weak)VideoView *videoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self initVideoView];

    NSURL *url = [NSURL URLWithString:@"http://image.worksdreams.com/video/video/1/3819141.mp4"];
    [self playVideo:url];
}



-(void)initVideoView
{
    VideoView *videoView = [VideoView createdView];
    videoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    videoView.center = self.view.center;
    [self.view addSubview:videoView];
     _videoView = videoView;
}


-(void)playVideo:(NSURL *)videoUrl
{
    _videoView.sourceVideoUrl = videoUrl;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
