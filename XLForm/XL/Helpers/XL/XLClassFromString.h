//
//  XLClassFromString.h
//  Pods
//
//  Created by Alex Zdorovets on 5/16/16.
//
//

Class XLClassFromString(NSString *className) {
    Class cls = NSClassFromString(className);
    if (cls == nil) {
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
        className = [NSString stringWithFormat:@"%@.%@", appName, className];
        cls = NSClassFromString(className);
    }
    return cls;
}
