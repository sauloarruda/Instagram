//
//  UploadViewController.m
//  Instagram
//
//  Created by Saulo Arruda Coelho on 7/25/12.
//  Copyright (c) 2012 Jera. All rights reserved.
//

#import "UploadViewController.h"
#import "Constants.h"

@interface UploadViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;

@end

@implementation UploadViewController
@synthesize uploadImage;
@synthesize descriptionTextField;
@synthesize progressView;

- (void)showCameraView
{
    UIImagePickerController* destination = [[UIImagePickerController alloc] init];
    destination.sourceType = UIImagePickerControllerSourceTypeCamera;
    destination.delegate = self;
    [self presentModalViewController:destination animated:NO];
}

- (void)viewDidLoad
{
    [self showCameraView];
}

-(void)performUpload:(UIImage*)image
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    NSString* url = [NSString stringWithFormat:UPLOAD_URL_FORMAT, API_ROOT];
    [urlRequest setURL:[NSURL URLWithString:url]];    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    //[urlRequest addValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData = [NSMutableData data]; //[NSMutableData dataWithCapacity:[data length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", @"upload-image.jpg"]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:UIImageJPEGRepresentation(image, 90)]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setHTTPBody:postData];
    
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    if (connection) {
        
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error uploading: %@", error);
}


- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    NSLog(@"bytesWritten=%d, totalBytesWritten=%d, totalBytesExpectedToWrite=%d, progress=%f", bytesWritten, totalBytesWritten,totalBytesExpectedToWrite, progress);
    [self.progressView setProgress:progress];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[[UIAlertView alloc] initWithTitle:@"Sucesso" message:@"Foto adicionada com sucesso" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self.tabBarController setSelectedIndex:0];
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.progressView setHidden:YES];
    [self.descriptionTextField setText:@""];
    self.uploadImage.image = nil;
}


#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.uploadImage.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setUploadImage:nil];
    [self setDescriptionTextField:nil];
    [self setProgressView:nil];
    [super viewDidUnload];
}


- (IBAction)cameraButtonTapped:(id)sender {
    [self showCameraView];
}

- (IBAction)doneButtonTapped:(id)sender {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.descriptionTextField resignFirstResponder];
    [self.progressView setHidden:NO];
    [self performUpload:self.uploadImage.image];
}
@end
