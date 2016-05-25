//
//  InboxTableViewController.m
//  app
//
//  Created by Aernout Peeters on 03-05-2016.
//  Copyright © 2016 Notificare. All rights reserved.
//

#import "InboxViewController.h"
#import "NotificarePushLib.h"
#import "IIViewDeckController.h"
#import "BadgeLabel.h"

@interface InboxViewController ()

@property (nonatomic, strong) UILabel * emptyMessage;
@property (nonatomic, strong) UIView * loadingView;

@property (nonatomic, strong) IBOutlet UIView * badge;
@property (nonatomic, strong) IBOutlet BadgeLabel * badgeNr;
@property (nonatomic, strong) IBOutlet UIButton * badgeButton;
@property (nonatomic, strong) IBOutlet UIImageView * buttonIcon;

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [title setText:LSSTRING(@"menu_item_inbox")];
    [title setFont:LATO_LIGHT_FONT(20)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:ICONS_COLOR];
    [[self navigationItem] setTitleView:title];
    
    [self createEmptyView];
    
    [self setupNavigationBar];
    [self setupEmptyView];
    
    [[[self navigationController] navigationBar] setBarTintColor:MAIN_COLOR];
    
    [self setCellMessageLabelFont:LATO_LIGHT_FONT(14)];
    [self setCellTimeAgoLabelFont:LATO_LIGHT_FONT(11)];
}

-(void)createEmptyView{
    [self setLoadingView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    
    [self setEmptyMessage:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    
    [[self emptyMessage] setText:LSSTRING(@"empty_inbox_text")];
    [[self emptyMessage] setFont:LATO_LIGHT_FONT(14)];
    [[self emptyMessage] setTextAlignment:NSTextAlignmentCenter];
    [[self loadingView] setBackgroundColor:[UIColor whiteColor]];
    [[self loadingView] addSubview:[self emptyMessage]];
}

- (void)setupNavigationBar {
    
    int count = [[NotificarePushLib shared] myBadge];
    
    if([[[self notificareInboxManager] managedInboxItems] count] > 0){
        
        if(count > 0){
            
            [[self buttonIcon] setTintColor:ICONS_COLOR];
            [[self badgeButton] addTarget:[self viewDeckController] action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
            
            NSString * badge = [NSString stringWithFormat:@"%i", count];
            [[self badgeNr] setText:badge];
            
            UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:[self badge]];
            [leftButton setTarget:[self viewDeckController]];
            [leftButton setAction:@selector(toggleLeftView)];
            [leftButton setTintColor:ICONS_COLOR];
            [[self navigationItem] setLeftBarButtonItem:leftButton];
            
            
        } else {
            UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleLeftView)];
            [leftButton setTintColor:ICONS_COLOR];
            [[self navigationItem] setLeftBarButtonItem:leftButton];
        }
        
        [[self navigationItem] setRightBarButtonItem:self.editButtonItem];
        [[self editButtonItem] setTintColor:ICONS_COLOR];
        
    } else {
        
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenuIcon"] style:UIBarButtonItemStylePlain target:[self viewDeckController] action:@selector(toggleLeftView)];
        [leftButton setTintColor:ICONS_COLOR];
        [[self navigationItem] setLeftBarButtonItem:leftButton];
        
        
        [[self navigationItem] setRightBarButtonItem:nil];
    }
}

- (void)setupEmptyView {
    if ([[[self notificareInboxManager] managedInboxItems] count] > 0) {
        [[self loadingView] removeFromSuperview];
    }
    else {
        [[self view] addSubview:[self loadingView]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:[self notificareInboxManager]
                                             selector:@selector(updateInbox)
                                                 name:@"receivedRemoteNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupNavigationBar)
                                                 name:@"incomingNotification"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"receivedRemoteNotification"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:[self notificareInboxManager]
                                                    name:@"incomingNotification"
                                                  object:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    [[self tableView] setEditing:editing animated:animated];
    
    if (editing) {
        
        UIBarButtonItem * clearButton = [[UIBarButtonItem alloc] initWithTitle:LSSTRING(@"clear_all")
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:[self notificareInboxManager]
                                                                        action:@selector(clearInbox)];
        [[self navigationItem] setLeftBarButtonItem:clearButton];
        [clearButton setTintColor:ICONS_COLOR];
        
    }
    else {
        
        [self setupNavigationBar];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return INBOX_CELLHEIGHT;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}



#pragma mark - NotificareInboxManagerDelegate overrides

- (void)didUpdateInbox:(NotificareInboxManager *)notificareInboxManager {
    
    [super didUpdateInbox:notificareInboxManager];
    
    [self setupNavigationBar];
    [self setupEmptyView];
}

- (void)didReloadInbox:(NotificareInboxManager *)notificareInboxManager {
    
    [super didReloadInbox:notificareInboxManager];
    
    [self setupNavigationBar];
    [self setupEmptyView];
}

- (void)notificareInboxManager:(NotificareInboxManager *)notificareInboxManager didOpenInboxItem:(NotificareManagedDeviceInbox *)managedInboxItem {
    
    [super notificareInboxManager:notificareInboxManager didOpenInboxItem:managedInboxItem];
    
    [self setupNavigationBar];
    [self setupEmptyView];
}

- (void)notificareInboxManager:(NotificareInboxManager *)notificareInboxManager didRemoveFromInbox:(NotificareManagedDeviceInbox *)managedInboxItem {
    
    [super notificareInboxManager:notificareInboxManager didRemoveFromInbox:managedInboxItem];
    
    [self setupNavigationBar];
    [self setupEmptyView];
}

- (void)notificareInboxManager:(NotificareInboxManager *)notificareInboxManager didRemoveFromInbox:(NotificareManagedDeviceInbox *)managedInboxItem forIndexPath:(NSIndexPath *)indexPath {
    
    [super notificareInboxManager:notificareInboxManager didRemoveFromInbox:managedInboxItem forIndexPath:indexPath];
    
    [self setupNavigationBar];
    [self setupEmptyView];
}

- (void)didClearInbox:notificareInboxManager {
    
    [super didClearInbox:notificareInboxManager];
    
    [self setupNavigationBar];
    [self setupEmptyView];
}

@end
