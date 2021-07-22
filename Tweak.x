#import <UIKit/UIKit.h>

@interface YTCollectionViewCell : UICollectionViewCell
@end

@interface YTSettingsCell : YTCollectionViewCell
@end

@interface YTSettingsSectionItem : NSObject
@property BOOL hasSwitch;
@property BOOL switchVisible;
@property BOOL on;
@property BOOL (^switchBlock)(YTSettingsCell *, BOOL);
@property int settingItemId;
- (instancetype)initWithTitle:(NSString *)title titleDescription:(NSString *)titleDescription;
@end

%hook YTSettingsViewController
- (void)setSectionItems:(NSMutableArray <YTSettingsSectionItem *>*)sectionItems forCategory:(NSInteger)category title:(NSString *)title titleDescription:(NSString *)titleDescription headerHidden:(BOOL)headerHidden {
	if (category == 1) {
		NSInteger appropriateIdx = [sectionItems indexOfObjectPassingTest:^BOOL(YTSettingsSectionItem *item, NSUInteger idx, BOOL *stop) {
			return item.settingItemId == 294;
		}];
		if (appropriateIdx != NSNotFound) {
			YTSettingsSectionItem *hoverCardItem = [[%c(YTSettingsSectionItem) alloc] initWithTitle:@"Show endscreen hover cards" titleDescription:@"Allows creator endscreens to appear at the end of videos"];
			hoverCardItem.hasSwitch = YES;
			hoverCardItem.switchVisible = YES;
			hoverCardItem.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hover_cards_enabled"];
			hoverCardItem.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
				[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hover_cards_enabled"];
				return YES;
			};
			[sectionItems insertObject:hoverCardItem atIndex:appropriateIdx + 1];
		}
	}
	%orig;
}
%end

%hook YTCreatorEndscreenView
- (void)setHidden:(BOOL)hidden {
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hover_cards_enabled"])
		hidden = YES;
	%orig;
}
%end