//
//  GridViewController.m
//  MathletesTest
//
//  Created by Matthew Voracek on 2/11/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "GridViewController.h"
#import "MathProblem.h"

@interface GridViewController ()
{
    NSInteger key;
    NSInteger difficulty;
}

@end

@implementation GridViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createGrid];
    
    
}

-(void)createGrid
{
    
    int yDirection = 100;
    int subChange = 0;
    
    //i is horizontal, j is vertical, x&yDirection is spacing
    for (int j = 0; j < 10; j++)
    {
        int xDirection = 5;

        
        for (int i = 0; i < 10; i++)
        {
            UILabel *gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(xDirection, yDirection, 30, 30)];
            [self.view addSubview:gridLabel];
            [gridLabel setTextColor:[UIColor blackColor]];
            [gridLabel setTextAlignment:NSTextAlignmentCenter];
            [gridLabel setFont: [UIFont fontWithName:@"Arial" size:13.0]];
            
            //set values
            
            [gridLabel setText:[NSString stringWithFormat:@"%d+%d",i, j]];
            
            NSString *newkey = [NSString stringWithFormat:@"%d%d",i, j];
            NSInteger numkey = newkey.intValue;
            
            [_gridArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
             {
                 if (numkey == problem.mathProblemValue)
                 {
                     difficulty = problem.equationDifficulty;
                     key = idx;
                 }
             }];
            
            
            MathProblem *mp = _gridArray[key];
            difficulty = mp.equationDifficulty;
            BOOL attempted = mp.haveAttemptedEquation;
            
            //background color
            if (difficulty == 0)
            {
                gridLabel.backgroundColor = [UIColor greenColor];
            }
            else if (attempted == YES)
            {
                gridLabel.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(239/255.0) blue:(0/255.0) alpha:1];
                
            }
            else
            {
                gridLabel.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(156.0/255.0) blue:(227/255.0) alpha:1];
            }
            
            xDirection += 31;
            
        }
        subChange++;
        yDirection += 31;
    }
}


@end
