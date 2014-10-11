//
//  JTCollectionViewController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/5/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTCollectionViewController.h"
#import "JTCollection.h"
#import "JTAppDelegate.h"
#import "JTCollectionViewCell.h"
#import "JTDetailViewController.h"

@interface JTCollectionViewController (){
    NSArray *videoImages;
    NSArray *videoTitle;
    
}

@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSMutableDictionary *listImages;

-(void)getAll;

@end

@implementation JTCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocalyticsSession shared] tagEvent:@"JTimes Main"];
    //init images and collection cells.
    self.listImages = [NSMutableDictionary dictionary];
    [self getAll];
    
    //Background
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
    [self.collectionView setBackgroundColor:bgColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_list count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    JTCollection *schema = [self.list objectAtIndex:indexPath.row];
    
    [cell.title setText:schema.title];
    cell.image.image = [UIImage imageNamed:[schema cellImage]];
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
    
    /*
     UIImageView *videoImageView = (UIImageView *)[cell viewWithTag:100];
     videoImageView.image = [UIImage imageNamed:[videoImages objectAtIndex:indexPath.row]];
     
     UILabel *titleLabel = (UILabel *)[cell viewWithTag:200];
     //[titleLabel setText:schema.title];
     titleLabel.text = [videoTitle objectAtIndex:indexPath.row];*/
    
    /*UIImageView *videoImageView = (UIImageView *)[cell viewWithTag:100];
     videoImageView.image = [UIImage imageNamed:[schema cellImage]];
     
     UILabel *titleLabel = (UILabel *)[cell viewWithTag:200];
     titleLabel.text = schema.title;*/
    
    
    
    //UIImage *bg = [UIImage imageNamed:@"collection-item-bg.png"];
    
}

