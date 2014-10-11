//
//  JTDetailViewController.h
//  Jewish Times
//
//  Created by Rockstar. on 8/5/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTViewController.h"
#import "JTCollection.h"
#import "JTCollectionViewController.h"

@interface JTDetailViewController : JTViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    
    long long expectedLength;
	long long currentLength;
    IBOutlet UIScrollView *scroller;
}

@property (nonatomic, strong) IBOutlet UIImageView *videoImage;
@property (nonatomic, strong) IBOutlet UITextView *detailText;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *viewButton;
@property (nonatomic, strong) JTCollection *schema;
@property (strong, nonatomic) NSString *urlString;
@property (nonatomic, strong) NSString *textString;

- (IBAction)viewVideo:(id)sender;
- (IBAction)openActionSheet:(id)sender;

@end
