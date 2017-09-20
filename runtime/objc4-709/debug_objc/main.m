//
//  main.m
//  debug_objc
//
//  Created by Holy_Han on 19/09/2017.
//
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        NSObject *obj = [[NSObject alloc] init];
        __weak NSObject *weakObj = obj;
    }
    return 0;
}