#pragma mark Receive Wall Objects
- (void)getAll
{
    JTCollection* anti1 = [[JTCollection alloc]init];
    JTCollection* anti2 = [[JTCollection alloc]init];
    JTCollection* inter = [[JTCollection alloc]init];
    JTCollection* raising = [[JTCollection alloc]init];
    JTCollection* soul = [[JTCollection alloc]init];
    JTCollection* tikkun = [[JTCollection alloc]init];
    JTCollection* education = [[JTCollection alloc] init];
    JTCollection* paradigm = [[JTCollection alloc]init];
    JTCollection* social1 = [[JTCollection alloc]init];
    JTCollection* social2 = [[JTCollection alloc]init];
    JTCollection* integral = [[JTCollection alloc]init];
    JTCollection* assimilation = [[JTCollection alloc]init];
    
    //Anti-Semitism Pt. 1
    anti1.title = @"Anti-Semitism Pt. 1";
    anti1.cellImage = @"09_why-is-antisemitism-on-rise.png";
    anti1.detailText = @"Why Is Anti-Semitism On The Rise? -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses why anti-Semitism is on the rise today in this episode of Jewish Times.";
    anti1.videoBGImage = @"VideoFrameAS1.png";
    anti1.url = @"http://m.kab.tv/ios/JTimes/AntiSematism1.mp4";
    
    //Anti-Semitism Pt. 2
    anti2.title = @"Anti-Semitism Pt. 2";
    anti2.cellImage = @"10_global-anti-semitism.png";
    anti2.detailText = @"Global Anti-Semitism -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses why anti-Semitism is on the rise globally today in this episode of Jewish Times.";
    anti2.videoBGImage = @"VideoFrameAS2.png";
    anti2.url = @"http://m.kab.tv/ios/JTimes/AntiSematism2.mp4";
    
    //Interdependence
    inter.title = @"Interdependence";
    inter.cellImage = @"11_living-in-interdependent-times.png";
    inter.detailText = @"Living in Interdependent Times -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses living in interdependent times in this episode of Jewish Times.";
    inter.videoBGImage = @"VideoFrameInter.png";
    inter.url = @"http://m.kab.tv/ios/JTimes/Interdependent.mp4";
    
    //Raising Childen
    raising.title = @"Raising Children";
    raising.cellImage = @"12_childrens-integral-education.png";
    raising.detailText = @"Children's Integral Education -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses children's integral education in this episode of Jewish Times.";
    raising.videoBGImage = @"VideoFrameRaising.png";
    raising.url = @"http://m.kab.tv/ios/JTimes/RaisingChildren.mp4";
    
    
    //The Soul
    soul.title = @"The Soul";
    soul.cellImage = @"13_collective-soul-jewish-soul.png";
    soul.detailText = @"The Collective Soul & The Jewish Soul -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses the soul - the collective soul & the Jewish soul - in this episode of Jewish Times.";
    soul.videoBGImage = @"VideoFrameSoul.png";
    soul.url = @"http://m.kab.tv/ios/JTimes/Soul.mp4";
    
    //Tikkun
    tikkun.title = @"Tikkun Olam";
    tikkun.cellImage = @"14_what-is-tikkun-olam.png";
    tikkun.detailText = @"What Is Tikkun Olam? -\nJtimes with Kabbalist Dr. Michael Laitman\nDr. Michael Laitman discusses the Kabbalah take on Tikkun Olam in this episode of Jewish Times.";
    tikkun.videoBGImage = @"VideoFrameTikkun.png";
    tikkun.url = @"http://m.kab.tv/ios/JTimes/Tikkun.mp4";
    
    //Education
    education.title = @"Education";
    education.cellImage = @"15_education.png";
    education.detailText = @"Education -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses education in relation to the Jewish people in this episode of Jewish Times.";
    education.videoBGImage = @"VideoFrameEducation.png";
    education.url = @"http://m.kab.tv/ios/JTimes/Education.mp4";
    
    //Paradigm
    paradigm.title = @"Paradigm Shift";
    paradigm.cellImage = @"17_social-media_02.png";
    paradigm.detailText = @"Today's Paradigm Shift from\nCompetition to Cooperation -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses today's paradigm shift from competition to cooperation in this episode of Jewish Times.";
    paradigm.videoBGImage = @"VideoFrameParadigm.png";
    paradigm.url = @"http://m.kab.tv/ios/JTimes/Paradigm.mp4";
    
    //Social Media Pt. 1
    social1.title = @"Social Media Pt. 1";
    social1.cellImage = @"18_social-media_01.png";
    social1.detailText = @"Social Media & Social Networks,\nPart 1 of 2 -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses social media & social networks in this episode of Jewish Times.";
    social1.videoBGImage = @"VideoFrameSocial1.png";
    social1.url = @"http://m.kab.tv/ios/JTimes/Social1.mp4";
    
    //Social Media Pt. 2
    social2.title = @"Social Media Pt. 2";
    social2.cellImage = @"19_jewish-assimilation.png";
    social2.detailText = @"Social Media & Social Networks,\nPart 2 of 2 -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses social media & social networks in this episode of Jewish Times.";
    social2.videoBGImage = @"VideoFrameSocial2.png";
    social2.url = @"http://m.kab.tv/ios/JTimes/Social2.mp4";
    
    //Integral Thinking
    integral.title = @"Integral Thinking";
    integral.cellImage = @"07_integral-thinking.png";
    integral.detailText = @"How to Develop Integral Thinking -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses how to develop integral thinking in this episode of Jewish Times.";
    integral.videoBGImage = @"VideoFrameTikkun.png";
    integral.url = @"http://m.kab.tv/ios/JTimes/Integral.mp4";
    
    //Assimilation
    assimilation.title = @"Assimilation";
    assimilation.cellImage = @"02_assimilation.png";
    assimilation.detailText = @"Jewish Assimilation -\nJtimes with Kabbalist Dr. Michael Laitman\n\nDr. Michael Laitman discusses Jewish assimilation in this episode of Jewish Times.";
    assimilation.videoBGImage = @"VideoFrameEducation.png";
    assimilation.url = @"http://m.kab.tv/ios/JTimes/Assimilation.mp4";
    
    self.list = [NSArray arrayWithObjects:anti1, anti2, inter, raising, soul, tikkun, education, paradigm, social1, social2, integral, assimilation, nil];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"detail" sender:self];

}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"detail"]){
        
        JTDetailViewController* detail = (JTDetailViewController *)segue.destinationViewController;
         NSIndexPath * indexPath = [[self.collectionView indexPathsForSelectedItems]lastObject];
         JTCollection * schema = [self.list objectAtIndex:indexPath.row];
         
         detail.schema = schema;
        
    }
}

@end
