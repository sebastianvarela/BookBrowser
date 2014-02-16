//
//  Book.m
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "Book.h"

@implementation Book

- (BOOL)isEqual:(id)other
{
	if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
	return [self isEqualToBook:(Book *)other];
}

- (BOOL)isEqualToBook:(Book *)book {
	if (!book) {
		return NO;
	}

	return (!self.isbn && !book.isbn) || [self.isbn isEqualToString:book.isbn];
}

- (NSUInteger)hash {
	return [self.isbn hash];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ - %@", self.isbn, self.title];
}

@end
