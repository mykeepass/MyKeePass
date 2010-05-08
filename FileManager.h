//
//  FileManager.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/3/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KdbLib.h>

#define KDB_VERSION1 1
#define KDB_VERSION2 2

@interface FileManager : NSObject {
	//e.g. test.kdb; directory information is not included;
	//if it is a remote file remote<->http://www.exaple.com, _filename=remote
	NSString * _filename;
	NSString * _password;
	BOOL _dirty;
	
	id<KdbReader> _kdbReader;
	BOOL _editable;
	
	NSMutableDictionary * _remoteFiles;
}

@property(nonatomic, retain) id<KdbReader> _kdbReader;
@property(nonatomic, readonly) BOOL _editable;
@property(nonatomic, retain) NSString * _filename;
@property(nonatomic, retain) NSString * _password;
@property(nonatomic, assign) BOOL _dirty;
@property(nonatomic, retain) NSMutableDictionary * _remoteFiles;

-(void)getKDBFiles:(NSMutableArray *)list;
-(id<KdbTree>) readFile:(NSString *) fileName withPassword:(NSString *)password;
-(id<KdbTree>) readRemoteFile:(NSString *)filename withPassword:(NSString *)password useCached:(BOOL)useCached username:(NSString *)username userpass:(NSString *)userpass domain:(NSString *)domain;

-(void)deleteLocalFile:(NSString *)filename;


//get the KDB version of the current opened file
-(NSUInteger) getKDBVersion;

//manage remote files
-(void)getRemoteFiles:(NSMutableArray *)list;
-(void)addRemoteFile:(NSString *)name Url:(NSString *)url;
-(void)deleteRemoteFile:(NSString *)name;
-(NSString *)getURLForRemoteFile:(NSString *)name;

-(void)save;

//
+(void)newKdb3File:(NSString *)filename withPassword:(NSString *)password;
+(NSString *)getTempFileNameFromURL:(NSString *)url;
+(NSString *)getFullFileName:(NSString *)filename;

+(NSString *)dataDir;
@end
