//
//  AthMovilPaySDK.m
//  AthMovilPaySDK
//
//  Created by Imaginary Sense on 10/15/16.
//  Copyright © 2016 Imaginary Sense. All rights reserved.
//

#import "AthMovilPaySDK.h"

@implementation AthMovilPaySDK

-(void)requestPayment:(float)amount phoneNumber:(NSString *)phoneNumber referenceId:(NSString *)referenceId urlCallback:(NSString *)urlCallback{
	
	NSString *url = [NSString stringWithFormat:@"athmovil://requestPayment?amount=%f&phoneNumber=%@&referenceId=%@&urlCallback=%@", amount, phoneNumber, referenceId, urlCallback];
	//app://requestPayment?amount=18.80&phoneNumber=787525545544&referenceId=12645641651465465140&urlCallback=http://example.com
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)verifyPayment:(NSString *)transactionReciept completion:(void (^) (NSString *data))handler{
	NSURL *URL = [NSURL URLWithString:@"http://athmapi.westus.cloudapp.azure.com/athm/verifyPaymentStatus"];
				  
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
	[request setHTTPMethod:@"POST"];

	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSURLComponents *components = [NSURLComponents componentsWithString:transactionReciept];
	NSMutableDictionary *transactionRecieptData = [[NSMutableDictionary alloc] init];
	for(NSURLQueryItem *item in components.queryItems)
	{
		[transactionRecieptData setObject:item.value forKey:item.name];
	}
	NSLog(@"%@",transactionRecieptData);
	
	NSString *json = [NSString stringWithFormat:@"{\"token\": \"%@\", \"referenceNumber\": \"%@\"}", [transactionRecieptData objectForKey:@"token"], [transactionRecieptData objectForKey:@"referenceNumber"]];
	[request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];

	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request
										  completionHandler:
								^(NSData *data, NSURLResponse *response, NSError *error) {
									
									if (error) {
										// Handle error...
										return;
									}
									
									if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
										//NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
										//NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
									}
									
									NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
									handler(body);
								}];
	[task resume];
}

@end
