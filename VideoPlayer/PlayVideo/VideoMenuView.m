//
//  VideoMenuView.m
//  MusicMix
//
//  Created by YYDD on 16/1/21.
//  Copyright © 2016年 com.campus.cn. All rights reserved.
//

#import "VideoMenuView.h"
#import "UIViewExt.h"

static CGFloat bottomHeight = 40.0f;

@interface VideoMenuView()
@property(nonatomic,weak)UISlider *slider;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UIButton *playBtn;
@property(nonatomic,weak)UIButton *screenBtn;

@property(nonatomic,weak)UIButton *backBtn;


@property(nonatomic,weak)UIView *bottomView;
@property(nonatomic,weak)UIView *topView;

@property(nonatomic,weak)UILabel *topLabel;

@property(nonatomic,assign)BOOL menuInShow; /**< 菜单是否在显示中 如果在显示中 则不需要再进行动画 */

@end

@implementation VideoMenuView

+(instancetype)createdView
{
    return [[self alloc]init];
}

-(instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self.layer setMasksToBounds:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
        [self addGestureRecognizer:tapGesture];
        
        [self initUI];
        [self blindAction];
    }
    return self;
}

-(void)layoutSubviews
{
    float btnHeight = 20;
    float timeWidth = 60;
    
    _bottomView.frame = CGRectMake(0, self.frame.size.height - bottomHeight, self.frame.size.width, bottomHeight);
    
    _playBtn.frame = CGRectMake(10, (bottomHeight - btnHeight)/2, btnHeight, btnHeight);
    _screenBtn.frame = CGRectMake(_bottomView.frame.size.width - 10 - btnHeight, (bottomHeight - btnHeight)/2, btnHeight, btnHeight);
    _timeLabel.frame = CGRectMake(_screenBtn.frame.origin.x - timeWidth, (bottomHeight - btnHeight)/2, timeWidth, btnHeight);
    _slider.frame = CGRectMake(_playBtn.frame.origin.x + _playBtn.frame.size.width + 10, 0, _timeLabel.frame.origin.x - _playBtn.frame.origin.x - _playBtn.frame.size.width - 10,bottomHeight);
    
    _topView.frame = CGRectMake(0, 0, self.frame.size.width, bottomHeight);
    _topLabel.frame = _topView.bounds;
    _backBtn.frame = CGRectMake(10, (_topView.height - btnHeight)/2, btnHeight, btnHeight);
}


-(void)initUI
{
    [self initBottomUI];
    [self initTopUI];
    [self changePlayBtnStateBePlay:NO];
}


-(void)initBottomUI
{
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:bottomView];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    bottomView.frame = CGRectMake(0, self.frame.size.height - bottomHeight, self.frame.size.width, bottomHeight);
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(0, 0, 40, 40);
    [playBtn setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:playBtn];
    
    UISlider *slider = [[UISlider alloc]init];
    slider.backgroundColor = [UIColor clearColor];
    slider.tintColor = [UIColor lightGrayColor];
    [slider setThumbImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [bottomView addSubview:slider];
    [slider setUserInteractionEnabled:YES];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    timeLabel.font = [UIFont systemFontOfSize:8];
    timeLabel.textColor = [UIColor whiteColor];
    [timeLabel setText:@"00:00/00:00"];
    [bottomView addSubview:timeLabel];
    [timeLabel sizeToFit];
    
    UIButton *screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    screenBtn.frame = CGRectMake(0, 0, 40, 40);
    [bottomView addSubview:screenBtn];
    
    [screenBtn setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    

    [slider sizeToFit];

    _playBtn = playBtn;
    _slider = slider;
    _timeLabel = timeLabel;
    _screenBtn = screenBtn;
    _bottomView = bottomView;
}


-(void)initTopUI
{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:topView];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    UILabel *topLabel = [[UILabel alloc]init];
    [topLabel setTextColor:[UIColor whiteColor]];
    [topLabel setFont:[UIFont systemFontOfSize:15]];
    [topLabel setText:@"视频"];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topView addSubview:topLabel];
    [topLabel sizeToFit];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.size = CGSizeMake(40, 40);
    backBtn.size = CGSizeMake(60, 40);
    [backBtn setImage:[UIImage imageNamed:@"vodeBackIco"] forState:UIControlStateNormal];
    
    
    [topView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backScreenAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    _topView = topView;
    _topLabel = topLabel;
    _backBtn = backBtn;
}



