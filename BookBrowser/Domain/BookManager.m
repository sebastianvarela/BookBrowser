//
//  BookManager.m
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "BookManager.h"

static NSString *const BOOKS_RESOURCE_URL = @"http://bqreader.eu01.aws.af.cm/books";

@interface BookManager ()
	@property (strong, nonatomic) NSMutableData *booksData;
@end

@implementation BookManager

- (id)init
{
    self = [super init];
    if (self) {
		NSURL *url = [NSURL URLWithString:BOOKS_RESOURCE_URL];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		(void)[NSURLConnection connectionWithRequest:request delegate:self];
		
		self.booksData = [NSMutableData data];
    }
    return self;
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
	if ([self.delegate respondsToSelector:@selector(bookManagerDidFailReceivingDataFromServer)])
		[self.delegate bookManagerDidFailReceivingDataFromServer];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Data succesfully received: %d bytes", [self.booksData length]);
}

@end
