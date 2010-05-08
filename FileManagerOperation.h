//
//  FileManagerOperation.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/24/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * a help class to make open/save KDB file in the background easier
 */
 
@protocol FileManagerOperationDelegate <NSObject>
-(void)fileOperationSuccess;
-(void)fileOperationFailureWithException:(NSException *)exception;
@end

@interface FileManagerOperation : NSOperation {
	NSObject<FileManagerOperationDelegate> * _delegate;
	
	NSString * _filename;
	NSString * _password;
	NSString * _username;
	NSString * _userpass;
	NSString * _domain;
	
	BOOL _useCache;
}

@property(nonatomic, retain) NSObject<FileManagerOperationDelegate> * _delegate;
@property(nonatomic, retain) NSString * _filename;
@property(nonatomic, retain) NSString * _password;
@property(nonatomic, retain) NSString * _username;
@property(nonatomic, retain) NSString * _userpass;
@property(nonatomic, retain) NSString * _domain;
@property(nonatomic, assign) BOOL _useCache;

-(id)initWithDelegate:(id<FileManagerOperationDelegate>)delegate;

-(void)openLocalFile;
-(void)openRemoteFile;
-(void)save;

@end
