#import <Preferences/Preferences.h>

#import <AppSupport/AppSupport.h>
#import "admob/GADBannerView.h"
#import <objc/runtime.h>
#define SETTINGS_PATH @"/var/mobile/Library/Preferences/com.fr0zensun.switcherloader.plist"
#define PLUGIN_PATH @"/Library/SwitcherLoader/Plugins"


@interface NSMutableArray (Extras)
@end
@implementation NSMutableArray (Extras)

- (void)moveObjectFromIndex:(NSUInteger)origIndex toIndex:(NSUInteger)newIndex
{
    if (newIndex != origIndex) {
        id object = [self objectAtIndex:origIndex];
        [object retain];
        [self removeObjectAtIndex:origIndex];
        if (newIndex >= [self count]) {
            [self addObject:object];
        } else {
            [self insertObject:object atIndex:newIndex];
        }
        [object release];
    }
}
@end

@interface SwitcherLoaderSettingsListController: PSListController {
    NSMutableArray *enabledPlugins;
    NSMutableArray *disabledPlugins;
    CPDistributedMessagingCenter *messagingCenter;
    GADBannerView *adView;


}
-(void)openPayPal:(id)arg1;
-(void)openTwitter:(id)arg1;
-(NSMutableArray *)enabledPlugins;
-(NSMutableArray *)disabledPlugins;
-(NSString *)nameForBundle_id:(NSString *)bundle_id;
-(NSString *)pathForImage:(NSString *)bundle_id;

@end

@implementation SwitcherLoaderSettingsListController
-(id)init {
    if((self = [super init])) {
        messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.fr0zensun.switcherloader.message.center"];
        [messagingCenter sendMessageName:@"LoadPlugins" userInfo:nil];
        
        NSDictionary *plugins = [messagingCenter sendMessageAndReceiveReplyName:@"Plugins" userInfo:nil/* optional dictionary */];
        enabledPlugins = [[NSMutableArray alloc]initWithArray:[plugins objectForKey:@"EnabledPlugins"]];
        disabledPlugins = [[NSMutableArray alloc]initWithArray:[plugins objectForKey:@"DisabledPlugins"]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _table.editing = YES;
    _table.allowsSelectionDuringEditing = YES;


   // _table.allowsSelection = NO;
   
   
    adView = [[GADBannerView alloc]initWithFrame:CGRectMake(0.0,0,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];

    adView.adUnitID = @"a14ee148032c6f2";
    _table.scrollsToTop = YES;
    adView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    
    [adView loadRequest:request];
    _table.tableFooterView = adView;

    
}
-(void)viewDidUnload {
    [adView release];
    [super viewDidUnload];

    
}
- (id)specifiers {
	if(_specifiers == nil) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:_specifiers];
        PSSpecifier *enabledHeader = [PSSpecifier preferenceSpecifierNamed:@"Enabled Plugins" target:self set:NULL get:NULL detail:Nil cell:0 edit:Nil];
        [array addObject:enabledHeader];
       

        for(unsigned int i = 0; i <[[self enabledPlugins]count]; i++) {
            PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:[self nameForBundle_id:[[self enabledPlugins]objectAtIndex:i]] target:self set:NULL get:NULL detail:Nil cell:4 edit:Nil];
            [specifier setProperty:[UIImage imageWithContentsOfFile:[self pathForImage:[[self enabledPlugins]objectAtIndex:i]]] forKey:@"iconImage"];            
        [array addObject:specifier];
            
        }
        PSSpecifier *disabledHeader = [PSSpecifier preferenceSpecifierNamed:@"Disabled Plugins" target:self set:NULL get:NULL detail:Nil cell:0 edit:Nil];
        [array addObject:disabledHeader];
        for(unsigned int i = 0; i <[[self disabledPlugins]count]; i++) {
            PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:[self nameForBundle_id:[[self disabledPlugins]objectAtIndex:i]] target:self set:NULL get:NULL detail:Nil cell:4 edit:Nil];
            [specifier setProperty:[UIImage imageWithContentsOfFile:[self pathForImage:[[self disabledPlugins]objectAtIndex:i]]] forKey:@"iconImage"];            

            [array addObject:specifier];
            
        }
   
        [array addObjectsFromArray:[self loadSpecifiersFromPlistName:@"SwitcherLoaderSettings" target:self]];
        [_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:array];
        
      
	}
   
 
	return _specifiers;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section < 2)
        return YES;
    else return NO;
    
}


