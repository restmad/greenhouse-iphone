//
//  Copyright 2010-2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  Profile.h
//  Greenhouse
//
//  Created by Roy Clarkson on 6/11/10.
//

#import <Foundation/Foundation.h>
#import "WebDataModel.h"


@interface Profile : NSObject <WebDataModel>

@property (nonatomic, assign) NSUInteger accountId;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, strong) NSURL *imageUrl;

+ (Profile *)profileWithDictionary:(NSDictionary *)dictionary;

@end
