//
//  SNHHZMainView.m
//  SuningEBuy
//
//  Created by apple123 on 2017/11/20.
//  Copyright © 2017年 苏宁易购. All rights reserved.
//

#import "SNHHZMainView.h"

#import "UIColor+YYAdd.h"
#import "UIView+Additions.h"
#import "NSArray+SNFoundation.h"
#import "UIScrollView+MJRefresh.h"
#import "SNDIYNormalHeader.h"
#import "SNDIYNormalFooter.h"
#import "SNHHZMainCommonCell.h"
#import "SNHHZGlobalHeader.h"
#import "DefineConstant.h"
#import "SNHHZConstant.h"
#import "SNHHZMainCellHelper.h"
#import "SNHHZChildInfoCell.h"
#import "SNHHZGuessYouLikeCell.h"
#import "SNHHZGuessYouLikeSwiseCell.h"
#import "SNHHZSliderIconCell.h"
#import "SNHHZMainSliderImageCell.h"
#import "SNHHZVoucherADCell.h"
#import "SNHHZOneADCell.h"
#import "SNHHZTowADCell.h"
#import "SNHHZThreeADCell.h"
#import "SNHHZFourADCell.h"
#import "SNHHZParentsMustBuyCell.h"
#import "SNMKHHZParentsMustBuyCell.h"
#import "SNHHZVerticalArrangedProductCell.h"
#import "SNHHZSliderProductCell.h"
#import "SNHHZGlobalBestCell.h"
#import "SNHHZThemePavilionCell.h"
#import "SNHHZGoodShopSelectCell.h"
#import "SNHHZTeachYouToBuyCell.h"
#import "SNHHZVideoCell.h"
#import "SNHHZCommonHeader.h"
#import "SNHHZTowFourADCell.h"
#import "SNHHZTitleCell.h"
#import "SNHHZSpaceCell.h"
#import "SNHHZMainDataManager.h"
#import "SNMBLoginProtocal.h"
#import "SNMBAddressProtocal.h"
#import "NSString+SNFoundation.h"
#import "NSString+SNHHZExtension.h"
#import "SNHHZHotSaleCell.h"
#import "SNHHZCXAdCell.h"
#import "SNHHZScrollADCell.h"
#import "SNHHZSliderAdView.h"
#import "NSObject+ClickStats.h"
#import "SNClickStatus+SNHHZExtension.h"
#import "SNHHZSliderIconView.h"
#import "SNHHZIntelligentCell.h"
#import "SNMBCouponCenterServiceProtocol.h"
#import "SNMKHHZLowestPriceView.h"

#import "SNHHZToptabCell.h"
#import "SNHHZHistoryLowCell.h"
#import "SNHHZMySameageCell.h"
#import "SNHHZMyStoreCell.h"

@interface SNHHZMainView ()<UITableViewDelegate,UITableViewDataSource,SNHHZSliderAdViewDelegate>

@property (nonatomic, strong) SNHHZMainViewModel *hhzMainViewModel;
//@property (nonatomic, assign) BOOL                       isRefresh;
@property (nonatomic, strong) SNHHZChildInfoDTO *childinfoDto;

@property (nonatomic, strong) SNHHZMainDataManager *dataManager;
@property (nonatomic, strong) UIView * footerLeftLineView;
@property (nonatomic, strong) UIView * footerRightLineView;

@property (nonatomic, assign) BOOL  isShowSliderAd;   //是否展示顶部动画
@property (nonatomic, strong) SNHHZTabbarViewModel *hhzTabViewModel;

//下拉广告
@property (nonatomic,strong) SNHHZSliderAdView *sliderAdvView;

//banner楼层index
@property (nonatomic,strong) NSIndexPath *bannerIndexPath;


@property (nonatomic,strong) SNHHZSliderIconView *sliderIconView;

@property (nonatomic,strong) NSMutableArray *cellSequence;
//@property (nonatomic,assign) NSInteger sliderIconIndex;
@property (nonatomic,assign) NSInteger guessIndex;
@property (nonatomic,assign) CGFloat sliderIconCellY;

@property (nonatomic,assign) NSIndexPath *hotCellY;

@property (nonatomic,assign) BOOL isJumpToHot;

@end

@implementation SNHHZMainView


- (instancetype)initWithFrame:(CGRect)frame withViewModel:(SNHHZMainViewModel *)viewModel andPersentVc:(UIViewController *)persentVc
{
    
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.parentVC = persentVc;
        __weak typeof(self)weakSelf = self;
        self.hhzMainViewModel.refreshBlock = ^{
            [weakSelf reloadMainTable];
        };

        self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.currentBabyIndex = 1;
        self.estimatedRowHeight = 0;
//        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            [self setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            
        }
        
        [self registerClass:[SNHHZMainCommonCell class]  forCellReuseIdentifier:SNHHZMainCommonCellIdentifier];
        [self registerClass:[SNHHZChildInfoCell class]  forCellReuseIdentifier:SNHHZMainChildInfoCellIdentifier];
        [self registerClass:[SNHHZGuessYouLikeCell class]  forCellReuseIdentifier:SNHHZGuessYouLikeCellIdentifier];
        [self registerClass:[SNHHZGuessYouLikeSwiseCell class]  forCellReuseIdentifier:SNHHZGuessYouLikeSwiseCellIdentifier];

        [self registerClass:[SNHHZMainSliderImageCell class]  forCellReuseIdentifier:SNHHZMainSliderImageCellIdentifier];
        [self registerClass:[SNHHZSliderIconCell class]  forCellReuseIdentifier:SNHHZSliderIconCellIdentifier];
        
        
        [self registerClass:[SNHHZVoucherADCell class]  forCellReuseIdentifier:SNHHZVoucherADCellIdentifier];
        [self registerClass:[SNHHZOneADCell class]  forCellReuseIdentifier:SNHHZOneADCellIdentifier];
        [self registerClass:[SNHHZTowADCell class]  forCellReuseIdentifier:SNHHZTwoADCellIdentifier];
        [self registerClass:[SNHHZThreeADCell class]  forCellReuseIdentifier:SNHHZThreeADCellIdentifier];
        [self registerClass:[SNHHZFourADCell class]  forCellReuseIdentifier:SNHHZFourADCellIdentifier];

        [self registerClass:[SNHHZHotSaleCell class]  forCellReuseIdentifier:SNHHZMainHotSaleCellIdentifier];
        
        [self registerClass:[SNHHZParentsMustBuyCell class]  forCellReuseIdentifier:SNHHZParentsMustBuyCellIdentifier];
        [self registerClass:[SNMKHHZParentsMustBuyCell class]  forCellReuseIdentifier:SNMKHHZParentsMustBuyCellIdentifier];
        
        [self registerClass:[SNHHZSliderProductCell class]  forCellReuseIdentifier:SNHHZSliderProductCellIdentifier];
        [self registerClass:[SNHHZVerticalArrangedProductCell class]  forCellReuseIdentifier:SNHHZVerticalArrangedProductCellIdentifier];
        [self registerClass:[SNHHZGlobalBestCell class]  forCellReuseIdentifier:SNHHZGlobalBestCellIdentifier];
        
        
        
        [self registerClass:[SNHHZThemePavilionCell class]  forCellReuseIdentifier:SNHHZThemePavilionCellIdentifier];
        [self registerClass:[SNHHZGoodShopSelectCell class]  forCellReuseIdentifier:SNHHZGoodShopSelectCellIdentifier];
        [self registerClass:[SNHHZTeachYouToBuyCell class]  forCellReuseIdentifier:SNHHZTeachYouToBuyCellIdentifier];
        [self registerClass:[SNHHZVideoCell class]  forCellReuseIdentifier:SNHHZVideoCelllIdentifier];
        [self registerClass:[SNHHZTowFourADCell class]  forCellReuseIdentifier:SNHHZTowFourADCellIdentifier];
        
        [self registerClass:[SNHHZSpaceCell class]  forCellReuseIdentifier:SNHHZJGFCellIdentifier];

        [self registerClass:[SNHHZTitleCell class]  forCellReuseIdentifier:SNHHZCHMODIdentifier];
        [self registerClass:[SNHHZCXAdCell class]  forCellReuseIdentifier:SNHHZCXADIdentifier];
        [self registerClass:[SNHHZIntelligentCell class]  forCellReuseIdentifier:SNHHZAttentionIdentifier];
        [self registerClass:[SNHHZScrollADCell class]  forCellReuseIdentifier:SNHHZADScrollIdentifier];
        
        [self registerClass:[SNHHZToptabCell class] forCellReuseIdentifier:SNHHZToptabCellIdentifier];
        [self registerClass:[SNHHZHistoryLowCell class] forCellReuseIdentifier:SNHHZHistoryLowCellIdentifier];
        [self registerClass:[SNHHZMySameageCell class] forCellReuseIdentifier:SNHHZMySameageCellIdentifier];
        [self registerClass:[SNHHZMyStoreCell class] forCellReuseIdentifier:SNHHZMyStoreCellIdentifier];
        
        //TODO wht
        [self setupMainView];
    }
    return self;
}

