//
//  VideoView.h
//  MusicMix
//
//  Created by YYDD on 16/1/19.
//  Copyright © 2016年 com.campus.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoView : UIView

+(instancetype)createdView;

@property(nonatomic,strong)NSURL *sourceVideoUrl;


/**
 *  暂停播放
 */
-(void)autoPauseVideo;


@end
