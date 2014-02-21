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

@interface ViewController () <PFSignUpViewControllerDelegate>
{
    NSMutableArray *mathProblems;
    NSInteger difficulty;
    NSInteger userArrayKey;
    NSInteger firstNonZeroKey;
    int keyAddend;
    NSInteger numkey;
    NSString *newkey;
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
    
    if ([PFUser currentUser])
    {
        PFQuery *query = [PFQuery queryWithClassName:@"MathProblem"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
            _userArray = (NSMutableArray *)objects;
            
            for (int i = 0; i < _userArray.count; i++)
            {
                MathProblem *problem = _userArray[i];
                NSLog(@"%i %i %ld",problem.firstValue, problem.secondValue, (long)problem.equationDifficulty);
            }
            
            [self newMathProblem];
        }];
        /*
        [query getObjectInBackgroundWithId:@"mathArray" block:^(PFObject *object, NSError *error)
         {
             _userArray = (NSMutableArray *)object;
             
             for (int i = 0; i < _userArray.count; i++)
             {
                 MathProblem *problem = _userArray[i];
                 NSLog(@"%i %ld",problem.mathProblemValue, (long)problem.equationDifficulty);
             }
         }];
        */
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (![PFUser currentUser])
    {
        PFLogInViewController *login = [PFLogInViewController new];
        UILabel *label = [[ UILabel alloc]initWithFrame:CGRectZero];
        login.signUpController.delegate = self;
        label.text = @"Mathletes Tester";
        [label sizeToFit];
        login.logInView.logo = label;
        [self presentViewController:login animated:YES completion:nil];

    }
    
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    _userArray = [self cardDifficulty];

    [_userArray enumerateObjectsUsingBlock:^(MathProblem *obj, NSUInteger idx, BOOL *stop)
    {
        [obj saveInBackground];
    }];
    
    [signUpController dismissViewControllerAnimated:YES completion:nil];
    
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
    if (!_userArray.count)
        return;
    
    if (_userArray[userArrayKey])
    {
        MathProblem *problem = _userArray[userArrayKey];
        NSInteger proficiencyChange = problem.equationDifficulty;
        if (_answerTextField.text.intValue == _answerLabel.text.intValue)
        {
            if (problem.equationDifficulty > 0)
            {
                proficiencyChange -= 1;
            }
        }
        else
        {
            if (problem.equationDifficulty < 10)
            {
                proficiencyChange += 1;
            }
        }
        
        problem.equationDifficulty = proficiencyChange;
        problem.haveAttemptedEquation = YES;
        
        NSLog(@"%i %i %i", problem.firstValue, problem.secondValue, problem.equationDifficulty);
        
        [_userArray enumerateObjectsUsingBlock:^(MathProblem *obj, NSUInteger idx, BOOL *stop)
         {
             [obj saveInBackground];
         }];
    }
    
    _answerTextField.text = nil;
    
    [self newMathProblem];
}

