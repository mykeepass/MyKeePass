//
//  Sort.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/22/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <Kdb.h>

NSInteger entrySort(id<KdbEntry> e1, id<KdbEntry> e2, void *context){
	return [[e1 getEntryName] caseInsensitiveCompare:[e2 getEntryName]];
}

NSInteger groupSort(id<KdbGroup> g1, id<KdbGroup> g2, void *context){
	return [[g1 getGroupName] caseInsensitiveCompare:[g2 getGroupName]];
}