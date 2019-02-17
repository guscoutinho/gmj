//
//  SignUpViewController.m
//  gmj
//
//  Created by Gustavo  Coutinho on 2/16/19.
//  Copyright © 2019 Gustavo  Coutinho. All rights reserved.
//

#import "SignUpViewController.h"
@import Firebase;

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }else{
        NSLog(@"Successfully Signout");
    }
    
}

- (void)viewWillAppear: (BOOL)animated {
    self.handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       
                   }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[FIRAuth auth] removeAuthStateDidChangeListener:_handle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLogin:(id)sender {

    [[FIRAuth auth] signInWithEmail:self.usernameTextField.text
                           password:self->_passwordTextField.text
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
                             // ...
                         }];
    
    [self performSegueWithIdentifier:@"GoHomeSegue" sender:nil];
}

- (IBAction)didTapSignUp:(id)sender {
    [[FIRAuth auth] createUserWithEmail:self.usernameTextField.text
                               password:self.passwordTextField.text
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
                                NSLog(@"Auth Error: %@", error);
                                NSLog(@"Auth Results: %@", authResult);
                             }];
    
    [self performSegueWithIdentifier:@"GoHomeSegue" sender:nil];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
