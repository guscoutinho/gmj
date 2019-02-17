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

@import HoundifySDK;

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UIButton *houndifyButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)activateVoiceSearch:(id)sender;
@property (nonatomic, readonly) NSString *explanatoryText;
@property (nonatomic, copy) NSString *updateText;
@property (nonatomic, copy) NSAttributedString *responseText;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewWillAppear:YES];
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
    
    [[Houndify instance] presentListeningViewControllerInViewController:self.tabBarController
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
             self.responseText = [JSONAttributedFormatter attributedStringFromObject:dictionary style:nil];
             
             HoundDataCommandResult* commandResult = [response allResults].firstObject;
             
             // Any properties from the documentation can be accessed through the keyed accessors, e.g.:
             
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
        text = [@"Houndify.h offers the simplest API for offering voice search in your app. It provides a UI and manages audio for you. Tap the microphone to begin a voice search with presentListeningViewController(...)" mutableCopy];
    }
    else
    {
        return nil;
    }
    
    if ([HoundVoiceSearch instance].state == HoundVoiceSearchStateNone || ![HoundVoiceSearch instance].enableHotPhraseDetection)
    {
        [text appendString:@"\n\nTo use a hot phrase with the Houndify UI, audio must first be explicitly activated. See startListeningForHotPhrase() in HoundifyViewController in this sample code. Tap \"Listen for Hot Phrase\""];
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


@end
