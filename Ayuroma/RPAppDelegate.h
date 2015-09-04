//
//  RPAppDelegate.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 14.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (RPAppDelegate *) sharedManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
