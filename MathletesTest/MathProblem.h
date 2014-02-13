//
//  MathProblem.h
//  MathletesTest
//
//  Created by Matthew Voracek on 2/12/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathProblem: NSObject

@property NSInteger mathProblemValue;
@property NSInteger equationDifficulty;
@property BOOL haveAttemptedEquation;

-(id)initWithDifficulty:(NSInteger) difficulty forProblem:(NSInteger) problem;

@end
