//
//  WQLPaoMaView.h
//  WQLPaoMaView
//
//  Created by WQL on 15/12/28.
//  Copyright © 2015年 WQL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQLPaoMaView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

- (void)start;

- (void)stop;

- (void)doCustomAnimation;


@end
