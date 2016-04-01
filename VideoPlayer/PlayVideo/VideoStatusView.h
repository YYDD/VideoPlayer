//
//  VideoStatusView.h
//  MusicMix
//
//  Created by YYDD on 16/1/22.
//  Copyright © 2016年 com.campus.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kViewStatusPlay = 1,    /**< 播放 */
    kViewStatusPause = 2,   /**< 暂停 */
    kViewStatusLoading = 3, /**< 加载中 */
}ViewStatus;

@interface VideoStatusView : UIView

+(instancetype)createdView;

@property(nonatomic,assign)ViewStatus curStatus;



@end
