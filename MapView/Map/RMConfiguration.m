//
//  RMConfiguration.m
//
// Copyright (c) 2008-2012, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "RMConfiguration.h"

static RMConfiguration *RMConfigurationSharedInstance = nil;

@implementation RMConfiguration
{
    id _propertyList;
}

+ (RMConfiguration *)configuration
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RMConfigurationSharedInstance = [[RMConfiguration alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"routeme" ofType:@"plist"]];
    });

    return RMConfigurationSharedInstance;
}

- (RMConfiguration *)initWithPath:(NSString *)path
{
    if (!(self = [super init]))
        return nil;

    if (path == nil)
    {
        _propertyList = nil;
        return self;
    }

    RMLog(@"reading route-me configuration from %@", path);

    NSString *error = nil;
    NSData *plistData = [NSData dataWithContentsOfFile:path];

    _propertyList = [[NSPropertyListSerialization propertyListFromData:plistData
                                                      mutabilityOption:NSPropertyListImmutable
                                                                format:NULL
                                                      errorDescription:&error] retain];

    if ( ! _propertyList)
    {
        RMLog(@"problem reading route-me configuration from %@: %@", path, error);
        [error release];
    }

    return self;
}

- (void)dealloc
{
    [_propertyList release]; _propertyList = nil;
    [super dealloc];
}

- (NSDictionary *)cacheConfiguration
{
    if (_propertyList == nil)
        return nil;

    return [_propertyList objectForKey:@"caches"];
}

@end
