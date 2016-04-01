//
//  VideoMenuView.h
//  MusicMix
//
//  Created by YYDD on 16/1/21.
//  Copyright © 2016年 com.campus.cn. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VideoMenuDelegate <NSObject>

@optional
-(void)videoPlayOrPause;
-(void)videoFullScreen;
-(void)videoNormalScreen;
-(void)videoChangeProgress:(CGFloat)value;

@end

@interface VideoMenuView : UIView

+(instancetype)createdView;

//+(void)resetPlay;

//-(void)showAlwaysWithAnimate:(BOOL)isAnimated;
//-(void)showWithAnimate:(BOOL)isAnimated;
//-(void)dismiss;



@property(nonatomic,weak)id <VideoMenuDelegate> delegate;
@property(nonatomic,assign)CGFloat videoProgress;
@property(nonatomic,strong)NSString *timeStr;

@property(nonatomic,assign)BOOL bePlaying;
@property(nonatomic,assign)BOOL inFullScreen;   /**< 是否是全屏 */


@end
