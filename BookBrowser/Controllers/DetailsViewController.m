//
//  DetailsViewController.m
//  BookBrowser
//
//  Created by Sebastián Varela on 16/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "DetailsViewController.h"
#import "BookManager.h"

@interface DetailsViewController () <BookManagerDelegate>
	@property (strong, nonatomic) BookManager *bookManager;
	@property (strong, nonatomic) BookDetails *bookDetails;
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
	self.synopsisWebView.dataDetectorTypes = UIDataDetectorTypeNone;
	[self.synopsisWebView loadHTMLString:NSLocalizedString(@"Cargando...", nil) baseURL:nil];

	self.bookManager = [BookManager new];
	self.bookManager.delegate = self;
	[self.bookManager fetchBookDetailsWithISBN:self.book.isbn];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		NSURL *url = [NSURL URLWithString:self.book.coverUrl];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *coverImage = [UIImage imageWithData:data];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			self.coverImageView.image = coverImage;
		});
	});
}

#pragma mark - Book Manager Delegate

- (void)bookManagerDidReceivedBookDetails:(BookDetails *)bookDetails
{
	self.bookDetails = bookDetails;
	[self.synopsisWebView loadHTMLString:self.bookDetails.synopsis baseURL:nil];
}

- (void)bookManagerDidFailReceivingDataFromServerWithError:(NSError *)error
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Aceptar", nil), nil];
	[alert show];
}

@end
