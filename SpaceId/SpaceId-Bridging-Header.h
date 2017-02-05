#import <Foundation/Foundation.h>

typedef int CGSConnectionID;
typedef int CGSSpaceID;
typedef int CGSSpaceType;

id CGSCopyManagedDisplaySpaces(int conn);
int _CGSDefaultConnection();
CGSSpaceType CGSSpaceGetType(CGSConnectionID CID, CGSSpaceID SID);
