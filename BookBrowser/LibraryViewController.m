//
//  LibraryViewController.m
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "LibraryViewController.h"
#import "BookCell.h"
#import "LibraryHeader.h"

@interface LibraryViewController () <BookManagerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) BookManager *bookManager;
@property (strong, nonatomic) BookList *bookList;

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
	
	self.title = NSLocalizedString(@"Biblioteca", nil);
	self.bookManager = [BookManager new];
	self.bookList = [BookList new];
	self.bookManager.delegate = self;
}

#pragma mark - Book Manager Delegate

- (void)bookManagerDidReceivedBookCollectionFromServer:(BookList *)bookCollection
{
	self.bookList = bookCollection;
	[self.collectionView reloadData];
}

- (void)bookManagerDidFailReceivingDataFromServerWithError:(NSError *)error
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Aceptar", nil), nil];
	[alert show];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.bookList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	BookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoverCellIdentifier" forIndexPath:indexPath];
	Book *book = [self.bookList bookAtIndex:indexPath.row];
	
	[cell setCoverImage:[UIImage new]];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSURL *url = [NSURL URLWithString:book.coverUrl];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *coverImage = [UIImage imageWithData:data];
		[cell setCoverImage:coverImage];
	});
	
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader])
	{
        LibraryHeader *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
		
		reusableview.bookSearchBar.delegate = self;
		
        return reusableview;
    }
    
	return nil;
}

#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
}

@end
