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
#import "DetailsViewController.h"

@interface LibraryViewController () <BookManagerDelegate, UISearchBarDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) BookManager *bookManager;
@property (strong, nonatomic) BookList *bookList;
@property (weak, nonatomic) UISearchBar *bookSearchBar;
@property (strong, nonatomic) UIActionSheet *orderActionSheet;
@property (strong, nonatomic) UIActionSheet *filterActionSheet;

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
	self.navigationItem.leftBarButtonItem.title = NSLocalizedString(@"Ordenar", nil);
	self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Filtrar", nil);
	self.bookList = [BookList new];

	self.bookManager = [BookManager new];
	self.bookManager.delegate = self;
	[self.bookManager fetchBookCollection];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (IBAction)orderButtonTouch:(id)sender
{
	[self hideKeyboardOnBookSearchBar];
	
	//Las opciones del filter action corresponden a las disponibles en BookSortType
	self.orderActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Ordenar", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ISBN", nil), NSLocalizedString(@"Título", nil), nil];
	[self.orderActionSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)filterButtonTouch:(id)sender
{
	[self hideKeyboardOnBookSearchBar];

	//Las opciones del filter action corresponden a las disponibles en BookFilterType
	self.filterActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Filtrar", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Todos los libros", nil), NSLocalizedString(@"Libros normales", nil), NSLocalizedString(@"Libros premiums", nil), nil];
	[self.filterActionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self hideKeyboardOnBookSearchBar];
}

#pragma mark - Book Manager Delegate

- (void)bookManagerDidReceivedBookCollection:(BookList *)bookCollection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.bookList = bookCollection;
	[self.collectionView reloadData];
}

- (void)bookManagerDidFailReceivingDataFromServerWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		NSURL *url = [NSURL URLWithString:book.coverUrl];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *coverImage = [UIImage imageWithData:data];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[cell setCoverImage:coverImage];
		});
	});
	
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader])
	{
        LibraryHeader *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
		
		reusableview.bookSearchBar.delegate = self;
		self.bookSearchBar = reusableview.bookSearchBar;
		
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
	[self hideKeyboardOnBookSearchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self.bookList filterWithText:searchText];
	[self.collectionView reloadData];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex)
		return;

	if ([actionSheet isEqual:self.orderActionSheet])
	{
		[self.bookList setSortMethod:(BookSortType)buttonIndex];
		[self.collectionView reloadData];
	}
	else if ([actionSheet isEqual:self.filterActionSheet])
	{
		[self.bookList setFilterMethod:(BookFilterType)buttonIndex];
		[self.collectionView reloadData];
	}
}

#pragma mark - Custom Methods

- (void)hideKeyboardOnBookSearchBar
{
	[self.bookSearchBar setShowsCancelButton:NO animated:YES];
	[self.bookSearchBar resignFirstResponder];
}

#pragma mark - StoryBoard Messages

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *bookIndex = [self.collectionView.indexPathsForSelectedItems objectAtIndex:0];
	Book *book = [self.bookList bookAtIndex:bookIndex.row];
	
	DetailsViewController *details = segue.destinationViewController;
	details.book = book;
}

@end
