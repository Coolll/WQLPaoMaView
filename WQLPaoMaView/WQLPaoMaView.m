//
//  WQLPaoMaView.m
//  WQLPaoMaView
//
//  Created by WQL on 15/12/28.
//  Copyright © 2015年 WQL. All rights reserved.
//

#import "WQLPaoMaView.h"

//单次循环的时间
static const NSInteger animationDuration = 15;


@interface WQLPaoMaView()<CAAnimationDelegate>
{
    //左侧label的frame
    CGRect currentFrame;
    
    //右侧label的frame
    CGRect behindFrame;
    
    //存放左右label的数组
    NSMutableArray *labelArray;

    //label的高度
    CGFloat labelHeight;
    
    //是否为暂停状态
    BOOL isStop;
    
}

@end
@implementation WQLPaoMaView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        CGFloat viewHeight = frame.size.height;
        labelHeight = viewHeight;

        
        UILabel *myLable = [[UILabel alloc]init];
        myLable.text = title;
        myLable.font = [UIFont systemFontOfSize:16.0f];
        myLable.backgroundColor = [UIColor orangeColor];
        
        //计算文本的宽度
        CGFloat calcuWidth = [self widthForTextString:title height:labelHeight fontSize:16.0f];
        
        //这两个frame很重要 分别记录的是左右两个label的frame 而且后面也会需要到这两个frame
        currentFrame = CGRectMake(0, 0, calcuWidth, labelHeight);
        behindFrame = CGRectMake(currentFrame.origin.x+currentFrame.size.width, 0, calcuWidth, labelHeight);
        
        myLable.frame = currentFrame;
        
        [self addSubview:myLable];
        
        labelArray  = [NSMutableArray arrayWithObject:myLable];
        
        //如果文本的宽度大于视图的宽度才开始跑
        if (calcuWidth>frame.size.width) {
            UILabel *behindLabel = [[UILabel alloc]init];
            behindLabel.frame = behindFrame;
            behindLabel.text = title;
            behindLabel.font = [UIFont systemFontOfSize:16.0f];
            behindLabel.backgroundColor = [UIColor orangeColor];
            [labelArray addObject:behindLabel];
            [self addSubview:behindLabel];
            

            [self doCustomAnimation];
        }
    }
    return self;
}

- (void)doCustomAnimation
{
    //取到两个label
    UILabel *lableOne = labelArray[0];
    UILabel *lableTwo = labelArray[1];
    
    [lableOne.layer removeAnimationForKey:@"LabelOneAnimation"];
    [lableTwo.layer removeAnimationForKey:@"LabelTwoAnimation"];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(lableOne.frame.origin.x+currentFrame.size.width/2, lableOne.frame.origin.y+labelHeight/2)],[NSValue valueWithCGPoint:CGPointMake(lableOne.frame.origin.x-currentFrame.size.width/2, lableOne.frame.origin.y+labelHeight/2)]];
    animation.duration = animationDuration;
    animation.delegate = self;
    animation.calculationMode = kCAAnimationLinear;
    animation.removedOnCompletion = NO;
    [lableOne.layer addAnimation:animation forKey:@"LabelOneAnimation"];
    
    
    CAKeyframeAnimation *animationTwo = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animationTwo.values = @[[NSValue valueWithCGPoint:CGPointMake(lableTwo.frame.origin.x+currentFrame.size.width/2, lableTwo.frame.origin.y+labelHeight/2)],[NSValue valueWithCGPoint:CGPointMake(lableTwo.frame.origin.x-currentFrame.size.width/2, lableTwo.frame.origin.y+labelHeight/2)]];
    animationTwo.duration = animationDuration;
    animationTwo.delegate = self;
    animationTwo.removedOnCompletion = NO;
    animationTwo.calculationMode = kCAAnimationLinear;

    [lableTwo.layer addAnimation:animationTwo forKey:@"LabelTwoAnimation"];
    
}



- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    UILabel *lableOne = labelArray[0];
    UILabel *lableTwo = labelArray[1];

    if (flag && anim == [lableOne.layer animationForKey:@"LabelOneAnimation"]) {
       

        //两个label水平相邻摆放 内容一样 label1为初始时展示的 label2位于界面的右侧，未显示出来
        //当完成动画时，即第一个label在界面中消失，第二个label位于第一个label的起始位置时，把第一个label放置到第二个label的初始位置
        lableOne.frame = behindFrame;

        lableTwo.frame = currentFrame;

        //在数组中将第一个label放置到右侧，第二个label放置到左侧（因为此时展示的就是labelTwo）
        [labelArray replaceObjectAtIndex:1 withObject:lableOne];
        [labelArray replaceObjectAtIndex:0 withObject:lableTwo];



        [self doCustomAnimation];
        
    }

    
}


- (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
    
}


- (void)start
{
    
    UILabel *lableOne = labelArray[0];
    [self resumeLayer:lableOne.layer];
    
    UILabel *lableTwo = labelArray[1];
    [self resumeLayer:lableTwo.layer];
    
    isStop = NO;

}

- (void)stop
{
    UILabel *lableOne = labelArray[0];
    [self pauseLayer:lableOne.layer];
    
    UILabel *lableTwo = labelArray[1];
    [self pauseLayer:lableTwo.layer];
    
    isStop = YES;
}

//暂停动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    layer.speed = 0;
    
    layer.timeOffset = pausedTime;
}

//恢复动画
- (void)resumeLayer:(CALayer*)layer
{
    //当你是停止状态时，则恢复
    if (isStop) {
        
        CFTimeInterval pauseTime = [layer timeOffset];
        
        layer.speed = 1.0;
        
        layer.timeOffset = 0.0;
        
        layer.beginTime = 0.0;
        
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil]-pauseTime;
        
        layer.beginTime = timeSincePause;
    }
    
}


@end

