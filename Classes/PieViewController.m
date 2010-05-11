//
//  PieViewController.m
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PieViewController.h"

@implementation PieViewController

@synthesize scrollView, pieView, textField, koreanLabel;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	scrollView.contentSize=CGSizeMake(pieView.frame.size.width,pieView.frame.size.height);
	scrollView.minimumZoomScale=0.52;
	scrollView.maximumZoomScale=1.5;
	scrollView.clipsToBounds=YES;
	scrollView.delegate=self;
	
	scrollView.zoomScale=0.52;	
	// show keyboard
	textField.delegate=self;
	[textField becomeFirstResponder];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:textField];
}

- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)str {
	if(str.length==0) {
		NSLog(@"Backspace");
		if(field.text.length>1) {
			return YES;
		} else {
			[field setText:@" "];
		}
	} else {
		int c=(int)[str characterAtIndex:0];
		
		if((c>=0x3130 && c<=0x318F) || (c>=0x1100 && c<=0x11FF) || (c>=0xAC00 && c<=0xD7AF)) {	// korean letters
			return YES;
		} else {
			int k=(field.text.length>0)?[field.text characterAtIndex:0]:0x20;
			if(k!=0x20) {
				NSLog(@"Korean Input(1) : %C, %04X", k, (int)k);
			}
			[field setText:@" "];
			NSLog(@"Normal Input : %@, %04X", str,c);
			[koreanLabel setHidden:YES];
		}
	}
	return NO;
}

- (BOOL)handleTextFieldChanged:(NSNotification *)notification {
//	NSLog(@"Text(%d) : %@",textField.text.length,textField.text);
	if(textField.text.length>1) {
		unichar c=[textField.text characterAtIndex:0];
		if (c!=0x20) {
			NSLog(@"Korean Input(2) : %C, %04X", c, (int)c);
		}
		[textField setText:[textField.text substringFromIndex:1]];
	}
	[koreanLabel setHidden:NO];
	[koreanLabel setText:textField.text];
	return YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return pieView;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[pieView release];
}


- (void)dealloc {
    [super dealloc];
}

@end