- (void)setupMainView{
    __weak typeof(self)weakSelf = self;
    self.mj_header = [SNDIYNormalHeader headerWithRefreshingBlock:^{
        
        if (weakSelf.refreshAllVCBlock) {
            weakSelf.refreshAllVCBlock();
        }
    }];
    
    SNDIYNormalFooter *footer = [SNDIYNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    footer.noDataTextString = @"我是有底线的";
    [footer setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.mj_footer = footer;
    
    
//    [self.superview addSubview:self.sliderIconView];
}

- (void)setupIconView {
    if (self.sliderIconView.superview == nil) {
        [self.superview addSubview:self.sliderIconView];
    }
    
    CGFloat iconViewHeight = [SNHHZSliderIconView getSNHHZSliderIconViewHeight:self.hhzMainViewModel.myIconArr];
    CGRect rect = self.sliderIconView.frame;
    rect.size.height = iconViewHeight;
    self.sliderIconView.frame = rect;
    
    [self.sliderIconView updateSliderIconCellWithDto:self.hhzMainViewModel.myIconArr andBg:self.hhzTabViewModel.cmsDataDto.localIconFloor.myIconBgFloorArray];
}

#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 有下拉广告时不处理
    if (self.isShowSliderAd) {
        return ;
    }
    
    CGFloat iconViewHeight = [SNHHZSliderIconView getSNHHZSliderIconViewHeight:self.hhzMainViewModel.myIconArr];
    CGFloat iconCellHeight = [SNHHZSliderIconCell getSNHHZSliderIconViewHeight:self.hhzMainViewModel.myIconArr];
    
    // 计算临界值 Get375Height(130)：banner高度  iconViewHeight：iconView高度  iconCellHeight：iconCell高度  64：nav高度 40：sement高度

    CGFloat criticalPoint = self.sliderIconCellY + iconCellHeight - iconViewHeight - 64 - 40;
//    criticalPoint = criticalPoint > 90? criticalPoint: 130;
    // 下拉
    if (scrollView.contentOffset.y < criticalPoint ) {
        self.sliderIconView.hidden = YES;
    }
    
    // 上拉
    if (scrollView.contentOffset.y > criticalPoint && criticalPoint > 0) {
        self.sliderIconView.hidden = NO;
    }
}


#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
//    if (self.hhzTabViewModel.cmsCellSequence) {
//        return [self.hhzTabViewModel.cmsCellSequence count]>0?[self.hhzTabViewModel.cmsCellSequence count]:0;
//    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

//    if (section == 1) {
//        NSArray *array = self.hhzMainViewModel.myIconArr;
//
//        [self.sliderIconView updateSliderIconCellWithDto:array andBg:self.hhzTabViewModel.cmsDataDto.localIconFloor.myIconBgFloorArray];
//
//        return self.sliderIconView;
//    }
//    else
        return nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) {
//        return self.sliderIconIndex;
//    }
//    else
//        return ([self.cellSequence count] - self.sliderIconIndex)>0?([self.cellSequence count] - self.sliderIconIndex):0;

    return [self.cellSequence count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 1) {
//        NSArray *dataArray = self.hhzMainViewModel.myIconArr;
//        if (dataArray.count>0)
//            return Get375Height(63);
//        else
//            return 0;
//
//    }
//    else
        return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *currFloorDic = nil;
    currFloorDic =     [self.cellSequence objectAtIndex:indexPath.row];
    
//    if (indexPath.section == 0) {
//        currFloorDic =     [self.cellSequence objectAtIndex:indexPath.row];
//    }
//    else
//        currFloorDic =     [self.cellSequence objectAtIndex:indexPath.row + self.sliderIconIndex];
    
    
    CGFloat height2 = [[currFloorDic objectForKey:cms_cell_height_type] integerValue];
    
//    SNHHZMainSectionType currentSection = [[currFloorDic objectForKey:cms_squence_key_type] floatValue];
//    CGFloat height = 0.0f;
//    switch (currentSection) {
//        case SNHHZMainSectionTypeChildInfo:
//            height = Get375Height(44);
//            break;
//        case SNHHZMainSectionTypeSliderImage:    ///**
//        {
//            if (self.isShowSliderAd)
//                height = Get375Height(365);
//            else
//                height = Get375Height(130);
//
//            break;
//        }
//        case SNHHZMainSectionTypeSliderIcon:
//            height = [SNHHZSliderIconCell getSNHHZSliderIconViewHeight:self.hhzMainViewModel.myIconArr];
//            break;
//        case SNHHZMainSectionTypeVoucherAD:
//            height = Get375Height(90);
//            break;
//        case SNHHZMainSectionTypeOneAD:
//            height = Get375Height(90);
//            break;
//        case SNHHZMainSectionTypeTwoAD:
//            height = Get375Height(90);
//            break;
//        case SNHHZMainSectionTypeThreeAD:
//            height = Get375Height(122);
//            break;
//        case SNHHZMainSectionTypeFourAD:
//            height = Get375Height(122);
//            break;
//        case SNHHZMainSectionTypeMustBuy:
//        {
//            // 宝宝信息
//            if (self.isBabyTab &&
//                ((self.currentBabyIndex == 1 && self.babyInfo) ||
//                 (self.currentBabyIndex == 2 && self.baby2Info)))
//            {
//                height += Get375Height(86);
//            }
//
//            NSArray *historyLowArray,*moomsBuyArray,*moomsStrawArray;
//            historyLowArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase2_completeData_Array);
//            moomsBuyArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase3_completeData_Array);
//            moomsStrawArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, getRecGoodsArray_completeData_Array);
//
//            // 今日历史新低
//            if (historyLowArray.count >= 3) {
//                height += [SNMKHHZLowestPriceView LowestPriceViewHeight];
//            }
//
//            // 妈妈都买什么
//            if (moomsStrawArray.count >= 2) {
//                if ((self.currentBabyIndex == 1 && self.babyInfo.ageFromatStr.length > 0) ||
//                    (self.currentBabyIndex == 2 && self.baby2Info.ageFromatStr.length > 0)) {
//                    height += Get375Height(130);
//                }
//            }
//
//            // 宝妈都在囤
//            if (moomsBuyArray.count >= 2) {
//                height += Get375Height(130);
//            }
//        }
//            break;
//        case SNHHZMainSectionTypeSliderProduct:    ////**  3 ---
//        {
//            if (self.hhzMainViewModel.myOffenByProductArray.count < 3 && self.hhzMainViewModel.myOffenByProductArray.count > 0) {
//                height = Get375Height(125*self.hhzMainViewModel.myOffenByProductArray.count);
//            }
//            else
//                height = Get375Height(162);
//        }
//            break;
//        case SNHHZMainSectionTypeGlobalBest:
//            height = Get375Height(155);
//            break;
//        case SNHHZMainSectionTypeThemePavilion:   //主题馆:
//            height = Get375Height(271);
//            break;
//        case SNHHZMainSectionTypeGoodShopSelect:   //好店精选
//            height = Get375Height(250);
//            break;
//        case SNHHZMainSectionTypeTeachYouToBuy:   //教你买    动态高度**
//        {
//            height = [SNHHZTeachYouToBuyCell getTeachYouToBuyCellHeightWithContentTextString:self.hhzMainViewModel.pageNewDto.newsContent];
//        }
//            break;
//        case SNHHZMainSectionTypeVideo:   //视频
//            height = Get375Height(327);
//            break;
//        case SNHHZMainSectionTypeJGF:   //jiangefu
//            height = Get375Height(10);
//            break;
//        case SNHHZMainSectionTypeComhd:   //标题
//            height = Get375Height(40);
//            break;
//        case SNHHZMainSectionTypeGuessYouLike:
//        {
////            NSInteger guessBeginIndex = indexPath.row - self.guessIndex + self.sliderIconIndex;
//            NSInteger guessBeginIndex = indexPath.row - self.guessIndex;
//
//            if ((guessBeginIndex+1)% 5 != 0)
//                height = Get375Height(335);
//            else
//                height = Get375Height(178);
//        }
//            break;
//        case SNHHZMainSectionTypeMyTf:   //2大4小
//            height = Get375Height(145);
//            break;
//        case SNHHZMainSectionTypeHotSale:  //热卖
//            height = Get375Height(165);
//            break;
//        case SNHHZMainSectionTypeHtGuanggao:   //横通广告
//            height = Get375Height(90);
//            break;
//        case SNHHZMainSectionTypeCX_AD:   //单图横通广告
//            height = Get375Height(90);
//            break;
//        case SNHHZMainSectionTypeIntelligent:   //单图横通广告
//            height = Get375Height(210);
//            break;
//        case SNHHZMainSectionTypeMy_690_184:   //轮播广告
//            height = Get375Height(100);
//            break;
//        case SNHHZMainSectionTypeHistorylow:   //今日历史新低
//            height = [SNHHZHistoryLowCell getSNHHZHistoryLowCellHeight];
//            break;
//        case SNHHZMainSectionTypeMyStore:   //宝妈都在囤
//            height = [SNHHZMyStoreCell getSNHHZMyStoreCellHeight];
//            break;
//        case SNHHZMainSectionTypeMySameage:   //妈妈买什么
//            height = [SNHHZMyStoreCell getSNHHZMyStoreCellHeight];
//            break;
//        case SNHHZMainSectionTypeMyToptab:
//            height = [SNHHZToptabCell getSNHHZToptabCellHeight];
//            break;
//        default:
//            height = Get375Height(44);
//            break;
//    }
    
    return height2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *currFloorDic = nil;
    currFloorDic =     [self.cellSequence objectAtIndex:indexPath.row];

    
//    if (indexPath.section == 0) {
//        currFloorDic =     [self.cellSequence objectAtIndex:indexPath.row];
//    }
//    else
//        currFloorDic =     [self.cellSequence objectAtIndex:indexPath.row + self.sliderIconIndex];
    
    SNHHZMainSectionType currentSection = [[currFloorDic objectForKey:cms_squence_key_type] integerValue];
    NSInteger subIndex = [[currFloorDic objectForKey:cms_squence_key_subIndex] integerValue];
    switch (currentSection) {
        case SNHHZMainSectionTypeChildInfo:
        {
            SNHHZChildInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZMainChildInfoCellIdentifier];
            SNMKHHZSingleBabyInfoDto *currBabyInfo = self.currentBabyIndex == 1? self.babyInfo:self.baby2Info;
            [cell updataData:currBabyInfo];
            __weak typeof(self) weakSelf = self;

            cell.gotoSpecialBlock = ^{
                if (weakSelf.goBabyTabVCBlock)
                    weakSelf.goBabyTabVCBlock();
            };
            return cell;
        }
            break;
        case SNHHZMainSectionTypeSliderImage:
        {
            SNHHZMainSliderImageCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZMainSliderImageCellIdentifier];
            [cell updateMainSliderImageCellWithImageURLStringArray:self.hhzTabViewModel.cmsDataDto.newLbFloor.newlbFloorArray];
            //设置bnner楼层indexpath
            self.bannerIndexPath = indexPath;
            return cell;
        }
            break;
        case SNHHZMainSectionTypeMy_690_184:
        {
            SNHHZScrollADCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZADScrollIdentifier];
            [cell updateWithFloorDTO:self.hhzTabViewModel.cmsDataDto.my_690_184ADDtoArr];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeSliderIcon:
        {
            SNHHZSliderIconCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZSliderIconCellIdentifier];
            NSArray *array = self.hhzMainViewModel.myIconArr;
            [cell updateSliderIconCellWithDto:array andBg:self.hhzTabViewModel.cmsDataDto.localIconFloor.myIconBgFloorArray];
            return cell;
            
//            UITableViewCell * baseCell = [tableView dequeueReusableCellWithIdentifier:SNHHZMainCommonCellIdentifier];
//            baseCell.textLabel.textColor = [UIColor clearColor];
//            return baseCell;
        }
            break;
        case SNHHZMainSectionTypeHotSale:   //热卖
        {
            SNHHZHotSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZMainHotSaleCellIdentifier];
            [cell updateHotSaleCellWithDto:self.hhzTabViewModel.cmsDataDto.my_hotSaleDTO];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeVoucherAD:
        {
            SNHHZVoucherADCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZVoucherADCellIdentifier];
            __weak typeof(self) weakSelf = self;
            [cell updateVoucherADCellWithDto:self.hhzTabViewModel.cmsDataDto.getQuanDto getQuanBlock:^(NSString *actId, NSString *actKey, SNHHZVoucherCollectionCell *Quancell) {
//                [weakSelf.hhzMainViewModel getQuanWithActId:actId ActKey:actKey QuanCell:Quancell];
                
                SN_GETCOUPONCENTERService(couponCenterService);
                [couponCenterService doFreeDrawWithActID:actId actkey:actKey actType:@"" completionBlock:^(BOOL isSuccess, NSString *erroCode, NSString *erroMsg, NSDictionary *item) {
                    if (isSuccess) {
                        [Quancell showHaveGetedView];
                    }else{
                        // UOM新埋点
                        SNMB_LOGIN_GETUSERCENTER(userInfo);
                        SNMB_ADDRESS_GETSNADDRESSSINGLETON(addressInfo)
                        [weakSelf reportStatisticsFailedWithMoudle:@"红孩子首页_优惠券" errorCode:@"hhz-appsy12-20033" errorDetail:[NSString stringWithFormat:@"fail_%@_%@", IsNilOrNull(userInfo.custNum) ? @"" : userInfo.custNum, IsNilOrNull(addressInfo.cityName) ? @"" : addressInfo.cityName] fromVCName:NSStringFromClass([weakSelf.parentVC class])];
                    }
                }];
                
            } unloginBlock:^{
                weakSelf.loginAndRefreshVCBlock();
            }];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeHtGuanggao:   //横通guang gao
        {
            SNHHZOneADCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZOneADCellIdentifier];
            SNHHZMainSectionADDto  *currSection = self.hhzTabViewModel.cmsDataDto.hengtongADDto;
            [cell updateOneADCellWithDto:currSection];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeCX_AD:   //单图横通guang gao
        {
            SNHHZCXAdCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZCXADIdentifier];
            SNHHZPOPImgDTO  *currSection = [self.hhzTabViewModel.cmsDataDto.cxhengtongADDtoArr safeObjectAtIndex:subIndex];
            [cell updateOneADCellWithDto:currSection];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeOneAD:
        {
            SNHHZOneADCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZOneADCellIdentifier];
            SNHHZMainSectionADDto  *currSection = [self.hhzTabViewModel.cmsDataDto.oneADDtoArr safeObjectAtIndex:subIndex];
            [cell updateOneADCellWithDto:currSection];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeTwoAD:
        {
            SNHHZTowADCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZTwoADCellIdentifier];
            SNHHZMainSectionADDto  *currSection = [self.hhzTabViewModel.cmsDataDto.twoADDtoArr safeObjectAtIndex:subIndex];
            [cell updateTowADCellWithDto:currSection];
            
            return cell;
        }
            break;
        case SNHHZMainSectionTypeThreeAD:
        {
            SNHHZThreeADCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZThreeADCellIdentifier];
            
            SNHHZMainSectionADDto  *currSection = [self.hhzTabViewModel.cmsDataDto.threeADDtoArr safeObjectAtIndex:subIndex];
            [cell updateThreeADCellWithDto:currSection];
            
            return cell;
        }
            break;
        case SNHHZMainSectionTypeFourAD:
        {
            SNHHZFourADCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZFourADCellIdentifier];
            SNHHZMainSectionADDto  *currSection = [self.hhzTabViewModel.cmsDataDto.fourADDtoArr safeObjectAtIndex:subIndex];
            [cell updateFourADCellWithDto:currSection];
            
            return cell;
        }
            break;
        case SNHHZMainSectionTypeMustBuy:
        {
            SNMKHHZParentsMustBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:SNMKHHZParentsMustBuyCellIdentifier];
            
            NSArray *historyLowArray,*moomsBuyArray,*moomsStrawArray;
            historyLowArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase2_completeData_Array);
            moomsBuyArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase3_completeData_Array);
            moomsStrawArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, getRecGoodsArray_completeData_Array);
            __weak typeof(self) weakSelf = self;
            cell.choiceBabyBlock = ^(NSInteger babyIndex) {
                if (babyIndex == 1) {
                    [weakSelf getmoduleMergedDataFromServer:weakSelf.moudleBaby1ArgDic];
                    [weakSelf CustomEventCollection:@"680002001"];
                    [weakSelf reportSpmClickEventWithPageId:@"680" modId:@"2" eleId:@"1"];
                }
                if (babyIndex == 2) {
                    [weakSelf getmoduleMergedDataFromServer:weakSelf.moudleBaby2ArgDic];
                    [weakSelf CustomEventCollection:@"680002002"];
                    [weakSelf reportSpmClickEventWithPageId:@"680" modId:@"2" eleId:@"2"];
                }
                weakSelf.currentBabyIndex = babyIndex;
            };
            cell.gotoGroupUpBlock = ^{
                if (weakSelf.goBabyTabVCBlock)
                {
                    weakSelf.goBabyTabVCBlock();
                    [weakSelf CustomEventCollection:@"680002005"];
                    [weakSelf reportSpmClickEventWithPageId:@"680" modId:@"2" eleId:@"5"];
                }
            };
            [cell updataBabyData:self.babyInfo andBabySecond:self.baby2Info andBabyIndex:self.currentBabyIndex andIsBabyItem:self.isBabyTab];
            
