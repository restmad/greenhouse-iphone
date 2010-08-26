    //
//  EventSessionsByDayViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/30/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "EventSessionsByDayViewController.h"


@interface EventSessionsByDayViewController()

@property (nonatomic, retain) NSMutableArray *arrayTimes;

@end


@implementation EventSessionsByDayViewController

@synthesize arrayTimes;
@synthesize eventDate;

- (void)fetchRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed)
	{
		self.arraySessions = [[NSMutableArray alloc] init];
		self.arrayTimes = [[NSMutableArray alloc] init];
		
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSArray *array = [responseBody yajl_JSON];
		[responseBody release];
		
		DLog(@"%@", array);
		
		NSMutableArray *arrayBlock = nil;
		NSDate *sessionTime = [NSDate distantPast];
		
		for (NSDictionary *d in array) 
		{
			EventSession *session = [[EventSession alloc] initWithDictionary:d];
			
			// for each time block create an array to hold the sessions for that block
			if ([sessionTime compare:session.startTime] == NSOrderedAscending)
			{
				arrayBlock = [[NSMutableArray alloc] init];
				[self.arraySessions addObject:arrayBlock];
				[arrayBlock release];
				
				[arrayBlock addObject:session];
			}
			else if ([sessionTime compare:session.startTime] == NSOrderedSame)
			{
				[arrayBlock addObject:session];
			}
			
			sessionTime = session.startTime;
			
			NSDate *date = [session.startTime copyWithZone:NULL];
			[self.arrayTimes addObject:date];
			[date release];
			
			[session release];
		}
		
		[self.tableViewSessions reloadData];
	}
}

- (EventSession *)eventSessionForIndexPath:(NSIndexPath *)indexPath
{
	EventSession *session = nil;
	
	@try 
	{
		NSArray *array = (NSArray *)[self.arraySessions objectAtIndex:indexPath.section];
		session = (EventSession *)[array objectAtIndex:indexPath.row];
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		session = nil;
	}
	@finally 
	{
		return session;
	}
}


#pragma mark -
#pragma mark DataViewDelegate

- (void)refreshView
{
	// clear out any existing data
	self.arraySessions = nil;
	self.arrayTimes = nil;
	[self.tableViewSessions reloadData];
	
	// set the title of the view to the schedule day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
	NSString *dateString = [dateFormatter stringFromDate:eventDate];
	[dateFormatter release];
	self.title = dateString;
}

- (void)fetchData
{
	// request the sessions for the selected day
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-d"];
	NSString *dateString = [dateFormatter stringFromDate:eventDate];
	[dateFormatter release];
	NSString *urlString = [[NSString alloc] initWithFormat:EVENT_SESSIONS_BY_DAY_URL, self.event.eventId, dateString];
	[self fetchJSONDataWithURL:[NSURL URLWithString:urlString]];
	[urlString release];	
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger numberOfSections;
	
	@try 
	{
		if (arrayTimes)
		{
			numberOfSections = [arrayTimes count];
		}
		else 
		{
			numberOfSections = 1;
		}

	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		numberOfSections = 0;
	}
	@finally 
	{
		return numberOfSections;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRows;
	
	@try 
	{
		if (self.arraySessions)
		{
			NSArray *array = (NSArray *)[self.arraySessions objectAtIndex:section];
			numberOfRows = [array count];
		}
		else 
		{
			numberOfRows = 1;
		}
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		numberOfRows = 0;
	}
	@finally 
	{
		return numberOfRows;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *s = nil;
	
	@try 
	{
		NSDate *sessionTime = (NSDate *)[arrayTimes objectAtIndex:section];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm a"];
		NSString *dateString = [dateFormatter stringFromDate:sessionTime];
		[dateFormatter release];
		s = dateString;		
	}
	@catch (NSException * e) 
	{
		DLog(@"%@", [e reason]);
		s = nil;
	}
	@finally 
	{
		return s;
	}
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Schedule";
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayTimes = nil;
	self.eventDate = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayTimes release];
	[eventDate release];
	
    [super dealloc];
}


@end
