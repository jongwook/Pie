//
//  PieViewController.m
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PieViewController.h"

@implementation PieViewController

@synthesize scrollView, pieView, textField;

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
	
	
	scrollView.contentSize=CGSizeMake(640.0,460.0);
	scrollView.minimumZoomScale=0.52;
	scrollView.maximumZoomScale=4.0;
	scrollView.clipsToBounds=YES;
	scrollView.delegate=self;
	
	scrollView.zoomScale=0.52;	
	// show keyboard
	textField.delegate=self;
	[textField becomeFirstResponder];
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleTextFieldChanged:)
//												 name:UITextFieldTextDidChangeNotification
//											   object:textField];
}

- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)str {
	if(str.length==0) {
		NSLog(@"Backspace");
	} else {
		int c=(int)[str characterAtIndex:0];
		NSLog(@"%@, %d",str,c);
	}
	[field setText:@" "];
	return NO;
}
/*
- (void)handleTextFieldChanged:(NSNotification *)notification {
	if(textField.text==@"") {
		NSLog(@"Backspace detected");
		[textField setText:@" "];
	} else {
		NSLog(@"%@",textField.text);
	}
}
*/
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
