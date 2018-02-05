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
        NSObject *objc = [NSObject new];
        __weak id weakObjc = objc;
        NSLog(@"weak = %@", weakObjc);
    }
    return 0;
}
