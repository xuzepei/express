//
//  MyView.h
//  Food
//
//  Created by xuzepei on 12/17/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPictureViewController.h"

@interface MyView : UIView {
	
	FDPictureViewController* _delegate;

}

@property(nonatomic,assign)FDPictureViewController* _delegate;

@end
