//
//  BookList.m
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "BookList.h"

@interface BookList ()
	@property (strong, nonatomic) NSMutableSet *sourceCollection;
	@property (strong, nonatomic) NSArray *filteredCollection;
	@property (nonatomic) BookSortType bookSortType;
	@property (nonatomic) BookFilterType bookFilterType;
	@property (strong, nonatomic) NSString *bookFilterText;
@end

@implementation BookList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sourceCollection = [NSMutableSet set];
		_filteredCollection = [NSArray array];
		_bookSortType = BookSortTypeTitle;
		_bookFilterType = BookFilterTypeAll;
		_bookFilterText = @"";
    }
    return self;
}

- (void)addBook:(Book *)book
{
	if ([self.sourceCollection containsObject:book])
		return;
	[self.sourceCollection addObject:book];
	[self reorderBooks];
}

- (NSInteger)count
{
	return self.filteredCollection.count;
}

- (Book *)bookAtIndex:(NSInteger)index
{
	return [self.filteredCollection objectAtIndex:index];
}

- (void)setSortMethod:(BookSortType)bookSortType
{
	self.bookSortType = bookSortType;
	[self reorderBooks];
}

- (void)setFilterMethod:(BookFilterType)BookFilterType
{
	self.bookFilterType = BookFilterType;
	[self reorderBooks];
}

- (void)filterWithText:(NSString *)bookFilterText
{
	self.bookFilterText = bookFilterText;
	[self reorderBooks];
}

- (void)reorderBooks
{
	NSSortDescriptor *sortDescriptor;
	switch (self.bookSortType)
	{
		case BookSortTypeISBN:
			sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"isbn" ascending:YES];
			break;
			
		default:
		case BookSortTypeTitle:
			sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
			break;
	}
	self.filteredCollection = [[self.sourceCollection allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];
	
	NSPredicate *filterPredicate;
	switch (self.bookFilterType)
	{
		case BookFilterTypeNormal:
			filterPredicate = [NSPredicate predicateWithFormat:@"isPremium = NO"];
			break;
			
		case BookFilterTypePremium:
			filterPredicate = [NSPredicate predicateWithFormat:@"isPremium = YES"];
			break;
			
		default:
		case BookFilterTypeAll:
			break;
	}
	if (filterPredicate)
		self.filteredCollection = [self.filteredCollection filteredArrayUsingPredicate:filterPredicate];

	if (![self.bookFilterText isEqualToString:@""])
	{
		NSPredicate *filterTextPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@" argumentArray:@[self.bookFilterText]];
		self.filteredCollection = [self.filteredCollection filteredArrayUsingPredicate:filterTextPredicate];
	}
}

@end
