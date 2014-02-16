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
	@property (strong, nonatomic) NSURLConnection *bookCollectionConnection;
	@property (strong, nonatomic) NSURLConnection *bookDetailsConnection;
@end

@implementation BookManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _booksData = [NSMutableData data];
    }
    return self;
}

- (void)fetchBookCollection
{
	NSURL *url = [NSURL URLWithString:BOOKS_RESOURCE_URL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	self.bookCollectionConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)fetchBookDetailsWithISBN:(NSString *)isbn
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BOOKS_RESOURCE_URL, isbn]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	self.bookDetailsConnection = [NSURLConnection connectionWithRequest:request delegate:self];
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
	if ([self.delegate respondsToSelector:@selector(bookManagerDidFailReceivingDataFromServerWithError:)])
		[self.delegate bookManagerDidFailReceivingDataFromServerWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Data succesfully received: %lu bytes", [self.booksData length]);
	
	if ([connection isEqual:self.bookCollectionConnection])
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			NSArray *json = [NSJSONSerialization JSONObjectWithData:self.booksData options:kNilOptions error:nil];
			BookList *bookList = [self deserializeJSON:json];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				if ([self.delegate respondsToSelector:@selector(bookManagerDidReceivedBookCollection:)])
					[self.delegate bookManagerDidReceivedBookCollection:bookList];
			});
		});
	}
	else if ([connection isEqual:self.bookDetailsConnection])
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.booksData options:kNilOptions error:nil];
			BookDetails *bookDetails = [BookDetails new];
			for(NSString *key in json)
			{
				if ([bookDetails respondsToSelector:NSSelectorFromString(key)])
					[bookDetails setValue:[json valueForKey:key] forKey:key];
			}
			
			dispatch_async(dispatch_get_main_queue(), ^{
				if ([self.delegate respondsToSelector:@selector(bookManagerDidReceivedBookDetails:)])
					[self.delegate bookManagerDidReceivedBookDetails:bookDetails];
			});
		});
	}
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