-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath         
{
  if(indexPath.section < 2)
      return YES;
    else return NO;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableDictionary *dict;
    dict = [[NSMutableDictionary alloc]initWithContentsOfFile:SETTINGS_PATH];
    if(!dict) {
          dict = [[NSMutableDictionary alloc]init];
    }
    
    if(fromIndexPath.section == 1 && toIndexPath.section == 1) {
        [disabledPlugins moveObjectFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
        
    }
    else if(fromIndexPath.section == 0 && toIndexPath.section == 1) {
       
        [[self disabledPlugins]insertObject:[[self enabledPlugins]objectAtIndex:fromIndexPath.row] atIndex:toIndexPath.row];

        [[self enabledPlugins]removeObjectAtIndex:fromIndexPath.row];
      
        
    }
    else if (toIndexPath.section == 0 && fromIndexPath.section == 1) {
       
        [[self enabledPlugins]insertObject:[[self disabledPlugins]objectAtIndex:fromIndexPath.row] atIndex:toIndexPath.row];
        [[self disabledPlugins]removeObjectAtIndex:fromIndexPath.row];
      
    }
    else if(toIndexPath.section == 0 && fromIndexPath.section == 0) {
        [enabledPlugins moveObjectFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
        
    }
 
    NSMutableDictionary *indexDict = [NSMutableDictionary dictionary];
    [indexDict setObject:[self enabledPlugins] forKey:@"Enabled"];
    [indexDict setObject:[self disabledPlugins] forKey:@"Disabled"];
    [dict setObject:indexDict forKey:@"Plugins"];
    [dict writeToFile:SETTINGS_PATH atomically:YES];
    [dict release]; 
    [messagingCenter sendMessageName:@"Update" userInfo:nil];

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return UITableViewCellEditingStyleNone;
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    
    if (proposedDestinationIndexPath.section < 2) {
        return proposedDestinationIndexPath;
        
    }
    else return sourceIndexPath;
}
- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
-(NSMutableArray *)enabledPlugins {
    
    return enabledPlugins;
}
-(NSMutableArray *)disabledPlugins {
    
    return disabledPlugins;
}
-(NSString *)nameForBundle_id:(NSString *)bundle_id {
    if([bundle_id isEqualToString:@"springboard.sbnowplayingbarview"])
        return @"SBNowPlayingBarView";
    else if([bundle_id isEqualToString:@"springboard.sbairplaybarview"])
             return @"SBAirPlayView";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:PLUGIN_PATH error:nil];
    
    for(unsigned int i = 0; i < [dirContents count]; i++) {
        NSString *path = [PLUGIN_PATH stringByAppendingPathComponent:[dirContents objectAtIndex:i]];
        
        if([[path pathExtension]isEqualToString:@"bundle"]) {
            NSBundle *bundle = [NSBundle bundleWithPath:path];
            
            if([bundle_id isEqualToString:[bundle bundleIdentifier]]) 
                return [bundle objectForInfoDictionaryKey:@"name"];
            
        }
    }
    return bundle_id;
    
}

-(void)openTwitter:(id)arg1 {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://twitter.com/fr0zensun"]];
    
}
-(void)openPayPal:(id)arg1 {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=ZSKQ3PSALM7NS&lc=US&item_name=Ryan%20Coffman&item_number=switcher_loader&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"]];
    
}
-(void)openDocs {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://github.com/Fr0zenSun/SwitcherLoader"]];

    
}
-(NSString *)pathForImage:(NSString *)bundle_id {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:PLUGIN_PATH error:nil];
    
    for(unsigned int i = 0; i < [dirContents count]; i++) {
        NSString *path = [PLUGIN_PATH stringByAppendingPathComponent:[dirContents objectAtIndex:i]];
        
        if([[path pathExtension]isEqualToString:@"bundle"]) {
            NSBundle *bundle = [NSBundle bundleWithPath:path];
            
            if([bundle_id isEqualToString:[bundle bundleIdentifier]]) {
               NSString *iconName =  [bundle objectForInfoDictionaryKey:@"icon"];
                 if(iconName && [bundle pathForResource:[iconName stringByDeletingPathExtension] ofType:[iconName pathExtension]])
                     return [bundle pathForResource:[iconName stringByDeletingPathExtension] ofType:[iconName pathExtension]];

            }
            
        }
    }
    return @"/Library/PreferenceBundles/SwitcherLoaderSettings.bundle/SLIcon.png";
    
}
-(void)dealloc {
    [enabledPlugins release];
    [disabledPlugins release];
      [super dealloc];
    
}
@end

// vim:ft=objc
