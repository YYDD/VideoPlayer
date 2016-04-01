//
//  VideoStatusView.m
//  MusicMix
//
//  Created by YYDD on 16/1/22.
//  Copyright © 2016年 com.campus.cn. All rights reserved.
//

#import "VideoStatusView.h"
#import "UIViewExt.h"

@interface VideoStatusView()
@property(nonatomic,weak)UIImageView *statusImgV;
@property(nonatomic,weak)UILabel *statusLabel;
@end

@implementation VideoStatusView

+(instancetype)createdView
{
    return [[self alloc]init];
}

-(instancetype)init
{
    if (self = [super init]) {
    
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    UIImageView *statusImgV = [[UIImageView alloc]init];
    statusImgV.frame = CGRectMake(0, 0, 80, 80);
    statusImgV.backgroundColor = [UIColor clearColor];
    [self addSubview:statusImgV];
    _statusImgV = statusImgV;

    
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont systemFontOfSize:18];
    statusLabel.textColor = [UIColor whiteColor];
    [statusLabel setText:@"loading..."];
    [self addSubview:statusLabel];
    [statusLabel sizeToFit];
    
    _statusLabel = statusLabel;
}


-(void)layoutSubviews
{

    _statusImgV.center = CGPointMake(self.width/2, self.height/2);
    _statusLabel.center = CGPointMake(self.width/2, self.height/2);
}

-(void)setCurStatus:(ViewStatus)curStatus
{
    switch (curStatus) {
        case kViewStatusPause:
        {
            [self setHidden:NO];
            _statusImgV.hidden = NO;
            _statusLabel.hidden = YES;
            [_statusImgV setImage:[UIImage imageNamed:@"bigPlay"]];
        }
            break;
        case kViewStatusPlay:
        {
            [self setHidden:YES];
        }
            break;
        case kViewStatusLoading:
        {
            [self setHidden:NO];
            _statusImgV.hidden = YES;
            _statusLabel.hidden = NO;
            NSLog(@"loading...");
        }
            break;
            
        default:
            break;
    }


}



@end