-(void)blindAction
{
    [_playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_screenBtn addTarget:self action:@selector(screenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(slideValueChanged) forControlEvents:UIControlEventValueChanged];
    
}


-(void)playBtnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(videoPlayOrPause)]) {
        [_delegate videoPlayOrPause];
    }
}

-(void)screenBtnClick
{
    if (_inFullScreen) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(videoFullScreen)]) {
        [_delegate videoFullScreen];
    }
}

-(void)slideValueChanged
{
    if (_delegate && [_delegate respondsToSelector:@selector(videoChangeProgress:)]) {
        [_delegate videoChangeProgress:_slider.value];
    }
    
}


-(void)backScreenAction
{
    if (_inFullScreen) {
        [self backToNormalScreen];
    }else
    {
        //退出返回
//        CurrentPopVC;
        
        
    }

}


-(void)backToNormalScreen
{
    if (_delegate && [_delegate respondsToSelector:@selector(videoNormalScreen)]) {
        [_delegate videoNormalScreen];
    }

}



-(void)changePlayBtnStateBePlay:(BOOL)bePlay
{
    if (bePlay) {
        [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else
    {
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}


-(void)setBePlaying:(BOOL)bePlaying
{
    [self changePlayBtnStateBePlay:bePlaying];
    
    if (!bePlaying) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        [self showAlwaysWithAnimate:NO];

    }else
    {
        [self showWithAnimate:NO];
    }
}


-(void)setVideoProgress:(CGFloat)videoProgress
{
    _videoProgress = videoProgress;
    _slider.value = videoProgress;
}

-(void)setTimeStr:(NSString *)timeStr
{
    [_timeLabel setText:timeStr];
    
}


-(void)setInFullScreen:(BOOL)inFullScreen
{
    _inFullScreen = inFullScreen;
//    if (inFullScreen) {
//        self.topView.hidden = NO;
//    }else
//    {
//        self.topView.hidden = YES;
//    }
    
}



-(void)viewTap
{
    NSLog(@"viewTap");
    [self showWithAnimate:YES];
}




-(void)showAlwaysWithAnimate:(BOOL)isAnimated
{

    NSTimeInterval duration = isAnimated==YES?0.5f:0;

    _bottomView.top = self.height;
    _topView.bottom = 0;
    
    [UIView animateWithDuration:duration animations:^{
        _bottomView.bottom = self.height;
        _topView.top = 0;

    }];

}


-(void)showWithAnimate:(BOOL)isAnimated
{
    
    if (_menuInShow) {
        return;
    }

    [self showAlwaysWithAnimate:YES];
    _menuInShow = YES;

    [self performSelector:@selector(dismiss) withObject:nil afterDelay:3.0];
    
}


-(void)dismiss
{
    NSTimeInterval duration = 0.5;
    
    [UIView animateWithDuration:duration animations:^{
        _bottomView.top = self.height;
        _topView.bottom = 0;
        
    } completion:^(BOOL finished) {
        
        _menuInShow = NO;
    }];
}

//-(void)dismissWithAnimate:(BOOL)isAnimated
//{
//    NSTimeInterval duration = isAnimated==YES?0.5f:0;
//
//    [UIView animateWithDuration:duration animations:^{
//        _bottomView.top = self.height;
//        _topView.bottom = 0;
// 
//    } completion:^(BOOL finished) {
//
//        _menuInShow = NO;
//    }];
//
//}


@end