-(void)sortingArray
{
    /*
    //sean's stuff
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"equationDifficulty" ascending:YES];
    
    _userArray = [_userArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSIndexSet *indexes = [_userArray indexesOfObjectsPassingTest:^BOOL(MathProblem *prob, NSUInteger idx, BOOL *stop) {
        if (prob.equationDifficulty > 0)
        {
            *stop = YES;
            return NO;
        }
        return YES;
    }];
    firstNonZeroKey = [indexes count] - 1;
    */

//    NSIndexSet *indexes = [_userArray indexesOfObjectsPassingTest:^BOOL(MathProblem *prob, NSUInteger idx, BOOL *stop) {
//        if (prob.equationDifficulty > 0)
//        {
//            NSLog(@"%i", firstNonZeroKey);
//            *stop = YES;
//            return YES;
//        }
//        return NO;
//    }];
//    firstNonZeroKey = [indexes firstIndex];
    
        //my stuff
//    for (MathProblem *prob in _userArray) {
//        if (prob.equationDifficulty > 0)
//        {
//            firstNonZeroKey = [_userArray indexOfObject:prob];
//            NSLog(@"%i", firstNonZeroKey);
//            break;
//        }
//    }
//    
//    for (int i = 0; i < 100; i++)
//    {
//        MathProblem *mp2 = _userArray[i];
//        if (mp2.equationDifficulty > 0)
//        {
//            firstNonZeroKey = i;
//            NSLog(@"%i", firstNonZeroKey);
//            break;
//        }
//    }
//    
//    for (int i = 0; i < _userArray.count; i++)
//    {
//        MathProblem *problem = _userArray[i];
//        NSLog(@"%i %ld",problem.mathProblemValue, (long)problem.equationDifficulty);
//    }
    
    NSMutableArray *sortingArray = [NSMutableArray new];
    
    for (MathProblem *mp in _userArray)
    {
        [sortingArray addObject:(mp)];
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"equationDifficulty" ascending:YES];
    _userArray = [sortingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for (int i = 0; i < _userArray.count; i++)
    {
        MathProblem *mp2 = _userArray[i];
        if (mp2.equationDifficulty > 0)
        {
            firstNonZeroKey = i;
            NSLog(@"%li", (long)firstNonZeroKey);
            break;
        }
    }
    
    for (int i = 0; i < _userArray.count; i++)
    {
        MathProblem *problem = _userArray[i];
        NSLog(@"%i %i %ld",problem.firstValue, problem.secondValue, (long)problem.equationDifficulty);
    }
}

-(void)setNewKey
{
    [_combinedLabel setText:[NSString stringWithFormat:@"%i%i",_addend1,_addend2]];
    newkey = _combinedLabel.text;
    numkey = newkey.intValue;

//    userArrayKey = [_userArray indexOfObjectPassingTest:^BOOL(MathProblem *problem, NSUInteger idx, BOOL *stop) {
//        if (numkey == problem.mathProblemValue)
//        {
//            difficulty = problem.equationDifficulty;
//            return YES;
//        }
//        return NO;
//    }];
    
    [_userArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
     {
         if (numkey == problem.mathProblemValue)
         {
             difficulty = problem.equationDifficulty;
             userArrayKey = idx;
             *stop = YES;
         }
     }];
}

-(void)newMathProblem
{
    [self sortingArray];
    
    //original random value
    _addend1 = arc4random()%10;
    _addend2 = arc4random()%10;
    
    [self setNewKey];
    
    //setting pool of possible problems
    keyAddend = 40;
    
    if (firstNonZeroKey > 35)
    {
        keyAddend = 30;
        
        if (firstNonZeroKey > 50)
        {
            keyAddend = 25;
            
            if (firstNonZeroKey > 80)
            {
                keyAddend = 100 - firstNonZeroKey;
                
            }
        }
    }
    
    //rechoosing problem if proficiency is reached
    if (userArrayKey < firstNonZeroKey || userArrayKey > (firstNonZeroKey + keyAddend))
    {
        //allowing for old problems when there is a pool < 20
        if (firstNonZeroKey > 80)
        {
            int chanceOfOldProblem = arc4random()%4;
            
            if (chanceOfOldProblem == 0)
            {
                _addend1 = arc4random()%4 + 4;
                _addend2 = arc4random()%4 + 4;
                
                [self setNewKey];
            }
            else
            {
                [self newMathProblem];
            }
        }
        else
        {
            [self newMathProblem];
        }
    }

    
    [_difficultyLabel setText:[NSString stringWithFormat:@"%ld",(long)difficulty]];
    
    [_varLabel1 setText:[NSString stringWithFormat:@"%i", _addend1]];
    [_varLabel2 setText:[NSString stringWithFormat:@"%i", _addend2]];
    [_answerLabel setText:[NSString stringWithFormat:@"%i", _addend1 + _addend2]];
    
}

-(NSMutableArray *)cardDifficulty
{
    return  @[                [[MathProblem alloc]initWithDifficulty:2
                                  forProblem:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:10],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:11],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:2],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:20],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:21],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:12],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:3],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:30],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:31],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:13],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:4],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:40],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:41],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:14],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:5],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:50],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:51],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:15],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:22],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:23],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:32],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:6],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:60],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:61],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:16],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:7],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:70],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:71],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:17],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:8],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:80],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:81],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:18],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:9],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:90],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:91],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:19],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:33],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:24],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:42],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:25],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:52],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:26],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:62],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:27],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:72],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:28],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:82],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:29],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:92],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:34],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:43],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:35],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:53],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:36],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:63],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:37],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:73],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:38],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:83],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:39],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:93],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:44],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:54],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:45],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:55],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:46],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:64],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:47],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:74],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:48],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:84],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:49],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:94],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:56],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:65],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:66],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:57],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:75],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:58],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:85],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:59],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:95],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:67],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:76],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:68],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:86],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:69],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:96],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:77],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:88],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:99],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:78],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:79],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:87],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:89],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:97],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:98]
                              ].mutableCopy;
}

-(NSMutableArray *)subtractionDifficulty
{
    return  @[                [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:0 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:1 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:1 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:2 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:2 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:2 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:3 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:3 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:3 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:3 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:9 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:9 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:9 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:9 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:62 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:64 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:63 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:101 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:72 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:82 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:73 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:109 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:92 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:97 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:102 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:112 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:75 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:85 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:95 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:105 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:83 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:93 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:86 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:96 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:103 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:113 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:123 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:74 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:84 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:94 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:104 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:108 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:119 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:114 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:124 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:134 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:115 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:125 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:135 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:145 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:106 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:116 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:126 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:136 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:146 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:156 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:107 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:117 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:127 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:137 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:147 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:157 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:167 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:118 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:128 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:138 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:148 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:158 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:168 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:178 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:129 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:139 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:149 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:159 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:169 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:179 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:189 ofProblemType:1]
                              ].mutableCopy;
    
}



@end
