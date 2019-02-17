//
//  Audio.h
//  gmj
//
//  Created by Jessica Au  on 2/16/19.
//  Copyright © 2019 Gustavo  Coutinho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Audio : NSObject

@property (nonatomic, strong) NSString *textToString;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSMutableArray *tags;

@end

NS_ASSUME_NONNULL_END
