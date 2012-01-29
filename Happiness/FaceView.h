//
//  FaceView.h
//  Happiness
//
//  Created by theinfamousrj on 1/28/12.
//  Copyright (c) 2012 omfgp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// Forward declaration of a class.
@class FaceView;

// FaceView data source protocol
@protocol FaceViewDataSource
- (float)smileForFaceView:(FaceView *)sender;
@end

// FaceView interface
@interface FaceView : UIView

// Scale factor for the face
@property (nonatomic) CGFloat scale;

// Method containing instruction for what to do when a pinch occurs
- (void)pinch:(UIPinchGestureRecognizer *)gesture;

// dataSource
@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;

@end
