//
//  LibraryViewController.m
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "LibraryViewController.h"

@interface LibraryViewController ()

@property (strong, nonatomic) NSMutableData *booksData;

@end

@implementation LibraryViewController

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
	
	self.booksData = [NSMutableData data];
	
	NSURL *url = [NSURL URLWithString:@"http://bqreader.eu01.aws.af.cm/books"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	(void)[NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.booksData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.booksData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Data succesfully received: %d bytes", [self.booksData length]);
}

@end
