//
//  BookList.m
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "BookList.h"

@interface BookList ()
	@property (strong, nonatomic) NSMutableArray *collection;
	@property (nonatomic) BookSortType bookSortType;
	@property (nonatomic) BookFilterType bookFilterType;
	@property (strong, nonatomic) NSString *bookFilterText;
@end

@implementation BookList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _collection = [NSMutableArray array];
    }
    return self;
}

- (void)addBook:(Book *)book
{
	[self.collection addObject:book];
}

- (NSInteger)count
{
	return self.collection.count;
}

- (Book *)bookAtIndex:(NSInteger)index
{
	return [self.collection objectAtIndex:index];
}

- (void)setSortMethod:(BookSortType)bookSortType
{
	self.bookSortType = bookSortType;
}

- (void)setFilterMethod:(BookFilterType)BookFilterType
{
	self.bookFilterType = BookFilterType;
}

- (void)filterWithText:(NSString *)bookFilterText
{
	self.bookFilterText = bookFilterText;
}

@end
