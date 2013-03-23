//
//  AutoScrollLabel.h
//  AutoScrollLabel
//
//  Created by Brian Stormont on 10/21/09.
//  Copyright 2009 Stormy Productions. All rights reserved.
//
//  Permission is granted to use this code free of charge for any project.
//

#import <UIKit/UIKit.h>

#define NUM_LABELS 2

@class CALayer;

enum AutoScrollDirection {
	AUTOSCROLL_SCROLL_RIGHT,
	AUTOSCROLL_SCROLL_LEFT,
};

@interface AutoScrollLabel : UIView <UIScrollViewDelegate>{
	UILabel *label[NUM_LABELS];
	enum AutoScrollDirection scrollDirection;
	float scrollSpeed;
	NSTimeInterval pauseInterval;
	int bufferSpaceBetweenLabels;
	bool isScrolling;
}
@property(nonatomic) enum AutoScrollDirection scrollDirection;
@property(nonatomic) float scrollSpeed;
@property(nonatomic) NSTimeInterval pauseInterval;
@property(nonatomic) int bufferSpaceBetweenLabels;
// normal UILabel properties
@property(nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic, strong) UIFont *font;
@property (nonatomic,strong) UIImageView* leftFade;
@property (nonatomic,strong) UIImageView* rightFade;
@property (nonatomic,strong) CALayer* maskLayer;
@property (nonatomic,strong) CALayer* rightShadowMask;
@property (nonatomic,strong) CALayer* leftShadowMask;


- (void) readjustLabels;
- (void) setText: (NSString *) text;
- (NSString *) text;
- (void) scroll;
- (void) setShadowOffset:(CGSize)offset;
- (void) setShadowColor:(UIColor *)color;

@end
