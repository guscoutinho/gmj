//
//  HomeViewController.m
//  gmj
//
//  Created by Gustavo  Coutinho on 2/16/19.
//  Copyright © 2019 Gustavo  Coutinho. All rights reserved.
//

#import "HomeViewController.h"
#import "CallTableViewCell.h"
#import "JSONAttributedFormatter.h"
#import "Audio.h"

@import HoundifySDK;

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)didTapBackButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UIButton *houndifyButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)activateVoiceSearch:(id)sender;
@property (nonatomic, readonly) NSString *explanatoryText;
@property (nonatomic, copy) NSString *updateText;
@property (nonatomic, copy) NSAttributedString *responseText;
@property (strong, nonatomic) IBOutlet UIView *greenBackground;

@property (weak, nonatomic) IBOutlet UIView *messageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewWillAppear:YES];
    self.messageView.alpha = 0;
    self.backButton.alpha = 0;
    self.timelinePosts = [[NSMutableArray alloc] init];
    
    self.greenBackground.alpha = 0.5;
    self.houndifyButton.alpha = 1;
    
    self.greenBackground.layer.cornerRadius = self.greenBackground.frame.size.width / 2;
    self.greenBackground.layer.masksToBounds = YES;



}

- (void)viewWillAppear:(BOOL)animated {
    
    // Add Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHoundVoiceSearchStateChangeNotification:) name:HoundVoiceSearchStateChangeNotification object:nil];
    
    // Observe HoundVoiceSearchHotPhraseNotification to be notified of when the hot phrase is detected.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHoundVoiceSearchHotPhraseNotification:) name:HoundVoiceSearchHotPhraseNotification object:nil];
}

#pragma mark Notifications

- (void) handleHoundVoiceSearchHotPhraseNotification:(NSNotification *)notification
{
    [self activateVoiceSearch:self.houndifyButton];
}

- (void) handleHoundVoiceSearchStateChangeNotification:(NSNotification *)notification
{
    NSString *statusString = nil;
    
    switch ([HoundVoiceSearch instance].state)
    {
        case HoundVoiceSearchStateNone:
            // Don't update UI when audio is disabled for backgrounding.
            if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) {
                statusString = @"";
                [self refreshTextView];
            }
            break;
            
        case HoundVoiceSearchStateReady:
            statusString = @"Listening";
            [self refreshTextView];
            break;
            
        case HoundVoiceSearchStateRecording:
            statusString = @"Recording";
            [self refreshTextView];
            break;
            
        case HoundVoiceSearchStateSearching:
            statusString = @"Searching";
            break;
            
        case HoundVoiceSearchStateSpeaking:
            statusString = @"Speaking";
            break;
    }
    
    self.statusLabel.text = statusString;
}


