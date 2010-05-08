//
//  FileManagerOperation.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/24/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "FileManagerOperation.h"
#import "FileManager.h"
#import "MyKeePassAppDelegate.h"

@implementation FileManagerOperation

@synthesize _filename;
@synthesize _password;
@synthesize _username;
@synthesize _userpass;
@synthesize _domain;
@synthesize _useCache;
@synthesize _delegate;

-(id)initWithDelegate:(id<FileManagerOperationDelegate>)delegate{
	if(self=[super init]){
		self._delegate = delegate;
	}
	return self;
}

-(void)dealloc{
	[_delegate release];
	[_filename release];
	[_password release];
	[_username release];
	[_userpass release];
	[_domain release];	
	[super dealloc];
}

-(void)openLocalFile{
	NSAutoreleasePool * pool = nil;
	@try{
		pool = [[NSAutoreleasePool alloc] init];
		[[MyKeePassAppDelegate delegate]._fileManager readFile:_filename withPassword:_password];
		[_delegate performSelectorOnMainThread:@selector(fileOperationSuccess) withObject:nil waitUntilDone:NO];
	}@catch(NSException * exception){
		[_delegate performSelectorOnMainThread:@selector(fileOperationFailureWithException:) withObject:exception waitUntilDone:NO];
	}@finally {
		[pool drain];
		[pool release];
	}
}

-(void)openRemoteFile{
	NSAutoreleasePool * pool = nil;	
	@try{
		pool = [[NSAutoreleasePool alloc] init];		
		[[MyKeePassAppDelegate delegate]._fileManager readRemoteFile:_filename withPassword:_password useCached:_useCache username:_username userpass:_userpass domain:_domain];
		[_delegate performSelectorOnMainThread:@selector(fileOperationSuccess) withObject:nil waitUntilDone:NO];
	}@catch(NSException * exception){
		[_delegate performSelectorOnMainThread:@selector(fileOperationFailureWithException:) withObject:exception waitUntilDone:NO];
	}@finally {
		[pool drain];
		[pool release];
	}
	
}

-(void)save{
	NSAutoreleasePool * pool = nil;
	@try{
		pool = [[NSAutoreleasePool alloc] init];
		[[MyKeePassAppDelegate delegate]._fileManager save];
		[_delegate performSelectorOnMainThread:@selector(fileOperationSuccess) withObject:nil waitUntilDone:NO];
	}@catch(NSException * exception){
		[_delegate performSelectorOnMainThread:@selector(fileOperationFailureWithException:) withObject:exception waitUntilDone:NO];
	}@finally {
		[pool drain];
		[pool release];
	}	
}

@end
