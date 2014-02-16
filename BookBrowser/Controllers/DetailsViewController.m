//
//  DetailsViewController.m
//  BookBrowser
//
//  Created by Sebastián Varela on 16/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
	@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
	@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
	@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
	@property (weak, nonatomic) IBOutlet UIWebView *synopsisWebView;
@end

@implementation DetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	self.title = NSLocalizedString(@"Detalles", nil);
	self.authorLabel.text = self.book.author;
	self.titleLabel.text = self.book.title;

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSURL *url = [NSURL URLWithString:self.book.coverUrl];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *coverImage = [UIImage imageWithData:data];
		self.coverImageView.image = coverImage;
	});
}


@end
