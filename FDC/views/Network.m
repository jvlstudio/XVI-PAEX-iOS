//
//  Network.m
//  FDC
//
//  Created by Felipe Ricieri on 09/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Network.h"
#import "NetworkPIN.h"
#import "NetworkCell.h"

@interface Network ()
- (void) loadContentFromURL;
@end

@implementation Network
{
    FRTools *tools;
}

@synthesize tableData, originalData, searchData;
@synthesize table, headerView, tfSearch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNewTitle:@"Network"];
    
    tools       = [[FRTools alloc] initWithTools];
    
    originalData= [tools propertyListRead:PLIST_NETWORK];
    tableData   = [originalData mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // ..
    if (![super hasEnteredPINCode])
    {
        NetworkPIN *vc = [[NetworkPIN alloc] initWithNibName:NIB_NETWORK_PIN bundle:nil];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nv animated:NO completion:nil];
    }
    else {
        // ..
        [self loadContentFromURL];
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction) doneEditing:(id)sender
{
    [tfSearch endEditing:YES];
}

#pragma mark -
#pragma mark Methods

- (void) loadContentFromURL
{
    [self showTinyLoadView];
    //..
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // ...
        [tools downloadDataFrom:URL_NETWORK success:^{
            //...
            [self hideTinyLoadView];
            NSDictionary *returnData = [tools JSONData];
            originalData    = [returnData objectForKey:KEY_DATA];
            tableData       = [originalData mutableCopy];
            [tools propertyListWrite:originalData forFileName:PLIST_NETWORK];
            [table reloadData];
        } fail:^{
            // ..
            [self hideTinyLoadView];
            //[tools dialogWithMessage:@"Não foi possível carregar a nova versão deste conteúdo. Verifique sua conexão à internet para tentar novamente."];
        }];
    });
}

#pragma mark -
#pragma mark UITable Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict  = [tableData objectAtIndex:[indexPath row]];
    NSArray *xib        = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    NetworkCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"networkCell"];
    
    if(!cell)
        cell = (NetworkCell*)[xib objectAtIndex:kCellNetwork];
    
    // ...
    [[cell labTitle] setFont:[UIFont fontWithName:FONT_LIGHT size:16]];
    [[cell labSubtitle] setFont:[UIFont fontWithName:FONT_LIGHT size:10]];
    
    [[cell labTitle] setText:[dict objectForKey:KEY_NAME]];
    [[cell labSubtitle] setText:[dict objectForKey:KEY_COMPANY]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict  = [tableData objectAtIndex:[indexPath row]];
    // get a new new MailComposeViewController object
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
    // his class should be the delegate of the mc
    mc.mailComposeDelegate = self;
    
    // set a mail subject ... but you do not need to do this :)
    [mc setSubject:@"Network PAEX"];
    
    // set some basic plain text as the message body ... but you do not need to do this :)
    [mc setMessageBody:@"Olá," isHTML:NO];
    
    // set some recipients ... but you do not need to do this :)
    [mc setToRecipients:[NSArray arrayWithObjects:[dict objectForKey:KEY_EMAIL], nil]];
    
    // displaying our modal view controller on the screen (of course animated has to be set on YES if you want to see any transition)
    [self presentViewController:mc animated:YES completion:nil];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [tableData removeAllObjects];
    NSString *needle = [[NSString stringWithFormat:@"%@%@", [tfSearch text], string] lowercaseString];
    
    //NSLog(@"needle: %@, string: %@, text: %@", needle, string, [tfSearch text]);
    
    for (NSDictionary *info in originalData)
    {
        NSString *haystack1 = [[info objectForKey:KEY_NAME] lowercaseString];
        NSString *haystack2 = [[info objectForKey:KEY_EMAIL] lowercaseString];
        NSString *haystack3 = [[info objectForKey:KEY_COMPANY] lowercaseString];
        
        if ([haystack1 rangeOfString:needle].location != NSNotFound)
            [tableData addObject:info];
        else if ([haystack2 rangeOfString:needle].location != NSNotFound)
            [tableData addObject:info];
        else if ([haystack3 rangeOfString:needle].location != NSNotFound)
            [tableData addObject:info];
    }
    
    if ([needle isEqual:KEY_EMPTY]
    ||  ([string isEqualToString:KEY_EMPTY] && [needle length] < 2)
    ||  [string isEqualToString:@"\n"])
        tableData = [originalData mutableCopy];
    
    [table reloadData];
    
    return YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [tfSearch endEditing:YES];
}

#pragma mark -
#pragma mark MFMailComposeViewController

// delegate function callback
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    // switchng the result
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled.");
            /*
             Execute your code for canceled event here ...
             */
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved.");
            /*
             Execute your code for email saved event here ...
             */
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
            /*
             Execute your code for email sent event here ...
             */
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            /*
             Execute your code for email send failed event here ...
             */
            break;
        default:
            break;
    }
    // hide the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
