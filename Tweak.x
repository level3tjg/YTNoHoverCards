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
- (instancetype)initWithTitle:(NSString *)title titleDescription:(NSString *)titleDescription;
@end

%hook YTSettingsViewController
- (void)setSectionItems:(NSMutableArray <YTSettingsSectionItem *>*)sectionItems forCategory:(NSInteger)category title:(NSString *)title titleDescription:(NSString *)titleDescription headerHidden:(BOOL)headerHidden {
	if (category == 1) {
		YTSettingsSectionItem *hoverCardItem = [[%c(YTSettingsSectionItem) alloc] initWithTitle:@"Hover Cards" titleDescription:nil];
		hoverCardItem.hasSwitch = YES;
		hoverCardItem.switchVisible = YES;
		hoverCardItem.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hover_cards_enabled"];
		hoverCardItem.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
			[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hover_cards_enabled"];
			return YES;
		};
		[sectionItems insertObject:hoverCardItem atIndex:3];
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