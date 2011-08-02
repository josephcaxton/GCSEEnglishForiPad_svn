// 
//  QuestionHeader.m
//  Evaluator
//
//  Created by Joseph caxton-Idowu on 18/09/2010.
//  Copyright 2010 caxtonidowu. All rights reserved.
//

#import "QuestionHeader.h"

#import "lk_QuestionTemplate.h"

@implementation QuestionHeader 

@dynamic LoggedDate;
@dynamic DateAutorized;
@dynamic Autorize;
@dynamic QuestionInfo;
@dynamic QuestionTemplate;
@dynamic QuestionHeader_Topic;
@dynamic QuestionItems;

@end


@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}

- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
}

@end