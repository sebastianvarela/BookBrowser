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

- (instancetype)init
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

#pragma mark - Connection Delegate

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
	
	dispatch_async(dispatch_get_main_queue(), ^{
		NSArray *json = [NSJSONSerialization JSONObjectWithData:self.booksData options:kNilOptions error:nil];
		BookList *bookList = [self deserializeJSON:json];
		[self.delegate bookManagerDidReceivedBookCollectionFromServer:bookList];
	});
}

#pragma mark - Custom Methods

- (BookList *)deserializeJSON:(NSArray *)json
{
	BookList *bookList = [BookList new];
	for(NSDictionary *jsonBook in json)
	{
		Book *book = [Book new];
		for(NSString *key in jsonBook)
		{
			if ([book respondsToSelector:NSSelectorFromString(key)])
			{
				if ([key isEqualToString:@"isPremium"])
				{
					NSNumber *isPremium = [NSNumber numberWithBool:[[jsonBook objectForKey:key] boolValue]];
					[book setValue:isPremium forKey:@"premium"];
				}
				else
				{
					[book setValue:[jsonBook valueForKey:key] forKey:key];
				}
			}
		}
		[bookList addBook:book];
	}
	return bookList;
}

@end
