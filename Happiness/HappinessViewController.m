//
//  HappinessViewController.m
//  Happiness
//
//  Created by theinfamousrj on 1/28/12.
//  Copyright (c) 2012 omfgp.com. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"

@interface HappinessViewController() <FaceViewDataSource>
@property (nonatomic, weak) IBOutlet FaceView *faceView;
@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;


/* 
 Setter override for happiness
 Also calls a display redraw
*/
- (void)setHappiness:(int)happiness
{
    _happiness = happiness;
    [self.faceView setNeedsDisplay];
}

/* 
 Setter override for faceView
 Adds two gesture recognizers: pinch & pan
 Adds a faceView data source: dataSource
*/
- (void)setFaceView:(FaceView *)faceView
{
    _faceView = faceView;
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];
    self.faceView.dataSource = self;
}

/*
 Implements recognition for the pan gesture
*/
- (void)handleHappinessGesture:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.faceView];
        self.happiness += translation.y / 2;
        [gesture setTranslation:CGPointZero inView:self.faceView];
    }
}

/*
 Returns the modified happiness in units the faceView can understand
*/
- (float)smileForFaceView:(FaceView *)sender
{
    return (self.happiness - 50) / 25.0;
}

/*
 Implementation of autorotation
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
