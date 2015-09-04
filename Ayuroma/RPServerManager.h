//
//  RPServerManager.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 15.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPServerManager : NSObject

+ (RPServerManager *) sharedManager;

- (void) getToken:(void (^)(NSString *token)) result;

@end
