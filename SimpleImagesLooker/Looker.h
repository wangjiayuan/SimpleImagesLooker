//
//  Looker.h
//  PictureLook
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 cheniue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Looker : UIScrollView
<UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIImageView *_imageView;
}
@property(nonatomic,strong)UIImageView *imageView;
-(void)showImageArray:(NSArray*)array;
-(void)setShowIndex:(NSInteger)index;
@end