//            if (historyLowArray.count>=3 && (moomsBuyArray.count>=2 || moomsStrawArray.count>=2)) {
                if (self.currentBabyIndex == 1)
                    [cell updateParentsMustBuyCellWithHistoryLowProductTop3Array:historyLowArray moomsStraDtoArray:moomsStrawArray moomsBuyDtoArray:moomsBuyArray babyDic:self.babyInfo];
                else
                    [cell updateParentsMustBuyCellWithHistoryLowProductTop3Array:historyLowArray moomsStraDtoArray:moomsStrawArray moomsBuyDtoArray:moomsBuyArray babyDic:self.baby2Info];
//            }
            
            return cell;
        }
            break;
        case SNHHZMainSectionTypeSliderProduct: //我的常购    SNHHZSliderProductCell    SNHHZVerticalArrangedProductCell（少于3）
        {
            //两种情况
            if (self.hhzMainViewModel.myOffenByProductArray.count<3 && self.hhzMainViewModel.myOffenByProductArray.count>0) {
                SNHHZVerticalArrangedProductCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZVerticalArrangedProductCellIdentifier];
                [cell updateVerticalArrangedProductCellWithDtoArray:self.hhzMainViewModel.myOffenByProductArray];
                return cell;
            }else{
                SNHHZSliderProductCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZSliderProductCellIdentifier];
                [cell updateSliderProductCellWithDtoArray:self.hhzMainViewModel.myOffenByProductArray];
                return cell;
            }
        }
            break;
        case SNHHZMainSectionTypeGlobalBest:
        {
            SNHHZGlobalBestCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZGlobalBestCellIdentifier];
            NSArray *globalBestArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, paramsBiz_completeData_Array);
            [cell updateGlobalBestCellWithDtoArray:globalBestArray andGlobalInfo:self.hhzTabViewModel.cmsDataDto.globalFloor];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeThemePavilion:
        {
            SNHHZThemePavilionCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZThemePavilionCellIdentifier];
            NSArray *globalBestArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, paramsBiz2_completeData_Array);
            [cell updateThemePavilionCellWithDto:globalBestArray];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeGoodShopSelect:
        {
            SNHHZGoodShopSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZGoodShopSelectCellIdentifier];
            NSArray *goodShopArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, paramsBiz3_completeData_Array);
            [cell updateGoodShopSelectCellWithDto:goodShopArray];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeTeachYouToBuy:
        {
            SNHHZTeachYouToBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZTeachYouToBuyCellIdentifier];
            NSArray *recommandNewArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase4_completeData_Array);
   
            if (self.currentBabyIndex == 1)
                [cell updateTeachYouToBuyCellWithDto:self.hhzMainViewModel.pageNewDto andTeachBuyBg:nil andTeachBuyRecommand:recommandNewArray andAge:self.babyInfo.ageFromatStr];
            else
                [cell updateTeachYouToBuyCellWithDto:self.hhzMainViewModel.pageNewDto andTeachBuyBg:nil andTeachBuyRecommand:recommandNewArray andAge:self.baby2Info.ageFromatStr];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeVideo:
        {
            SNHHZVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZVideoCelllIdentifier];
            [cell updateVideoCellWithDto:self.hhzTabViewModel.cmsDataDto.my_spDTO];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeIntelligent:
        {
            SNHHZIntelligentCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZAttentionIdentifier];
            NSArray *attentionArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, my_attention_Array);
            __weak typeof(self) weakSelf = self;
            [cell updateAttentionCellWithUserArray:attentionArray andIntelligentDto:self.hhzTabViewModel.cmsDataDto.attentionIDDto  unloginBlock:^{
                if (weakSelf.loginAndRefreshVCBlock)
                    weakSelf.loginAndRefreshVCBlock();
            } didBlock:^{
                if (weakSelf.backRefreshVCBlock)
                    weakSelf.backRefreshVCBlock();
            }];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeMyTf:
        {
            SNHHZTowFourADCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZTowFourADCellIdentifier];
            [cell updateTowFourADCellWithDto:self.hhzTabViewModel.cmsDataDto.my_tfDTO];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeJGF:
        {
            SNHHZSpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZJGFCellIdentifier];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeComhd:
        {
            SNHHZTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZCHMODIdentifier];
            SNHHZCMSModuleDTO *currentData = [currFloorDic objectForKey:cms_squence_key_data];

            [cell updateOneADCellWithDto:currentData];
            return cell;
        }
            break;
        case SNHHZMainSectionTypeGuessYouLike:
        {
            
//            NSInteger guessBeginIndex = indexPath.row - self.guessIndex + self.sliderIconIndex ;
            NSInteger guessBeginIndex = indexPath.row - self.guessIndex;

            NSInteger zsCount = (guessBeginIndex+1) /5;
            NSInteger ysCount = (guessBeginIndex+1) %5;
            NSInteger arrIndex = zsCount*9 + ysCount*2 - 1;
            
            if ((guessBeginIndex+1)% 5 != 0) {
                SNHHZGuessYouLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZGuessYouLikeCellIdentifier];
                id tmpDto = [self.hhzMainViewModel.guessYouLikeArr safeObjectAtIndex:arrIndex -1];
                [cell setLeftData:tmpDto andViewIndex:arrIndex -1];
                
                if (arrIndex < self.hhzMainViewModel.guessYouLikeArr.count) {
                    id tmpRightDto = [self.hhzMainViewModel.guessYouLikeArr safeObjectAtIndex:arrIndex ];
                    [cell setRightData:tmpRightDto andViewIndex:arrIndex];
                }
                else
                {
                    [cell hiddenRightView];
                }
                return cell;
            }
            else
            {
                SNHHZGuessYouLikeSwiseCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZGuessYouLikeSwiseCellIdentifier];
                id tmpDto = [self.hhzMainViewModel.guessYouLikeArr safeObjectAtIndex:zsCount*9 - 1];
                [cell updataData:tmpDto andViewIndex:zsCount*9 - 1];
                return cell;
            }
        }
            break;
        case SNHHZMainSectionTypeHistorylow:
        {
            NSArray *historyLowArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase2_completeData_Array);
            SNHHZHistoryLowCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZHistoryLowCellIdentifier];
            [cell updateHistoryLowWithProductsArray:historyLowArray];
            
            return cell;
        }
            break;
        case SNHHZMainSectionTypeMySameage:
        {
            NSArray *goodsArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, getRecGoodsArray_completeData_Array);
            SNHHZMySameageCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZMySameageCellIdentifier];
            [cell updateParentsMustBuyCellWithMoomsStraDtoArray:goodsArray babyDic:self.currentBabyIndex == 1 ? self.babyInfo : self.baby2Info];
            
            return cell;
        }
            break;
        case SNHHZMainSectionTypeMyStore:
        {
            NSArray *goodsArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase3_completeData_Array);
            SNHHZMyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZMyStoreCellIdentifier];
            [cell updateParentsMustBuyCellWithMoomsStraDtoArray:goodsArray babyDic:self.currentBabyIndex == 1 ? self.babyInfo : self.baby2Info];
            
            return cell;
        }
            break;
        case SNHHZMainSectionTypeMyToptab:
        {
            SNHHZToptabCell *cell = [tableView dequeueReusableCellWithIdentifier:SNHHZToptabCellIdentifier];
            [cell updataBabyData:self.babyInfo andBabySecond:self.baby2Info andBabyIndex:self.currentBabyIndex andIsBabyItem:self.isBabyTab];
            __weak typeof(self) weakSelf = self;
            cell.choiceBabyBlock = ^(NSInteger babyIndex) {
                if (babyIndex == 1) {
                    [weakSelf getmoduleMergedDataFromServer:weakSelf.moudleBaby1ArgDic];
                    [weakSelf CustomEventCollection:@"680002001"];
                    [weakSelf reportSpmClickEventWithPageId:@"680" modId:@"2" eleId:@"1"];
                }
                if (babyIndex == 2) {
                    [weakSelf getmoduleMergedDataFromServer:weakSelf.moudleBaby2ArgDic];
                    [weakSelf CustomEventCollection:@"680002002"];
                    [weakSelf reportSpmClickEventWithPageId:@"680" modId:@"2" eleId:@"2"];
                }
                weakSelf.currentBabyIndex = babyIndex;
            };
            cell.gotoGroupUpBlock = ^{
                if (weakSelf.goBabyTabVCBlock)
                {
                    weakSelf.goBabyTabVCBlock();
                    [weakSelf CustomEventCollection:@"680002005"];
                    [weakSelf reportSpmClickEventWithPageId:@"680" modId:@"2" eleId:@"5"];
                }
            };
            
            return cell;
        }
            break;
        default:
        {
            UITableViewCell * baseCell = [tableView dequeueReusableCellWithIdentifier:SNHHZMainCommonCellIdentifier];
            baseCell.textLabel.textColor = [UIColor blackColor];
            return baseCell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell isKindOfClass:[SNHHZMainCommonCell class]]) {
        //重置原始位移
//        [((SNHHZMainCommonCell *)cell).collection setContentOffset:CGPointMake(0.0f, 0.0f)];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

//- (void)reloadData{
////    [self reloadData];
//}

- (void)refreshWithIndex:(NSInteger)index andMergeDic:(NSDictionary *)moudleMergedArgDic withViewModel:(SNHHZMainViewModel *)viewModel{
    
    [self scroolViewToTop];
    
    self.hhzMainViewModel.toastBlock = viewModel.toastBlock;
    self.hhzMainViewModel.babyInfoDto = viewModel.babyInfoDto;
    self.hhzMainViewModel.myOffenByProductArray = viewModel.myOffenByProductArray;
    //    self.hhzMainViewModel.isNew = viewModel.isNew;
    
    self.tableIndex = index;
    self.moudleMergedArgDic = moudleMergedArgDic;
    //    [self.mj_header beginRefreshing];
    
    
    [self refreshData];
}


//- (void)refreshWithIndexNoScroolToTop:(NSInteger)index andMergeDic:(NSDictionary *)moudleMergedArgDic withViewModel:(SNHHZMainViewModel *)viewModel
//{
//    self.hhzMainViewModel.toastBlock = viewModel.toastBlock;
//    self.hhzMainViewModel.babyInfoDto = viewModel.babyInfoDto;
//    self.hhzMainViewModel.myOffenByProductArray = viewModel.myOffenByProductArray;
//    //    self.hhzMainViewModel.isNew = viewModel.isNew;
//    
//    self.tableIndex = index;
//    self.moudleMergedArgDic = moudleMergedArgDic;
//    //    [self.mj_header beginRefreshing];
//    
//    
//    [self getmoduleFirthDataFromServer:moudleMergedArgDic];
//}



//合并接口2数据
-(void)getmoduleMergedDataFromServer:(NSDictionary *)moudleDic
{
    [self reportStatisticsStartWithMoudle:@"红孩子母婴原生频道合并接口二" fromVC:self.parentVC];

    __weak typeof(self) weakSelf = self;
    
    self.hhzMainViewModel.moduleMergedDataBlock = ^(BOOL isSuccess, NSString *erroCode, NSString *erroMsg) {
        
        if (isSuccess) {
            
            //插入icon数据
            [weakSelf.hhzMainViewModel insertICONToMyIconArr:weakSelf.hhzTabViewModel.cmsDataDto.localIconFloor.myIconFloorArray];
            //猜你喜欢数据插入
            [weakSelf.hhzMainViewModel insertGuessYouLikeProduct:weakSelf.hhzTabViewModel.cmsDataDto.guessLikeFloor.guessLikeFloorArray];
            
            [weakSelf getPageNewFromServer];
            
            //刷新券数据
            [weakSelf.hhzTabViewModel getVourcherStatus:^(BOOL isSuccess) {   //获取券状态
                [weakSelf reloadMainTable];
            }];
            //获取达人状态
            [weakSelf.hhzMainViewModel getAttentionFollowStatus:weakSelf.hhzTabViewModel.cmsDataDto.attentionIDDto.attentionIDStr andBlock:^(BOOL isSuccess) {
                [weakSelf reloadMainTable];
            }];
            //查看是否是新人
            [weakSelf checkIsNew];
            [weakSelf reportStatisticsSuccessWithMoudle:@"红孩子母婴原生频道合并接口二" fromVC:weakSelf.parentVC];

            
        }else{
            //插入icon数据
            [weakSelf.hhzMainViewModel insertICONToMyIconArr:weakSelf.hhzTabViewModel.cmsDataDto.localIconFloor.myIconFloorArray];
            [weakSelf reportStatisticsFailedWithMoudle:@"红孩子母婴原生频道合并接口二" errorCode:@"0002" errorDetail:@"获取智能推荐及达人信息整体数据失败" fromVC:weakSelf.parentVC];

        }
        //是否展示下拉广告
        [weakSelf isShowSliderAdView];
        [weakSelf reloadMainTable];
        [weakSelf isJumpHotCell];
        [weakSelf.mj_header endRefreshing];
        weakSelf.mj_footer.state = MJRefreshStateNoMoreData;
        [weakSelf addTwoLineToTableFooterView];
        
        //更新推荐icon浮云视图
        [weakSelf setupIconView];
    };
    [self.mj_header endRefreshing];
    [self.hhzMainViewModel fetchModuleMergedService:moudleDic];
    
    
}




-(void)reloadMainTable
{
    [self configCellSequence];
    [self reloadData];
//    [self isJumpHotCell];
    
}

-(void)isJumpHotCell
{
    
//    [self scrollToRowAtIndexPath:self.hotCellY atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    if (!self.isJumpToHot && self.tableIndex == 0 && self.hotCellY.row > 0 ) {
        if (!IsStrEmpty(self.hhzTabViewModel.suggestProduct1.sugGoodsCode) && !IsStrEmpty(self.hhzTabViewModel.suggestProduct1.vendorId))
        {
            self.isJumpToHot = YES;
            [self scrollToRowAtIndexPath:self.hotCellY atScrollPosition:UITableViewScrollPositionTop animated:NO];

        }
    }
}

