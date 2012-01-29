//
//  FaceView.m
//  Happiness
//
//  Created by theinfamousrj on 1/28/12.
//  Copyright (c) 2012 omfgp.com. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

//HEAD
#define DEFAULT_SCALE 0.90
//EYES
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
//MOUTH
#define MOUTH_H 0.45
#define MOUTH_V 0.40
#define MOUTH_SMILE 0.25

/*
 Getter override for scale
 Scale is either DEFAULT_SCALE or something input by the user
*/
- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

/*
 Setter override for scale
 If the scale changes, it calls for a redraw
*/
- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

/*
 Gesture recognition for a pinch
*/
- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

/*
 Setup method for the content mode
 Could have been set in the storyboard inspector
*/
- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

/*
 Runs the setup when the storyboard is awoken
*/
- (void) awakeFromNib
{
    [self setup];
}

/*
 Standard init with a setup call
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/*
 Draws and strokes a circle path with a center at p and a given radius
*/
- (void)drawCircleAtPoint:(CGPoint)p
               withRadius:(CGFloat)radius
                inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

/*
 Standard drawRect method with added functionality
 Draws two circles for eyes, a circle for the head
 and a bezier for the mouth
*/
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw face
    CGPoint midpoint;
    midpoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midpoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width/2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height/2;
    size *= self.scale;
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    [self drawCircleAtPoint:midpoint withRadius:size inContext:context];
    
    
    //draw eyes (2 circles)
    CGPoint eyepoint;
    eyepoint.x = midpoint.x - size * EYE_H;
    eyepoint.y = midpoint.y - size * EYE_V;
    
    [self drawCircleAtPoint:eyepoint withRadius:size * EYE_RADIUS inContext:context];
    eyepoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyepoint withRadius:size * EYE_RADIUS inContext:context];

    
    //draw mouth
    CGPoint mouthStart;
    mouthStart.x = midpoint.x - MOUTH_H * size;
    mouthStart.y = midpoint.y + MOUTH_V * size;
    
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    
    //control points for mouth
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
    float smile = [self.dataSource smileForFaceView:self];
    if (smile < -2) smile = -2;
    if (smile > 2) smile = 2;
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP2.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
}


@end
