//
//  Looker.m
//  PictureLook
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 cheniue. All rights reserved.
//

#import "Looker.h"

@implementation Looker
{
    UIView *panView;
    NSArray *imageArray;
    NSInteger imageIndex;
    UITapGestureRecognizer *tapGesture;
    UILongPressGestureRecognizer *longTapGesture;
    UILabel *nummberLabel;
}
@synthesize imageView = _imageView;

-(void)saveImage:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan)
    {
        
            if (_imageView.image!=nil)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"是否保存图片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        if (_imageView.image!=nil)
        {
            UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, NULL);
            [self saveSuccess];
        }
    }
}
-(void)saveSuccess
{
//    [Common showTintHud:@"保存成功" superView:self];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        imageIndex = 0;
        
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_imageView setBackgroundColor:[UIColor whiteColor]];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self setDelegate:self];
        [self setMaximumZoomScale:3.0f];
        [self setMinimumZoomScale:0.5f];
        [self addSubview:_imageView];
        
        
        panView = [[UIView alloc]initWithFrame:CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height)];
        [self addSubview:panView];
        
        UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goLast:)];
        [leftSwip setNumberOfTouchesRequired:1];
        [leftSwip setDirection:UISwipeGestureRecognizerDirectionRight];
        [panView addGestureRecognizer:leftSwip];
        
        UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goNext:)];
        [rightSwip setNumberOfTouchesRequired:1];
        [rightSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
        [panView addGestureRecognizer:rightSwip];
        
        
        tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapZoom:)];
        [tapGesture setNumberOfTapsRequired:2];
        [tapGesture setNumberOfTouchesRequired:1];
        [panView addGestureRecognizer:tapGesture];
        
        longTapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
        [longTapGesture setMinimumPressDuration:1.2f];
        [longTapGesture setNumberOfTouchesRequired:1];
        [panView addGestureRecognizer:longTapGesture];
        
        UITapGestureRecognizer *singerTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromSuperview)];
        [singerTapGesture setNumberOfTapsRequired:1];
        [singerTapGesture setNumberOfTouchesRequired:1];
        [singerTapGesture requireGestureRecognizerToFail:tapGesture];
        [panView addGestureRecognizer:singerTapGesture];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, panView.frame.size.height-80, panView.frame.size.width, 80)];
        [bottomView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];

        nummberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, bottomView.frame.size.width-20, 20)];
        [nummberLabel setBackgroundColor:[UIColor clearColor]];
        [nummberLabel setTextAlignment:2];
        [nummberLabel setFont:[UIFont systemFontOfSize:18]];
        [nummberLabel setText:@"0 / 0"];
        [bottomView addSubview:nummberLabel];
        [panView addSubview:bottomView];
        
    }
    return self;
}
-(void)showNummberIndex
{
    [nummberLabel setText:[NSString stringWithFormat:@"%lu / %lu",(unsigned long)(imageIndex+1),(unsigned long)imageArray.count]];
}
-(void)resetImageViewSize
{
    if ([_imageView.image isKindOfClass:[UIImage class]])
    {
        CGSize imageSize = _imageView.image.size;
        if ((imageSize.width/imageSize.height)>=(self.frame.size.width/self.frame.size.height))////横向保持
        {
            CGFloat h = imageSize.height/imageSize.width*self.frame.size.width;
            CGFloat y = (self.frame.size.height-h)/2.0f;
            [_imageView setFrame:CGRectMake(0, y, self.frame.size.width, h)];
        }
        else
        {
            CGFloat w = imageSize.width/imageSize.height*self.frame.size.height;
            CGFloat x = (self.frame.size.width-w)/2.0f;
            [_imageView setFrame:CGRectMake(x, 0, w , self.frame.size.height)];
        }
    }
    [self showNummberIndex];
}
-(void)showImageArray:(NSArray*)array
{
    imageArray = array;
    [_imageView setFrame:self.bounds];
    [self setZoomScale:1.0f animated:NO];
    imageIndex = 0;
    if (imageArray.count>0)
    {
        id aimage = [imageArray objectAtIndex:imageIndex];
        if ([aimage isKindOfClass:[UIImage class]])
        {
            [_imageView setImage:aimage];
        }
//        else if ([aimage isKindOfClass:[NSString class]])
//        {
//            [_imageView setImageWithURL:[NSURL URLWithString:aimage] placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
//        }
//        else if ([aimage isKindOfClass:[NSURL class]])
//        {
//            [_imageView setImageWithURL:aimage placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
//        }
        [self resetImageViewSize];
    }
    else
    {
        [_imageView setImage:nil];
    }
}
-(void)setShowIndex:(NSInteger)index
{
    [_imageView setFrame:self.bounds];
    [self setZoomScale:1.0f animated:NO];
    imageIndex = index;
    if (imageArray.count>0)
    {
        id aimage = [imageArray objectAtIndex:imageIndex];
        if ([aimage isKindOfClass:[UIImage class]])
        {
            [_imageView setImage:aimage];
        }
//        else if ([aimage isKindOfClass:[NSString class]])
//        {
//            [_imageView setImageWithURL:[NSURL URLWithString:aimage] placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
//        }
//        else if ([aimage isKindOfClass:[NSURL class]])
//        {
//            [_imageView setImageWithURL:aimage placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
//        }
        [self resetImageViewSize];
    }
    else
    {
        [_imageView setImage:nil];
    }
}
-(void)goLast:(UISwipeGestureRecognizer*)gesture
{
    if (imageArray.count<=0)
    {
        return;
    }
    if (gesture.state==UIGestureRecognizerStateEnded)
    {
        [_imageView setFrame:self.bounds];
        [self setZoomScale:1.0f animated:NO];
        imageIndex--;
        imageIndex = imageIndex<0?(imageArray.count-1):imageIndex;
        
        CATransition *animation = [CATransition animation];
        //动画时间
        animation.duration = 0.7f;
        //先慢后快
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        //animation.removedOnCompletion = NO;
        
        //各种动画效果
        /*
         kCATransitionFade;
         kCATransitionMoveIn;
         kCATransitionPush;z
         kCATransitionReveal;
         */
        /*
         kCATransitionFromRight;
         kCATransitionFromLeft;
         kCATransitionFromTop;
         kCATransitionFromBottom;
         */
        //各种组合
        
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        
        id aimage = [imageArray objectAtIndex:imageIndex];
        if ([aimage isKindOfClass:[UIImage class]])
        {
            [_imageView setImage:aimage];
        }
//        else if ([aimage isKindOfClass:[NSString class]])
//        {
//            [_imageView setImageWithURL:[NSURL URLWithString:aimage] placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
//        }
//        else if ([aimage isKindOfClass:[NSURL class]])
//        {
//            [_imageView setImageWithURL:aimage placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
//        }
        [animation setDelegate:self];
        [_imageView.layer addAnimation:animation forKey:@"animation"];
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self resetImageViewSize];
}
-(void)goNext:(UISwipeGestureRecognizer*)gesture
{
    if (imageArray.count<=0)
    {
        return;
    }
    if (gesture.state==UIGestureRecognizerStateEnded)
    {
        [_imageView setFrame:self.bounds];
        [self setZoomScale:1.0f animated:NO];
        imageIndex++;
        imageIndex = imageIndex>(imageArray.count-1)?0:imageIndex;
        
        CATransition *animation = [CATransition animation];
        //动画时间
        animation.duration = 0.7f;
        //先慢后快
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        //animation.removedOnCompletion = NO;
        
        //各种动画效果
        /*
         kCATransitionFade;
         kCATransitionMoveIn;
         kCATransitionPush;z
         kCATransitionReveal;
         */
        /*
         kCATransitionFromRight;
         kCATransitionFromLeft;
         kCATransitionFromTop;
         kCATransitionFromBottom;
         */
        //各种组合
        
        animation.type = kCATransitionPush; 
        animation.subtype = kCATransitionFromRight; 

        id aimage = [imageArray objectAtIndex:imageIndex];
        if ([aimage isKindOfClass:[UIImage class]])
        {
            [_imageView setImage:aimage];
        }
//        else if ([aimage isKindOfClass:[NSString class]])
//        {
//            [_imageView setImageWithURL:[NSURL URLWithString:aimage] placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
//        }
//        else if ([aimage isKindOfClass:[NSURL class]])
//        {
//            [_imageView setImageWithURL:aimage placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
//        }
        [animation setDelegate:self];
        [_imageView.layer addAnimation:animation forKey:@"animation"];

    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [panView setFrame:CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height)];
}
-(void)doubleTapZoom:(UITapGestureRecognizer*)gesture
{
    if (gesture.state==UIGestureRecognizerStateEnded)
    {
        if (self.zoomScale<=1.0f)
        {
            [self setZoomScale:2.0f animated:YES];
        }
        else if (self.zoomScale>=2.0f)
        {
            [self setZoomScale:1.0f animated:YES];
            [_imageView setFrame:self.bounds];
        }
    }
}
-(void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated
{
    [super setZoomScale:zoomScale animated:animated];
    if (self.zoomScale<=1.0f)
    {
        [panView setUserInteractionEnabled:YES];
        [self addSubview:panView];
        [_imageView removeGestureRecognizer:tapGesture];
        [panView addGestureRecognizer:tapGesture];
    }
    else
    {
        [panView setUserInteractionEnabled:NO];
        [self bringSubviewToFront:_imageView];
        [panView removeFromSuperview];
        [panView removeGestureRecognizer:tapGesture];
        [_imageView addGestureRecognizer:tapGesture];
    }
}
-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    CGFloat x = _imageView.frame.origin.x;
    CGFloat y = _imageView.frame.origin.y;
    if (_imageView.frame.size.width<=self.frame.size.width)
    {
        x = (self.frame.size.width-_imageView.frame.size.width)/2.0f;
    }
    if (_imageView.frame.size.height<=self.frame.size.height)
    {
        y = (self.frame.size.height-_imageView.frame.size.height)/2.0f;
    }
    [_imageView setFrame:CGRectMake(x, y, _imageView.frame.size.width, _imageView.frame.size.height)];
}
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
