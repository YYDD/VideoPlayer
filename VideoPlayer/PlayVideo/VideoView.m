//
//  VideoView.m
//  MusicMix
//
//  Created by YYDD on 16/1/19.
//  Copyright © 2016年 com.campus.cn. All rights reserved.
//

#import "VideoView.h"
#import <AVFoundation/AVFoundation.h>

#import "VideoMenuView.h"
#import "VideoStatusView.h"


static CGFloat timeInterval = 0.5f;

@interface VideoView()<VideoMenuDelegate>


@property(nonatomic,strong)NSTimer *timer;  /**< 时间轮询 */
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)AVPlayerItem *curPlayerItem;    /**<播放的单个item */


@property(nonatomic,assign)BOOL isPlaying;  /**< 是否正在播放*/

@property(nonatomic,weak)VideoMenuView *menuView;   /**< 播放的状态栏 */
@property(nonatomic,weak)VideoStatusView *statusView;

@property(nonatomic,assign)CGRect originalRect;

@end

@implementation VideoView

+(instancetype)createdView
{
    return [[self alloc]init];
}

-(instancetype)init
{
    if (self = [super init]) {
     
        self.backgroundColor = [UIColor blackColor];
        [self initStatusView];
        [self initMenuView];
    }
    return self;
}

-(void)layoutSubviews
{
    _menuView.frame = self.bounds;
    _statusView.frame = self.bounds;
}




-(void)initMenuView
{
    VideoMenuView *view = [VideoMenuView createdView];
    [self addSubview:view];
    [self bringSubviewToFront:view];
    view.delegate = self;
    _menuView = view;
    
}

-(void)initStatusView
{
    VideoStatusView *view = [VideoStatusView createdView];
    [self addSubview:view];
    [self bringSubviewToFront:view];
    [view setHidden:YES];
    _statusView = view;

}


-(void)initPlayerViewWithVideoUrl:(NSURL *)url
{
    
    
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:url];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.bounds;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:playerLayer];

    [self bringSubviewToFront:_statusView];
    [self bringSubviewToFront:_menuView];
    
    self.player = player;
    self.playerLayer = playerLayer;
    
    //Add observer
    [player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    
    self.isPlaying = YES;
}

-(void)changePlayerVideItemWithVideoUrl:(NSURL *)url
{
    
    [self removePlayerItemKVO];

    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];

    [self addPlayerItemKVO];
    
}


-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timeLoop) userInfo:nil repeats:YES];
    }
    return _timer;
}


-(void)timeLoop
{
    
    if (_isPlaying) {
        float videoProgress = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
        _menuView.videoProgress = videoProgress;
        
        CMTime curTime = self.player.currentItem.currentTime;
        NSUInteger dTotalSeconds = CMTimeGetSeconds(curTime);
//        NSUInteger dHours = floor(dTotalSeconds / 3600);
        NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
        NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
        NSString *curTimeStr = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)dMinutes, (unsigned long)dSeconds];

        
        CMTime durTime = self.player.currentItem.duration;
        NSUInteger dTotalSeconds1 = CMTimeGetSeconds(durTime);
        //        NSUInteger dHours = floor(dTotalSeconds / 3600);
        NSUInteger dMinutes1 = floor(dTotalSeconds1 % 3600 / 60);
        NSUInteger dSeconds1 = floor(dTotalSeconds1 % 3600 % 60);
        NSString *durTimeStr = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)dMinutes1, (unsigned long)dSeconds1];

        NSString *timeStr = [NSString stringWithFormat:@"%@/%@",curTimeStr,durTimeStr];
        _menuView.timeStr = timeStr;
        
    }
}


-(void)setSourceVideoUrl:(NSURL *)sourceVideoUrl
{
    _sourceVideoUrl = sourceVideoUrl;
    if (!sourceVideoUrl) {
        return;
    }

    
    if (self.player) {
        //说明是换视频
        [self changePlayerVideItemWithVideoUrl:sourceVideoUrl];
    }else
    {
        [self initPlayerViewWithVideoUrl:sourceVideoUrl];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timer fire];
    });
    
}


#pragma mark - obsever
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{

    
    if ([keyPath isEqualToString:@"status"]) {
//        NSLog(@"status ======= %ld",(long)self.player.currentItem.status);
    }else
    {
        NSArray *loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
        
        CMTime cTime = self.player.currentTime;
        float currentTime = cTime.value / cTime.timescale;

        
        float curTime = CMTimeGetSeconds(cTime);
        
//        NSLog(@"start == %f---duration-%f",startSeconds,durationSeconds);
//        NSLog(@"result======= %f",result);
//        NSLog(@"curtime==== %f---",currentTime);
//        NSLog(@"curTms ===  %f",curTime);
        
  

        CMTimeScale timeScale = self.player.currentItem.duration.timescale;
        //        float singalTime = CMTimeGetSeconds(self.player.currentItem.duration.timescale);

        
//        NSLog(@"------%f",curTime + (float)timeScale/1000);
        if (curTime + (float)timeScale/1000 > result) {
            self.statusView.curStatus = kViewStatusLoading;
        }else
        {
            self.statusView.curStatus = kViewStatusPlay;
        }
        
        
    }


}



-(void)playVideo
{
    [self.player play];
}


-(void)pauseVideo
{
    [self.player pause];
}

-(void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    self.menuView.bePlaying = isPlaying;
    
    
    if (isPlaying) {
        [self playVideo];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.timer fire];
        });
        
    }else
    {
        [self pauseVideo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.timer invalidate];
            _timer = nil;
        });
    }
}


#pragma mark VideoStatusDelegate
-(void)videoPlayOrPause
{
    self.isPlaying = !_isPlaying;
}

-(void)videoChangeProgress:(CGFloat)value
{
    CMTime cmTime = CMTimeMake(CMTimeGetSeconds(self.player.currentItem.duration) * value , 1);
    [self.player seekToTime:cmTime];
}


-(void)videoFullScreen
{
    _originalRect = self.frame;
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI/2);
    [self setTransform:transform];
    self.frame = [UIScreen mainScreen].bounds;
    self.playerLayer.frame = self.bounds;

    self.menuView.inFullScreen = YES;
    
}

-(void)videoNormalScreen
{
    CGAffineTransform transform =CGAffineTransformMakeRotation(0);
    [self setTransform:transform];
    self.frame = _originalRect;
    self.playerLayer.frame = self.bounds;

    self.menuView.inFullScreen = NO;
    
}



-(void)dealloc
{
    [self removePlayerItemKVO];
}


-(void)addPlayerItemKVO
{
    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
}



-(void)removePlayerItemKVO
{
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}


#pragma mark MethodForVC

-(void)autoPauseVideo
{
    [self pauseVideo];
}



@end
