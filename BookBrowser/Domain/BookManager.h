//
//  BookManager.h
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookList.h"

@protocol BookManagerDelegate <NSObject>
- (void)bookManagerDidReceivedBookCollectionFromServer:(BookList *)bookCollection;
@optional
- (void)bookManagerDidFailReceivingDataFromServer;
@end

@interface BookManager : NSObject

@property (weak, nonatomic) id<BookManagerDelegate> delegate;

@end
