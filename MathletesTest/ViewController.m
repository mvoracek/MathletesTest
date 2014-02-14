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
    NSInteger keytwo;
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
    
    [self newMathProblem];
}

- (IBAction)onNewButtonPressed:(id)sender
{
    _answerTextField.text = nil;
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
    if (_userArray[key])
    {
        MathProblem *problem = _userArray[key];
        NSInteger proficiencyChange = problem.equationDifficulty;
        if (_answerTextField.text.intValue == _answerLabel.text.intValue)
        {
            proficiencyChange -= 1;
        }
        else
        {
            proficiencyChange += 1;
        }
        
        problem.equationDifficulty = proficiencyChange;
        problem.haveAttemptedEquation = YES;
        
        NSLog(@"%i %i", problem.mathProblemValue, problem.equationDifficulty);
    }
    
    _answerTextField.text = nil;
    
    [self newMathProblem];
}

-(void)randomMathProblem
{
    _addend1 = arc4random()%10;
    _addend2 = arc4random()%10;
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
    [self randomMathProblem];
    
    MathProblem *mp = _userArray[key];
    
    if (mp.equationDifficulty == 0)
    {
        [self randomMathProblem];
        
    }

    [self newMathProblem];
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
    
    
    //NSString *combinedString = [NSString stringWithFormat:@"%i%i",_addend1,_addend2];
    //NSNumber *key = @(combinedString.intValue);


}

-(void)sortingArray
{
    NSMutableArray *sortingArray = [NSMutableArray new];
    
    for (MathProblem *mp in _userArray)
    {
        [sortingArray addObject:(mp)];
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"equationDifficulty" ascending:YES];
    _userArray = [sortingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    for (int i = 0; i < 100; i++)
    {
        MathProblem *mp2 = _userArray[i];
        if (mp2.equationDifficulty > 0)
        {
            keytwo = i;
            NSLog(@"%i", keytwo);
            break;
        }
    }
    
    for (int i = 0; i < _userArray.count; i++)
    {
        MathProblem *problem = _userArray[i];
        NSLog(@"%i %ld",problem.mathProblemValue, (long)problem.equationDifficulty);
    }
    
}

-(void)newMathProblem
{
    [self sortingArray];
    
    _addend1 = arc4random()%10;
    _addend2 = arc4random()%10;
    
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
    
    int keyAddend = 40;
    
    if (keytwo > 50)
    {
        keyAddend = 25;
    }
    
    if (key < keytwo || key > (keytwo + keyAddend))
    {
        [self newMathProblem];
    }
    
    
    [_difficultyLabel setText:[NSString stringWithFormat:@"%ld",(long)difficulty]];
    
    [_varLabel1 setText:[NSString stringWithFormat:@"%i", _addend1]];
    [_varLabel2 setText:[NSString stringWithFormat:@"%i", _addend2]];
    [_answerLabel setText:[NSString stringWithFormat:@"%i", _addend1 + _addend2]];
    
}

-(void)cardDifficulty
{
    mathProblems = @[         [[MathProblem alloc]initWithDifficulty:2 forProblem:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:2],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:3],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:4],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:5],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:6],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:7],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:8],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:9],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:10],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:11],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:12],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:13],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:14],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:15],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:16],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:17],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:18],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:19],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:20],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:21],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:22],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:23],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:24],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:25],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:26],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:27],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:28],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:29],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:30],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:31],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:32],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:33],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:34],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:35],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:36],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:37],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:38],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:39],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:40],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:41],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:42],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:43],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:44],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:45],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:46],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:47],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:48],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:49],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:50],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:51],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:52],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:53],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:54],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:55],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:56],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:57],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:58],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:59],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:60],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:61],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:62],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:63],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:64],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:65],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:66],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:67],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:68],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:69],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:70],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:71],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:72],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:73],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:74],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:75],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:76],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:77],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:78],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:79],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:80],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:81],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:82],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:83],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:84],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:85],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:86],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:87],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:88],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:89],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:90],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:91],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:92],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:93],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:94],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:95],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:96],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:97],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:98],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:99]
                              ].mutableCopy;
}




@end
