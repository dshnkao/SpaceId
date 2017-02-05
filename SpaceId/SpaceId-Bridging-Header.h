//
//  t.h
//  SpaceId
//
//  Created by Dennis Kao on 5/2/17.
//  Copyright © 2017 Dennis Kao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int CGSConnectionID;
typedef int CGSSpaceID;
typedef int CGSSpaceType;

id CGSCopyManagedDisplaySpaces(int conn);
int _CGSDefaultConnection();
CGSSpaceType CGSSpaceGetType(CGSConnectionID CID, CGSSpaceID SID);
