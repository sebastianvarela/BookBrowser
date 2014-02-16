//
//  BookList.h
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

typedef NS_ENUM(NSInteger, BookSortType) {
	BookSortTypeISBN,
	BookSortTypeTitle
};

typedef NS_ENUM(NSInteger, BookFilterType) {
	BookFilterTypeAll,
	BookFilterTypeNormal,
	BookFilterTypePremium
};

@interface BookList : NSObject

- (void)addBook:(Book *)book;
- (NSInteger)count;
- (Book *)bookAtIndex:(NSInteger)index;
- (void)setSortMethod:(BookSortType)bookSortType;
- (void)setFilterMethod:(BookFilterType)BookFilterType;
- (void)filterWithText:(NSString *)bookFilterText;

@end
