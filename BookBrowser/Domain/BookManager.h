//
//  BookManager.h
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookList.h"
#import "BookDetails.h"

@protocol BookManagerDelegate <NSObject>
@optional
- (void)bookManagerDidReceivedBookCollection:(BookList *)bookCollection;
- (void)bookManagerDidReceivedBookDetails:(BookDetails *)bookDetails;
- (void)bookManagerDidFailReceivingDataFromServerWithError:(NSError *)error;
@end

@interface BookManager : NSObject

@property (weak, nonatomic) id<BookManagerDelegate> delegate;

- (void)fetchBookCollection;
- (void)fetchBookDetailsWithISBN:(NSString *)isbn;

@end