-(void)configCellSequence
{
    NSInteger currcellIndex = 0;
    NSInteger currcellY = 0;    //当前cell的y坐标
    [self.cellSequence removeAllObjects];
//    self.sliderIconIndex = 0;    //记录浮层在哪一行
    self.guessIndex = 0;          //猜你喜欢楼层索引
    self.hotCellY = [NSIndexPath indexPathForRow:0 inSection:0];
    self.sliderIconCellY = 0;
    SNHHZMainSectionType tempSection = -1;       // 记录上一个section
    for (NSInteger i = 0; i < self.hhzTabViewModel.cmsCellSequence.count; ++i) {
        NSDictionary *currFloorTmpDic =     [self.hhzTabViewModel.cmsCellSequence objectAtIndex:i];
        NSMutableDictionary *currFloorDic = [[NSMutableDictionary alloc] initWithDictionary:currFloorTmpDic];
        SNHHZMainSectionType currentSection = [[currFloorDic objectForKey:cms_squence_key_type] integerValue];
        NSInteger subIndex = [[currFloorDic objectForKey:cms_squence_key_subIndex] integerValue];
        
        CGFloat height = 0.0f;
        
        NSString *moduleMergedArgDicKey = @"";
        NSString *moduleMergedArgDicKey2 = @"";
        NSString *moduleMergedArgDicKey3 = @"";
     
        switch(currentSection) {
            case SNHHZMainSectionTypeChildInfo:
            {
                if (self.isBabyTab) {
                    tempSection = SNHHZMainSectionTypeChildInfo;
                    [currFloorDic setObject:@(Get375Height(44)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(44);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
                
            case SNHHZMainSectionTypeSliderIcon://8个icon   //
            {
                NSArray *dataArray = self.hhzMainViewModel.myIconArr;
                if (dataArray.count>0) {
                    tempSection = SNHHZMainSectionTypeSliderIcon;
                    height = [SNHHZSliderIconCell getSNHHZSliderIconViewHeight:self.hhzMainViewModel.myIconArr];
                    [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                    self.sliderIconCellY = currcellY;
                    currcellY += height;
                    [self.cellSequence addObject:currFloorDic];
//                    self.sliderIconIndex = currcellIndex;
                    currcellIndex += 1;
                }
                
            }
                break;
            case SNHHZMainSectionTypeGlobalBest://全球优品
            {
                NSArray *dataArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, paramsBiz_completeData_Array);
                if (dataArray.count > 0) {
                    tempSection = SNHHZMainSectionTypeGlobalBest;
                    [currFloorDic setObject:@(Get375Height(155)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(155);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeThemePavilion://主题馆
            {
                NSArray *dataArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, paramsBiz2_completeData_Array);
                if (dataArray.count>0) {
                    tempSection = SNHHZMainSectionTypeThemePavilion;
                    [currFloorDic setObject:@(Get375Height(271)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(271);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeGoodShopSelect://好店精选
            {
                moduleMergedArgDicKey = paramsBiz3_completeData_Array;
                NSArray *dataArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, moduleMergedArgDicKey);
                if (dataArray.count>0) {
                    tempSection = SNHHZMainSectionTypeGoodShopSelect;
                    [currFloorDic setObject:@(Get375Height(250)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(250);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeMustBuy://家长必买（包括 历史新低3个商品，宝妈都在囤，同龄妈妈都在买）  尼玛什么鬼名字，怎么区分。。。。
            {
                moduleMergedArgDicKey = dyBase2_completeData_Array;
                moduleMergedArgDicKey2 = dyBase3_completeData_Array;
                moduleMergedArgDicKey3 = getRecGoodsArray_completeData_Array;
                NSArray *historyLowArray,*moomsBuyArray,*moomsStrawArray;
                historyLowArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, moduleMergedArgDicKey);
                moomsBuyArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, moduleMergedArgDicKey2);
                moomsStrawArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, moduleMergedArgDicKey3);
                
                if (historyLowArray.count >= 3 || moomsBuyArray.count >=2 || moomsStrawArray.count>=2 || self.isBabyTab) {
                    tempSection = SNHHZMainSectionTypeMustBuy;
                    // 宝宝信息
                    
                    if (self.isBabyTab &&
                        ((self.currentBabyIndex == 1 && self.babyInfo) ||
                         (self.currentBabyIndex == 2 && self.baby2Info)))
                    {
                        height = Get375Height(86);
                    }
                    
                    NSArray *historyLowArray,*moomsBuyArray,*moomsStrawArray;
                    historyLowArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase2_completeData_Array);
                    moomsBuyArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase3_completeData_Array);
                    moomsStrawArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, getRecGoodsArray_completeData_Array);
                    
                    // 今日历史新低
                    if (historyLowArray.count >= 3) {
                        height += [SNMKHHZLowestPriceView LowestPriceViewHeight];
                    }
                    
                    // 妈妈都买什么
                    if (moomsStrawArray.count >= 2) {
                        if ((self.currentBabyIndex == 1 && self.babyInfo.ageFromatStr.length > 0) ||
                            (self.currentBabyIndex == 2 && self.baby2Info.ageFromatStr.length > 0)) {
                            height += Get375Height(130);
                        }
                    }
                    
                    // 宝妈都在囤
                    if (moomsBuyArray.count >= 2) {
                        height += Get375Height(130);
                    }
                    [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                    currcellY += height;
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
                break;
            }
            case SNHHZMainSectionTypeVoucherAD:
            {
                if ([self.hhzTabViewModel.cmsDataDto.getQuanDto.my_quan_aryArray count] > 0 && [self.hhzTabViewModel.cmsDataDto.getQuanDto.my_getquanBgArray count] > 0) {
                    tempSection = SNHHZMainSectionTypeVoucherAD;
                    [currFloorDic setObject:@(Get375Height(90)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(90);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeOneAD:  //新人楼城
            {
                if ([self.hhzTabViewModel.cmsDataDto.oneADDto.my_img_aryArray count] > 0) {

                    SNHHZMainSectionADDto  *currSection = [self.hhzTabViewModel.cmsDataDto.oneADDtoArr safeObjectAtIndex:subIndex];
                    
                    //是否登陆
                    SNMB_LOGIN_GETUSERCENTER(userInfo)
                    if (!userInfo
                        || !userInfo.isLogined)   //未登录
                    {
                        SNHHZCMSModuleDTO *oneADDto = [currSection.my_img_aryArray safeObjectAtIndex:0];
                        if (![oneADDto.elementDesc isEqualToString:@"N"]) {
                            tempSection = SNHHZMainSectionTypeOneAD;
                            [currFloorDic setObject:@(Get375Height(90)) forKey:cms_cell_height_type];
                            currcellY += Get375Height(90);
                            [self.cellSequence addObject:currFloorDic];
                            currcellIndex += 1;
                        }
                    }
                    else    //登录则刷新数据
                    {
                        SNHHZCMSModuleDTO *oneADDto = [currSection.my_img_aryArray safeObjectAtIndex:0];
                        if ([oneADDto.elementDesc isEqualToString:@"N"]) {
                            if (self.hhzMainViewModel.isNew) {
                                tempSection = SNHHZMainSectionTypeOneAD;
                                [currFloorDic setObject:@(Get375Height(90)) forKey:cms_cell_height_type];
                                currcellY += Get375Height(90);
                                [self.cellSequence addObject:currFloorDic];
                                currcellIndex += 1;
                            }
                        }
                        else
                        {
                            tempSection = SNHHZMainSectionTypeOneAD;
                            [currFloorDic setObject:@(Get375Height(90)) forKey:cms_cell_height_type];
                            currcellY += Get375Height(90);
                            [self.cellSequence addObject:currFloorDic];
                            currcellIndex += 1;
                        }
                    }
                    
                }
            }
                break;
            case SNHHZMainSectionTypeTwoAD:
            {
                SNHHZMainSectionADDto  *currSection = [self.hhzTabViewModel.cmsDataDto.twoADDtoArr safeObjectAtIndex:subIndex];
                if ([currSection.my_img_aryArray count] > 0) {
                    tempSection = SNHHZMainSectionTypeTwoAD;
                    [currFloorDic setObject:@(Get375Height(90)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(90);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeThreeAD:
            {
                SNHHZMainSectionADDto  *currSection = [self.hhzTabViewModel.cmsDataDto.threeADDtoArr safeObjectAtIndex:subIndex];
                if ([currSection.my_img_aryArray count] > 0) {
                    tempSection = SNHHZMainSectionTypeThreeAD;
                    [currFloorDic setObject:@(Get375Height(122)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(122);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeFourAD:
            {
                SNHHZMainSectionADDto  *currSection = [self.hhzTabViewModel.cmsDataDto.fourADDtoArr safeObjectAtIndex:subIndex];
                if ([currSection.my_img_aryArray count] > 0) {
                    tempSection = SNHHZMainSectionTypeFourAD;
                    [currFloorDic setObject:@(Get375Height(122)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(122);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeSliderImage://连板广告
            {
                if ([self.hhzTabViewModel.cmsDataDto.newLbFloor.newlbFloorArray count] > 0) {
                    tempSection = SNHHZMainSectionTypeSliderImage;
                    if (self.isShowSliderAd)
                        height = Get375Height(365);
                    else
                        height = Get375Height(130);
                    
                    [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                    currcellY += height;
                    
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeSliderProduct://我的常购
            {
                NSArray *myOffenBuyArray = self.hhzMainViewModel.myOffenByProductArray;
                if (myOffenBuyArray.count > 0 && self.isBabyTab) {
                    tempSection = SNHHZMainSectionTypeSliderProduct;
                    if (self.hhzMainViewModel.myOffenByProductArray.count < 3 && self.hhzMainViewModel.myOffenByProductArray.count > 0) {
                        height = Get375Height(125*self.hhzMainViewModel.myOffenByProductArray.count);
                    }
                    else
                        height = Get375Height(162);
                    [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                    currcellY += height;
                    
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeTeachYouToBuy:
            {
                SNMKHHZSingleBabyInfoDto *currBabyInfo = self.currentBabyIndex == 1 ? self.babyInfo:self.baby2Info;
                NSDictionary *yeadAndWeek = [NSString getYearAndWeekWithBirthGetNewStr:currBabyInfo.babyBirthday];
                NSInteger yearNum = [[yeadAndWeek objectForKey:@"yearNum"] integerValue];
                NSInteger dayNum = [[yeadAndWeek objectForKey:@"dayNum"] integerValue] ;
                if (yearNum < 6 || (yearNum == 6 && dayNum == 0) )//小于六岁展示
                {
                    NSArray *recommandNewArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase4_completeData_Array);
                    if (self.isBabyTab && [self.hhzTabViewModel.cmsDataDto.teachBuyFloor.teachBuyFloorArray count] > 0 && recommandNewArray.count > 0) {
                        tempSection = SNHHZMainSectionTypeTeachYouToBuy;
                        height = [SNHHZTeachYouToBuyCell getTeachYouToBuyCellHeightWithContentTextString:self.hhzMainViewModel.pageNewDto.newsContent];
                        [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                        currcellY += height;
                        [self.cellSequence addObject:currFloorDic];
                        currcellIndex += 1;
                    }
                }
            }
                break;
            case SNHHZMainSectionTypeVideo:
            {
                if ([self.hhzTabViewModel.cmsDataDto.my_spDTO.my_CMSModuleDTOArr count] > 0) {
                    tempSection = SNHHZMainSectionTypeVideo;
                    [currFloorDic setObject:@(Get375Height(327)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(327);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeGuessYouLike://猜你喜欢
            {
                self.guessIndex = currcellIndex ;
                NSInteger numBs = self.hhzMainViewModel.guessYouLikeArr.count / 9;
                NSInteger numYs = self.hhzMainViewModel.guessYouLikeArr.count % 9;
                
                NSInteger guessNumber = numBs*5 + numYs/2 + numYs%2;   //前面的数据  加上 后面的
                for (NSInteger gueInt = 0; gueInt < guessNumber; ++gueInt) {
                    NSMutableDictionary *currGuesDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(SNHHZMainSectionTypeGuessYouLike),cms_squence_key_type, nil];
                    tempSection = SNHHZMainSectionTypeGuessYouLike;
                    if ((gueInt+1)% 5 != 0)
                        height = Get375Height(335);
                    else
                        height = Get375Height(178);
                    
                    [currGuesDic setObject:@(height) forKey:cms_cell_height_type];
                    currcellY += height;
                    [self.cellSequence addObject:currGuesDic];
                    currcellIndex += 1;
                }
                
            }
                break;
            case SNHHZMainSectionTypeMyTf:    //2大4小
            {
                if ([self.hhzTabViewModel.cmsDataDto.my_tfDTO.myBigFloorArray count] > 0) {
                    if (!self.isBabyTab) {
                        tempSection = SNHHZMainSectionTypeMyTf;
                        [currFloorDic setObject:@(Get375Height(145)) forKey:cms_cell_height_type];
                        currcellY += Get375Height(145);
                        [self.cellSequence addObject:currFloorDic];
                        currcellIndex += 1;
                    }
                }
            }
                break;
            case SNHHZMainSectionTypeHotSale:  //热卖
            {
                if ([self.hhzTabViewModel.cmsDataDto.my_hotSaleDTO.hotSaleProductArray count] > 0) {
                    tempSection = SNHHZMainSectionTypeHotSale;
                    [currFloorDic setObject:@(Get375Height(165)) forKey:cms_cell_height_type];
                    NSInteger hotRow = currcellIndex;
                    self.hotCellY = [NSIndexPath indexPathForRow:hotRow inSection:0];
                    currcellY += Get375Height(165);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
                
            case SNHHZMainSectionTypeJGF:
            {
                // 前一个为标题或间隔或宝宝切换tab 不展示
                if (tempSection == SNHHZMainSectionTypeJGF || tempSection == SNHHZMainSectionTypeComhd || tempSection == SNHHZMainSectionTypeMyToptab) {
                    break;
                }
                
                // 前一个为妈妈都在买 不展示
                if (tempSection == SNHHZMainSectionTypeMySameage) {
                    NSArray *goodsArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, getRecGoodsArray_completeData_Array);
                    if (goodsArray.count < 2 || !self.isBabyTab) {
                        break;
                    }
                }
                
                // 前一个为宝妈都在囤 不展示
                if (tempSection == SNHHZMainSectionTypeMyStore) {
                    NSArray *goodsArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase3_completeData_Array);
                    if (goodsArray.count < 2) {
                        break;
                    }
                }
                
                // 前一个为今日历史新低 不展示 
                if (tempSection == SNHHZMainSectionTypeHistorylow) {
                    NSArray *goodsArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase2_completeData_Array);
                    if (goodsArray.count < 3) {
                        break;
                    }
                }
                
                tempSection = SNHHZMainSectionTypeJGF;
                [currFloorDic setObject:@(Get375Height(10)) forKey:cms_cell_height_type];
                currcellY += Get375Height(10);
                [self.cellSequence addObject:currFloorDic];
                currcellIndex += 1;
            }
                break;
            case SNHHZMainSectionTypeHtGuanggao:    //横通广告
            {
                if (self.hhzTabViewModel.cmsDataDto.hengtongADDto.my_img_aryArray.count > 0)   //接口有数据展示
                {
                    tempSection = SNHHZMainSectionTypeHtGuanggao;
                    [currFloorDic setObject:@(Get375Height(90)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(90);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeCX_AD:    //单图横通广告
            {
                SNHHZPOPImgDTO  *currSection = [self.hhzTabViewModel.cmsDataDto.cxhengtongADDtoArr safeObjectAtIndex:subIndex];
                if ([self.hhzTabViewModel isShowCxAdCell:currSection]) {
                    tempSection = SNHHZMainSectionTypeCX_AD;
                    [currFloorDic setObject:@(Get375Height(90)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(90);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeIntelligent:    //达人楼层
            {
                moduleMergedArgDicKey = my_attention_Array;
                NSArray *dataArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, moduleMergedArgDicKey);
                if (dataArray.count > 0) {
                    tempSection = SNHHZMainSectionTypeIntelligent;
                    [currFloorDic setObject:@(Get375Height(210)) forKey:cms_cell_height_type];
                    currcellY += Get375Height(210);
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
                
            }
                break;
            case SNHHZMainSectionTypeMy_690_184://轮播广告
            {
                if ([self.hhzTabViewModel.cmsDataDto.my_690_184ADDtoArr count] > 0) {
                    {
                        tempSection = SNHHZMainSectionTypeMy_690_184;
                        [currFloorDic setObject:@(Get375Height(100)) forKey:cms_cell_height_type];
                        currcellY += Get375Height(100);
                        [self.cellSequence addObject:currFloorDic];
                        currcellIndex += 1;
                    }
                }
            }
                break;
            case SNHHZMainSectionTypeComhd:
            {
                NSDictionary *floorDic = [self.hhzTabViewModel.cmsCellSequence safeObjectAtIndex:i];
                
                if ([floorDic objectForKey:cms_squence_key_data]) {
                    //如果是我的常购就要特殊判断
                    if (self.hhzTabViewModel.usualBuyTitleIndex == i) {    //如果是常购title，则要判断内容是否为空
                        if(self.hhzMainViewModel.myOffenByProductArray.count > 0 && self.isBabyTab)
                        {
                            tempSection = SNHHZMainSectionTypeComhd;
                            [currFloorDic setObject:@(Get375Height(40)) forKey:cms_cell_height_type];
                            currcellY += Get375Height(40);
                            [self.cellSequence addObject:currFloorDic];
                            currcellIndex += 1;
                        }
                    }
                    else if (self.hhzTabViewModel.teachYouBuyTitleLocation == i) {    //如果是教你买title，则要判断内容是否为空
                        
                        SNMKHHZSingleBabyInfoDto *currBabyInfo = self.currentBabyIndex == 1 ? self.babyInfo:self.baby2Info;
                        NSDictionary *yeadAndWeek = [NSString getYearAndWeekWithBirthGetNewStr:currBabyInfo.babyBirthday];
                        NSInteger yearNum = [[yeadAndWeek objectForKey:@"yearNum"] integerValue];
                        NSInteger dayNum = [[yeadAndWeek objectForKey:@"dayNum"] integerValue] ;
                        if (yearNum < 6 || (yearNum == 6 && dayNum == 0) )//小于六岁展示
                        {
                            NSArray *recommandNewArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase4_completeData_Array);
                            if (self.isBabyTab && [self.hhzTabViewModel.cmsDataDto.teachBuyFloor.teachBuyFloorArray count] > 0 && recommandNewArray.count > 0) {
                                tempSection = SNHHZMainSectionTypeComhd;
                                [currFloorDic setObject:@(Get375Height(40)) forKey:cms_cell_height_type];
                                currcellY += Get375Height(40);
                                [self.cellSequence addObject:currFloorDic];
                                currcellIndex += 1;
                            }
                        }
                    }
                    else if (self.hhzTabViewModel.parentsMustBuyTitleLocation == i) {
                        NSArray *historyLowArray,*moomsBuyArray,*moomsStrawArray;
                        historyLowArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase2_completeData_Array);
                        moomsBuyArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase3_completeData_Array);
                        moomsStrawArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, getRecGoodsArray_completeData_Array);
                        
                        if (historyLowArray.count >= 3 || moomsBuyArray.count >= 2 || moomsStrawArray.count >= 2 || self.isBabyTab) {
                            tempSection = SNHHZMainSectionTypeComhd;
                            [currFloorDic setObject:@(Get375Height(40)) forKey:cms_cell_height_type];
                            currcellY += Get375Height(40);
                            [self.cellSequence addObject:currFloorDic];
                            currcellIndex += 1;
                        }
                    }
                    else if (self.hhzTabViewModel.themePavilionsTitleLocation == i) {
                        NSArray *dataArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, paramsBiz2_completeData_Array);
                        if ([dataArray count] > 0) {
                            tempSection = SNHHZMainSectionTypeComhd;
                            [currFloorDic setObject:@(Get375Height(40)) forKey:cms_cell_height_type];
                            currcellY += Get375Height(40);
                            [self.cellSequence addObject:currFloorDic];
                            currcellIndex += 1;
                        }
                    }
                    else if (self.hhzTabViewModel.goodStoreRecomTitleLocation == i) {
                        NSArray *goodShopArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, paramsBiz3_completeData_Array);
                        if ([goodShopArray count] > 0) {
                            tempSection = SNHHZMainSectionTypeComhd;
                            [currFloorDic setObject:@(Get375Height(40)) forKey:cms_cell_height_type];
                            currcellY += Get375Height(40);
                            [self.cellSequence addObject:currFloorDic];
                            currcellIndex += 1;
                        }
                    }
                    else if (self.hhzTabViewModel.guessYouLikeTitleLocation == i) {
                        if ([self.hhzMainViewModel.guessYouLikeArr count] > 0) {
                            tempSection = SNHHZMainSectionTypeComhd;
                            [currFloorDic setObject:@(Get375Height(40)) forKey:cms_cell_height_type];
                            currcellY += Get375Height(40);
                            [self.cellSequence addObject:currFloorDic];
                            currcellIndex += 1;
                        }
                    }
                    else if (self.hhzTabViewModel.globalGoodTitleLocation == i) {
                        NSArray *dataArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, paramsBiz_completeData_Array);
                        if ([dataArray count] > 0) {
                            tempSection = SNHHZMainSectionTypeComhd;
                            [currFloorDic setObject:@(Get375Height(40)) forKey:cms_cell_height_type];
                            currcellY += Get375Height(40);
                            [self.cellSequence addObject:currFloorDic];
                            currcellIndex += 1;
                        }
                    }
                    else
                    {
                        tempSection = SNHHZMainSectionTypeComhd;
                        [currFloorDic setObject:@(Get375Height(40)) forKey:cms_cell_height_type];
                        currcellY += Get375Height(40);
                        [self.cellSequence addObject:currFloorDic];
                        currcellIndex += 1;
                    }
                }
            }
                break;
            case SNHHZMainSectionTypeMyToptab:
            {
                if (self.isBabyTab) {
                    tempSection = SNHHZMainSectionTypeMyToptab;
                    height = [SNHHZToptabCell getSNHHZToptabCellHeight];
                    [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                    currcellY += height;
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeHistorylow:
            {
                NSArray *historyLowArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase2_completeData_Array);
                if (historyLowArray.count >= 3) {
                    tempSection = SNHHZMainSectionTypeHistorylow;
                    height = [SNHHZHistoryLowCell getSNHHZHistoryLowCellHeight];
                    [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                    currcellY += height;
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            case SNHHZMainSectionTypeMyStore:
            {
                NSArray *goodsArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, dyBase3_completeData_Array);
                if (goodsArray.count >= 2) {
                    tempSection = SNHHZMainSectionTypeMyStore;
                    height = [SNHHZMyStoreCell getSNHHZMyStoreCellHeight];
                    [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                    currcellY += height;
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
                break;
            }
                break;
            case SNHHZMainSectionTypeMySameage:
            {
                NSArray *goodsArray = EncodeArrayFromDic(self.hhzMainViewModel.mergedMoudleDic, getRecGoodsArray_completeData_Array);
                if (goodsArray.count >= 2 && self.isBabyTab) {
                    tempSection = SNHHZMainSectionTypeMySameage;
                    height = [SNHHZMyStoreCell getSNHHZMyStoreCellHeight];
                    [currFloorDic setObject:@(height) forKey:cms_cell_height_type];
                    currcellY += height;
                    [self.cellSequence addObject:currFloorDic];
                    currcellIndex += 1;
                }
            }
                break;
            default:
                break;
        }
    }
}

-(void)isShowSliderAdView
{
    if (self.tableIndex == 0 ) {  //只在首页弹出广告
       
        if ([self.hhzTabViewModel isShowSliderAdView]) {
            [self.sliderAdvView updateWithModuleDTO:self.hhzTabViewModel.cmsDataDto.my_slideImgDTO.slideImg_Dto];
            
            self.sliderAdvView.frame = CGRectMake(0, self.isBabyTab?Get375Height(0):0, kScreenWidth, Get375Height(365));
            [self addSubview:self.sliderAdvView];
            self.isShowSliderAd = YES;
        }
    }
}


//是否是新人
-(void)checkIsNew
{
    __weak typeof(self) weakSelf = self;
    
    self.hhzMainViewModel.isNewBlock = ^(BOOL isSuccess, NSString *erroCode, NSString *erroMsg) {
        [weakSelf reloadMainTable];
        
    };
    [self.hhzMainViewModel fetchIsNewService];
}

//文章接口
-(void)getPageNewFromServer
{
    
    __weak typeof(self) weakSelf = self;
    
    self.hhzMainViewModel.pageNewsBlock  = ^(BOOL isSuccess, NSString *erroCode, NSString *erroMsg) {
        
        if (isSuccess) {
            //猜你喜欢数据插入
            [weakSelf reloadMainTable];
        }else{
            
        }
    };
    if (self.isBabyTab) {
        SNMKHHZSingleBabyInfoDto *currBabyInfo = self.currentBabyIndex == 1? self.babyInfo:self.baby2Info;
        [self.hhzMainViewModel fetchPageNewsService:currBabyInfo];
    }
}

-(void)scroolViewToTop
{
    [self  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}


#pragma mark - 下拉刷新数据
- (void)refreshData{

    //刷新数据
//    [self requestForCMSData];

    [self getmoduleMergedDataFromServer:self.moudleMergedArgDic];
    
}



#pragma mark - 上拉加载更多
- (void)loadMoreData{
    
    [self.mj_footer endRefreshing];
}


#pragma mark - 到底了横线处理
- (void)addTwoLineToTableFooterView {
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    CGSize size = [@"我是有底线的" sizeWithFont:font limitedSize:CGSizeMake(kScreenWidth, font.lineHeight) lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat leftX = (kScreenWidth - size.width - 2 * Get375Height(25 + 10)) / 2.0;
    CGFloat rightX = kScreenWidth - leftX - Get375Height(25);
    self.footerLeftLineView.frame = CGRectMake(leftX, self.mj_footer.height/2.0, Get375Height(25), 0.5);
    self.footerRightLineView.frame = CGRectMake(rightX, self.mj_footer.height/2.0, Get375Height(25), 0.5);
    [self.mj_footer addSubview:self.footerLeftLineView];
    [self.mj_footer addSubview:self.footerRightLineView];
}

#pragma mark - getters and setters
- (UIView *)footerLeftLineView {
    if (!_footerLeftLineView) {
        _footerLeftLineView = [[UIView alloc] init];
        [_footerLeftLineView setBackgroundColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _footerLeftLineView;
}

- (UIView *)footerRightLineView {
    if (!_footerRightLineView) {
        _footerRightLineView = [[UIView alloc] init];
        [_footerRightLineView setBackgroundColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _footerRightLineView;
}

- (SNHHZTabbarViewModel *)hhzTabViewModel{
    
    if (!_hhzTabViewModel) {
        _hhzTabViewModel = [SNHHZTabbarViewModel sharedInstance];
    }
    return _hhzTabViewModel;
}

- (SNHHZSliderAdView *)sliderAdvView {
    if (!_sliderAdvView){
        _sliderAdvView = [[SNHHZSliderAdView alloc] init];
        _sliderAdvView.delegate = self;
    }
    return _sliderAdvView;
}

-(SNHHZChildInfoDTO *)childinfoDto
{
    if (!_childinfoDto) {
        _childinfoDto = [[SNHHZChildInfoDTO alloc] init];
    }
    return _childinfoDto;
}

-(SNHHZMainDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [[SNHHZMainDataManager alloc] init];
    }
    return _dataManager;
}

- (SNHHZMainViewModel *)hhzMainViewModel{
    
    if (!_hhzMainViewModel) {
        _hhzMainViewModel = [[SNHHZMainViewModel alloc] init:self.parentVC];
        
    }
    return _hhzMainViewModel;
}


- (SNHHZSliderIconView *)sliderIconView
{
    if (!_sliderIconView) {
        _sliderIconView = [[SNHHZSliderIconView alloc] initWithFrame:CGRectMake(0, 104, self.width, 0)];
        _sliderIconView.hidden = YES;
    }
    return _sliderIconView;
}

-(NSMutableArray *)cellSequence
{
    if (!_cellSequence) {
        _cellSequence = [[NSMutableArray alloc] init];
    }
    return _cellSequence;
}

-(void)dealloc
{
    //停止下拉广告计时器
    if (_sliderAdvView) {
        
        [_sliderAdvView stopCountDownTimer];
    }
}


#pragma mark -------------- SNHHZSliderAdViewDelegate  下拉广告点击

- (void)strongForceAdvPicClosed
{
    [self CustomEventCollection:@"680021002"];
    [self reportSpmClickEventWithPageId:@"680" modId:@"21" eleId:@"2"];
    //停止倒计时
    self.isShowSliderAd = NO;
    [self.sliderAdvView stopCountDownTimer];
    [self.sliderAdvView removeFromSuperview];
    if (NotNilAndNull(self.bannerIndexPath))
    {
        [self configCellSequence];
        [self reloadRowsAtIndexPaths:@[self.bannerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}

/**
 下拉广告下载完成
 */
- (void) strongForceAdvPicReady {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.isShowSliderAd = YES;
        if (NotNilAndNull(self.bannerIndexPath))
        {
            [self reloadRowsAtIndexPaths:@[self.bannerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.sliderAdvView startCountDownTimer];
    });
}

- (void)strongForceAdvLoadFail
{
    self.isShowSliderAd = NO;
    
}

/**
 下拉点击
 @param moduleDto
 */
- (void) strongForceAdvDidSelectWithModuleDto:(SNHHZCMSModuleDTO *)moduleDto {
    [self CustomEventCollection:@"680021001"];
    [self reportSpmClickEventWithPageId:@"680" modId:@"21" eleId:@"1"];
    NSString *url = moduleDto.linkUrl;
    routerToHHZTargetURL(url);
}


@end
