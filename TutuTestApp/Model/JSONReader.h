//
//  JSONReader.h
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONReader : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)citiesFromJSON:(NSString *)direction;

@end
