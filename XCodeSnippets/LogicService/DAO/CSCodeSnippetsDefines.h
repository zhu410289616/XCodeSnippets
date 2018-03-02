//
//  CSCodeSnippetsDefines.h
//  Pods
//
//  Created by zhuruhong on 2018/1/25.
//

#ifndef CSCodeSnippetsDefines_h
#define CSCodeSnippetsDefines_h

#ifdef CSCodeSnippetsDebug
#define CSCodeSnippetsLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define CSCodeSnippetsLog(format, ...)
#endif

#endif /* CSCodeSnippetsDefines_h */
