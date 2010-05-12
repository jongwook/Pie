//
//  PieViewController.h
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieView.h"
#import "PieConnection.h"

@interface PieViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate> {
	UIScrollView *scrollView;
	PieView *pieView;
	UITextField *textField;
	UILabel *koreanLabel;
	PieConnection *pie;
}

- (BOOL)handleTextFieldChanged:(NSNotification *)notification;
- (void)sendKey:(int)key;

@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet PieView *pieView;
@property (nonatomic,retain) IBOutlet UITextField *textField;
@property (nonatomic,retain) IBOutlet UILabel *koreanLabel;
@property (nonatomic,retain) PieConnection *pie;

@end

