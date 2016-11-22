//
//  AppDelegate.m
//  SpotLightDemo
//
//  Created by 彭彭 耿 on 22/11/2016.
//  Copyright © 2016 China M-World Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
#endif

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ViewController.h"

@interface AppDelegate ()
{
    ViewController *rootVC;
}
@end

@implementation AppDelegate

- (void)setSpotlight{
    /*应用内搜索，想搜索到多少个界面就要创建多少个set ，每个set都要对应一个item*/
    CSSearchableItemAttributeSet *firstSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"firstSet"];
    //标题
    firstSet.title = @"测试firstView";
    //详细描述
    firstSet.contentDescription = @"测试firstView哈哈哈哈哈哈哈";
    //关键字，
    NSArray *firstSeachKey = [NSArray arrayWithObjects:@"first",@"测试",@"firstView", nil];
    firstSet.contactKeywords = firstSeachKey;
    
    CSSearchableItemAttributeSet *secondSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"secondSet"];
    secondSet.title = @"测试SecondView";
    secondSet.contentDescription = @"测试secondView哈哈哈哈哈哈哈哈";
    NSArray *secondArrayKey = [NSArray arrayWithObjects:@"second",@"测试",@"secondeVIew", nil];
    secondSet.contactKeywords = secondArrayKey;
    
    //UniqueIdentifier每个搜索都有一个唯一标示，当用户点击搜索到得某个内容的时候，系统会调用代理方法，会将这个唯一标示传给你，以便让你确定是点击了哪一，方便做页面跳转
    //domainIdentifier搜索域标识，删除条目的时候调用的delegate会传过来这个值
    CSSearchableItem *firstItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"firstItem" domainIdentifier:@"first" attributeSet:firstSet];
    CSSearchableItem *secondItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"secondItem" domainIdentifier:@"second" attributeSet:secondSet];
    NSArray *itemArray = [NSArray arrayWithObjects:firstItem,secondItem, nil];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:itemArray completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"设置失败%@",error);
        }else{
            NSLog(@"设置成功");
        }
    }];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    NSString *idetifier  = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
    NSLog(@"%@",idetifier);
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    if ([idetifier isEqualToString:@"firstItem"]) {
        FirstViewController *fistVc = [[FirstViewController alloc] init];
        [nav pushViewController:fistVc animated:YES];
    }else if ([idetifier isEqualToString:@"secondItem"]){
        SecondViewController *secondVc = [[SecondViewController alloc] init];
        [nav pushViewController:secondVc animated:YES];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    rootVC = [[ViewController alloc] init];
    UINavigationController *navRootVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    _window.rootViewController = navRootVC;
    [_window makeKeyAndVisible];
    
    
    //spotLight
    [self setSpotlight];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"SpotLightDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
