//
//  ViewController.m
//  MathletesTest
//
//  Created by Matthew Voracek on 2/11/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "ViewController.h"
#import "GridViewController.h"
#import "MathProblem.h"

@interface ViewController ()
{
    NSMutableArray *mathProblems;
    NSInteger difficulty;
    NSInteger key;
}

@property (weak, nonatomic) IBOutlet UILabel *varLabel1;
@property (weak, nonatomic) IBOutlet UILabel *varLabel2;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *combinedLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self cardDifficulty];
    
    _userArray = mathProblems;

}

- (IBAction)onNewButtonPressed:(id)sender
{
    [self newMathProblem];
}

- (IBAction)onGridButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"GridSegue" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GridSegue"])
    {
        GridViewController *vc  = [segue destinationViewController];
        
        vc.gridArray= _userArray;
        
    }
}

- (IBAction)onGoButtonPressed:(id)sender
{
    
}



-(void)newMathLogic
{
    //max stuff
    /*
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [_userArray enumerateKeysAndObjectsUsingBlock:^(NSNumber *questionIndex, MathProblem *mp, BOOL *stop) {
        NSNumber *newkey = @(mp.equationDifficulty);
        if (!dict[newkey])
            dict[newkey] = [NSMutableArray new];
        else
            [dict[newkey] addObject:@[questionIndex, mp]];
    }];
    */
    
    //my stuff
    
    /*
    NSMutableArray *unsortedArray = [NSMutableArray new];
    
    for (MathProblem *mp in _userArray)
    {
        [unsortedArray addObject:(mp)];
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    _sortedProblems = [unsortedArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for (int i = 0; i < _sortedProblems.count; i++)
    {
        NSLog(@"%@",_sortedProblems[i]);
    }
    */
    _addend1 = arc4random()%10;
    _addend2 = arc4random()%10;
    
    /*
    NSString *combinedString = [NSString stringWithFormat:@"%i%i",_addend1,_addend2];
    NSNumber *key = @(combinedString.intValue);
    
    MathProblem *mp = _userArray[key];
    
    if (mp.equationDifficulty == 0)
    {
        [self newMathLogic];
    }
    */

}

-(void)newMathProblem
{
    [self newMathLogic];
    
    [_combinedLabel setText:[NSString stringWithFormat:@"%i%i",_addend1,_addend2]];
    
    NSString *newkey = _combinedLabel.text;
    NSInteger numkey = newkey.intValue;
    
    [_userArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
    {
        if (numkey == problem.mathProblemValue)
        {
            difficulty = problem.equationDifficulty;
            key = idx;
        }
    }];
    
    
    NSLog(@"%i", _combinedLabel.text.intValue);
    
    
    [_difficultyLabel setText:[NSString stringWithFormat:@"%ld",(long)difficulty]];
    
    [_varLabel1 setText:[NSString stringWithFormat:@"%i", _addend1]];
    [_varLabel2 setText:[NSString stringWithFormat:@"%i", _addend2]];
    [_answerLabel setText:[NSString stringWithFormat:@"%i", _addend1 + _addend2]];

    
    /*
    NSString *combinedString = [NSString stringWithFormat:@"%i%i",_addend1,_addend2];
    NSNumber *key = @(combinedString.intValue);
    */
    
    if (_userArray[key])
    {
        MathProblem *problem = _userArray[key];
        NSInteger valuenum = problem.equationDifficulty;
        int value = valuenum;
        value -= 1;
        problem.equationDifficulty = value;
        problem.haveAttemptedEquation = YES;
    }
    
}

-(void)cardDifficulty
{
    mathProblems = @[[[MathProblem alloc]initWithDifficulty:1 forProblem:0],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:1],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:2],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:3],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:4],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:5],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:6],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:7],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:8],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:9],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:10],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:11],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:12],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:13],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:14],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:15],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:16],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:17],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:18],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:19],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:20],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:21],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:22],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:23],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:24],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:25],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:26],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:27],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:28],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:29],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:30],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:31],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:32],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:33],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:34],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:35],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:36],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:37],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:38],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:39],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:40],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:41],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:42],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:43],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:44],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:45],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:46],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:47],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:48],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:49],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:50],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:51],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:52],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:53],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:54],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:55],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:56],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:57],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:58],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:59],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:60],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:61],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:62],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:63],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:64],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:65],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:66],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:67],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:68],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:69],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:70],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:71],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:72],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:73],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:74],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:75],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:76],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:77],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:78],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:79],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:80],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:81],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:82],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:83],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:84],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:85],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:86],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:87],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:88],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:89],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:90],
                              [[MathProblem alloc]initWithDifficulty:1 forProblem:91],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:92],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:93],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:94],
                              [[MathProblem alloc]initWithDifficulty:3 forProblem:95],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:96],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:97],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:98],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:99]
                              ].mutableCopy;
}




@end
