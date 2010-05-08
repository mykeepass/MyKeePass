//
//  Sort.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/22/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <Kdb.h>

NSInteger entrySort(id<KdbEntry> e1, id<KdbEntry> e2, void *context);
NSInteger groupSort(id<KdbGroup> g1, id<KdbGroup> g2, void *context);