- (IBAction)activateVoiceSearch:(id)sender {
    [self resetTextView];
    
    // Launch the houndify listening UI using presentListeningViewControllerInViewController:fromView:style:requestInfo:responseHandler:
    [self startListeningForHotPhrase];
    [[HoundVoiceSearch instance] startSearchWithRequestInfo:nil responseHandler:
     
     
     ^(NSError* error, HoundVoiceSearchResponseType responseType, id response, NSDictionary* dictionary, NSDictionary* requestInfo) {
         
         NSLog(@"first step");
         
//         if (error)
//         {
//             NSLog(@"YOOOOOOOOOOO");
//             return;
//         }
         
         if (responseType == HoundVoiceSearchResponseTypePartialTranscription) {
             // partial transcription
             NSLog(@"NOOOOOOOOOOO");

         } else if (responseType == HoundVoiceSearchResponseTypeHoundServer) {
             
             HoundDataHoundServer* houndServer = response;
             NSString *transcription = [houndServer.disambiguation.choiceData.firstObject transcription];
             
             NSLog(@"Transcription: %@", transcription);
         }
     }];
    
    
    [[Houndify instance] presentListeningViewControllerInViewController:nil
                                                               fromView:sender
                                                                  style:nil
                                                            requestInfo:nil
                                                        responseHandler:
     
     

     ^(NSError * _Nullable error, id  _Nullable response, NSDictionary<NSString *,id> * _Nullable dictionary, NSDictionary<NSString *,id> * _Nullable requestInfo) {
         if (error)
         {
             self.updateText = [NSString stringWithFormat:@"%@ %ld %@", error.domain, error.code, error.localizedDescription];
         }
         else
         {
             NSAttributedString *bigString;
             bigString = [JSONAttributedFormatter attributedStringFromObject:dictionary style:nil];
             
             NSAttributedString *date;
             date = [JSONAttributedFormatter attributedStringFromObject:dictionary[@"BuildInfo"][@"Date"] style:nil];
             
             self.responseText = [JSONAttributedFormatter attributedStringFromObject:dictionary[@"Disambiguation"][@"ChoiceData"][0][@"Transcription"] style:nil];
                          
             Audio *audio = [[Audio alloc] init];
             
             // here we do that good for loop to loop through string ***************
//             NSArray *accidents = [NSArray arrayWithObjects:@"accident",@"crash", @"drown", "lightning",@"overdose",@"assault",@"fight",@"hurt",@"injure",@"attack",@"drunk driver", "weapon",@"gun", nil];
//             NSArray *medicalEmergency = [NSArray arrayWithObjects:@"stroke",@"heart attack", @"seizure", "diabetes",@"faint",@"pass out",@"passed out",@"unconscious",@"hypothermia",@"breathe",@"breath", @"dizzy",@"dizziness", @"blind", @"blood", @"bone", @"choke", @"choking", @"poison", @"venom", @"allergic reaction", nil];
//             NSArray *fire = [NSArray arrayWithObjects:@"fire",@"arson", @"burn", nil];
//             NSArray *crime = [NSArray arrayWithObjects:@"theft",@"arson", @"theif", "thieves",@"burglar",@"robber",@"fight", nil];
//             NSArray *potentialDanger = [NSArray arrayWithObjects:@"suspicious",@"nervous", @"scared", "uncomfortable",@"loiter",@"following me",@"stalk", nil];
//             NSArray *grandArray = [NSArray arrayWithObjects:accidents, medicalEmergency, fire, crime, potentialDanger, nil];
             
             audio.textToString = self.responseText.string;
             audio.date = date.string;
//             NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//             for (int i = 0; i < [grandArray count]; i++) {
//                 for (int j =  0; j < [grandArray[i] count]; j++) {
//                     if ([self.responseText.string rangeOfString:grandArray[i][j]].location != NSNotFound) {
//                         [tempArray addObject:grandArray[i][j]];
//                     }
//                }
//             }
//             audio.tags = tempArray;
             
             [self.timelinePosts addObject:audio];
             
             HoundDataCommandResult* commandResult = [response allResults].firstObject;
            
             
//              Any properties from the documentation can be accessed through the keyed accessors, e.g.:
             
             NSDictionary* nativeData = commandResult[@"NativeData"];
             

             NSLog(@"NativeData: %@", nativeData);
         }
         
         [self dismissSearch];
     }];
}

- (void)resetTextView
{
    self.updateText = nil;
    self.responseText = nil;
}

- (void)dismissSearch
{
    [Houndify.instance dismissListeningViewControllerAnimated:YES completionHandler:NULL];
}

- (void)refreshTextView
{
    if (self.responseText.length > 0) {
        self.responseTextView.attributedText = self.responseText;
        self.houndifyButton.alpha = 0;
        self.greenBackground.alpha = 0;
        self.backButton.alpha = 1;
        self.responseTextView.textAlignment = NSTextAlignmentCenter;
        [self.responseTextView setFont:[UIFont fontWithName:@"Arial" size:17]];

    } else if (self.updateText.length > 0) {
        self.responseTextView.text = self.updateText;
    } else {
        self.responseTextView.text = self.explanatoryText;
    }
}

#pragma mark - HoundifySDK

- (void)startListeningForHotPhrase
{
    // Houndify -presentListingViewController: will activate audio if necessary, but
    // if you wish to support beginning voice queries with a hot phrase, you will need to
    // explicitly start HoundVoiceSearch listening.
    
    [[HoundVoiceSearch instance] startListeningWithCompletionHandler:^(NSError * _Nullable error) {
        
        if (error) {
            self.updateText = error.localizedDescription;
        } else {
            [HoundVoiceSearch instance].enableHotPhraseDetection = YES;
            [self refreshTextView];
        }
    }];
}

#pragma mark - Displayed Text

- (NSString *)explanatoryText
{
    NSMutableString *text = nil;
    
    if ([HoundVoiceSearch instance].state == HoundVoiceSearchStateNone || [HoundVoiceSearch instance].state == HoundVoiceSearchStateReady)
    {
        text = [@"Listening..." mutableCopy];
    }
    else
    {
        return nil;
    }
    
    return text;
}

- (void)setUpdateText:(NSString *)updateText
{
    if (![_updateText isEqual:updateText]) {
        _updateText = [updateText copy];
        
        [self refreshTextView];
    }
}

- (void)setResponseText:(NSAttributedString *)responseText
{
    if (![_responseText isEqual:responseText]) {
        _responseText = [responseText copy];
        
        [self refreshTextView];
    }
}


- (IBAction)didTapBackButton:(id)sender {
    self.greenBackground.alpha = 0.5;
    self.houndifyButton.alpha = 1;
    
}
@end
