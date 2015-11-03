//
//  FilterViewController.m
//  Yelp
//
//  Created by Robin Wu on 10/31/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property(nonatomic, strong) NSMutableSet *selectedCategories;
@property(nonatomic) BOOL isDealOn;
@property(nonatomic, strong) NSNumber *selectedDistance;
@property(nonatomic, strong) NSNumber *selectedSorting;

- (void) initCategories;
- (void) initSortings;
- (void) initDistances;

@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *categories;
@property(nonatomic, strong) NSArray *distances;
@property(nonatomic, strong) NSArray *sortings;

@property(nonatomic, strong) NSIndexPath *lastSelectedDistance;
@property(nonatomic, strong) NSIndexPath *lastSelectedSorting;


@end

@implementation FiltersViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = @"Filters";
        
        [self customizeLeftNavBarButtons];
        [self customizeRightNavBarButtons];
        
        self.selectedCategories = [NSMutableSet set];
        
        [self initDistances];
        [self initSortings];
        [self initCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *navigationBarTintColor = [UIColor colorWithRed:192/255.0 green:25/255.0 blue:0 alpha:1];
    [self.navigationController.navigationBar setBarTintColor:navigationBarTintColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"SwitchCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        // DISTANCE
        if (self.lastSelectedDistance) {
            UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastSelectedDistance];
            [lastCell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        self.selectedDistance = (NSNumber *) self.distances[indexPath.row][@"value"];
        self.lastSelectedDistance = indexPath;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else if (indexPath.section == 2) {
        // SORT BY
        if (self.lastSelectedSorting) {
            UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastSelectedSorting];
            [lastCell setAccessoryType:UITableViewCellAccessoryNone];
        }
        self.selectedSorting = (NSNumber *) self.sortings[indexPath.row][@"value"];
        self.lastSelectedSorting = indexPath;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

# pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"Deal";
            break;
        case 1:
            sectionName = @"Distance";
            break;
        case 2:
            sectionName = @"Sort By";
            break;
        default:
            sectionName = @"Category";
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.distances.count;
        case 2:
            return self.sortings.count;
        default:
            return self.categories.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.text = [NSString stringWithFormat:@"section: %zd, row %zd", indexPath.section, indexPath.row];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Offering a Deal";
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = switchView;
        [switchView setTag:indexPath.row];
        [switchView addTarget:self action:@selector(onFilterForMostPopular:) forControlEvents:UIControlEventValueChanged];
        
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.distances[indexPath.row][@"name"];
    } else if (indexPath.section == 2) {
        cell.textLabel.text = self.sortings[indexPath.row][@"name"];
    } else {
        // 3
        static NSString *cellIdentifier = @"SwitchCell";
        SwitchCell *switchCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        switchCell.titleLabel.text = self.categories[indexPath.row][@"name"];
        switchCell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
        switchCell.delegate = self;
        
        return switchCell;
    }
    
    return cell;
}

# pragma mark - Switch Cell Delegate Methods

- (void) switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

# pragma mark - Private Methods

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    if (self.selectedDistance != nil) {
        [filters setObject:self.selectedDistance forKey:@"radius_filter"];
    }
    
    if (self.selectedSorting != nil) {
        [filters setObject:self.selectedSorting forKey:@"sort"];
    }
    
    [filters setObject:[NSNumber numberWithBool:self.isDealOn] forKey:@"deals_filter"];
    
    return filters;
}

- (void)customizeLeftNavBarButtons {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onCancelButton)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)customizeRightNavBarButtons {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onSearchButton)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void) onCancelButton {
    NSLog(@"onCancelButton");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onSearchButton {
    NSLog(@"onSearchButton");
    
    [self.delege filtersViewController:self didChangeFilters:self.filters];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFilterForMostPopular:(id)sender
{
    NSLog(@"on handling most popular");
    UISwitch *switchControl = (UISwitch *)sender;
    self.isDealOn = [switchControl isOn];
}

- (void) initDistances {
    self.distances = @[
                       @{@"name": @"Auto",      @"value": [NSNumber numberWithFloat:40000]},
                       @{@"name": @"0.3 miles", @"value": [NSNumber numberWithFloat:482.803]},
                       @{@"name": @"1 mile",    @"value": [NSNumber numberWithFloat:1609.34]},
                       @{@"name": @"5 miles",   @"value": [NSNumber numberWithFloat:8046.72]},
                       @{@"name": @"20 miles",  @"value": [NSNumber numberWithFloat:32186.9]}
                       ];
}

- (void) initSortings {
    self.sortings = @[
                     @{@"name": @"Best Match",    @"value": [NSNumber numberWithInt:0]},
                     @{@"name": @"Distance",      @"value": [NSNumber numberWithInt:1]},
                     @{@"name": @"Rating",        @"value": [NSNumber numberWithInt:2]}
                     ];
}

- (void) initCategories {
    self.categories = @[@{@"name": @"Afghan", @"code": @"afghani"},
                        @{@"name": @"African", @"code": @"african"},
                        @{@"name": @"American, New", @"code": @"newamerican"},
                        @{@"name": @"American, Traditional", @"code": @"tradamerican"},
                        @{@"name": @"Arabian", @"code": @"arabian"},
                        @{@"name": @"Argentine", @"code": @"argentine"},
                        @{@"name": @"Armenian", @"code": @"armenian"},
                        @{@"name": @"Asian Fusion", @"code": @"asianfusion"},
                        @{@"name": @"Asturian", @"code": @"asturian"},
                        @{@"name": @"Australian", @"code": @"australian"},
                        @{@"name": @"Austrian", @"code": @"austrian"},
                        @{@"name": @"Baguettes", @"code": @"baguettes"},
                        @{@"name": @"Bangladeshi", @"code": @"bangladeshi"},
                        @{@"name": @"Barbeque", @"code": @"bbq"},
                        @{@"name": @"Basque", @"code": @"basque"},
                        @{@"name": @"Bavarian", @"code": @"bavarian"},
                        @{@"name": @"Beer Garden", @"code": @"beergarden"},
                        @{@"name": @"Beer Hall", @"code": @"beerhall"},
                        @{@"name": @"Beisl", @"code": @"beisl"},
                        @{@"name": @"Belgian", @"code": @"belgian"},
                        @{@"name": @"Bistros", @"code": @"bistros"},
                        @{@"name": @"Black Sea", @"code": @"blacksea"},
                        @{@"name": @"Brasseries", @"code": @"brasseries"},
                        @{@"name": @"Brazilian", @"code": @"brazilian"},
                        @{@"name": @"Breakfast & Brunch", @"code": @"breakfast_brunch"},
                        @{@"name": @"British", @"code": @"british"},
                        @{@"name": @"Buffets", @"code": @"buffets"},
                        @{@"name": @"Bulgarian", @"code": @"bulgarian"},
                        @{@"name": @"Burgers", @"code": @"burgers"},
                        @{@"name": @"Burmese", @"code": @"burmese"},
                        @{@"name": @"Cafes", @"code": @"cafes"},
                        @{@"name": @"Cafeteria", @"code": @"cafeteria"},
                        @{@"name": @"Cajun/Creole", @"code": @"cajun"},
                        @{@"name": @"Cambodian", @"code": @"cambodian"},
                        @{@"name": @"Canadian", @"code": @"New)"},
                        @{@"name": @"Canteen", @"code": @"canteen"},
                        @{@"name": @"Caribbean", @"code": @"caribbean"},
                        @{@"name": @"Catalan", @"code": @"catalan"},
                        @{@"name": @"Chech", @"code": @"chech"},
                        @{@"name": @"Cheesesteaks", @"code": @"cheesesteaks"},
                        @{@"name": @"Chicken Shop", @"code": @"chickenshop"},
                        @{@"name": @"Chicken Wings", @"code": @"chicken_wings"},
                        @{@"name": @"Chilean", @"code": @"chilean"},
                        @{@"name": @"Chinese", @"code": @"chinese"},
                        @{@"name": @"Comfort Food", @"code": @"comfortfood"},
                        @{@"name": @"Corsican", @"code": @"corsican"},
                        @{@"name": @"Creperies", @"code": @"creperies"},
                        @{@"name": @"Cuban", @"code": @"cuban"},
                        @{@"name": @"Curry Sausage", @"code": @"currysausage"},
                        @{@"name": @"Cypriot", @"code": @"cypriot"},
                        @{@"name": @"Czech", @"code": @"czech"},
                        @{@"name": @"Czech/Slovakian", @"code": @"czechslovakian"},
                        @{@"name": @"Danish", @"code": @"danish"},
                        @{@"name": @"Delis", @"code": @"delis"},
                        @{@"name": @"Diners", @"code": @"diners"},
                        @{@"name": @"Dumplings", @"code": @"dumplings"},
                        @{@"name": @"Eastern European", @"code": @"eastern_european"},
                        @{@"name": @"Ethiopian", @"code": @"ethiopian"},
                        @{@"name": @"Fast Food", @"code": @"hotdogs"},
                        @{@"name": @"Filipino", @"code": @"filipino"},
                        @{@"name": @"Fish & Chips", @"code": @"fishnchips"},
                        @{@"name": @"Fondue", @"code": @"fondue"},
                        @{@"name": @"Food Court", @"code": @"food_court"},
                        @{@"name": @"Food Stands", @"code": @"foodstands"},
                        @{@"name": @"French", @"code": @"french"},
                        @{@"name": @"French Southwest", @"code": @"sud_ouest"},
                        @{@"name": @"Galician", @"code": @"galician"},
                        @{@"name": @"Gastropubs", @"code": @"gastropubs"},
                        @{@"name": @"Georgian", @"code": @"georgian"},
                        @{@"name": @"German", @"code": @"german"},
                        @{@"name": @"Giblets", @"code": @"giblets"},
                        @{@"name": @"Gluten-Free", @"code": @"gluten_free"},
                        @{@"name": @"Greek", @"code": @"greek"},
                        @{@"name": @"Halal", @"code": @"halal"},
                        @{@"name": @"Hawaiian", @"code": @"hawaiian"},
                        @{@"name": @"Heuriger", @"code": @"heuriger"},
                        @{@"name": @"Himalayan/Nepalese", @"code": @"himalayan"},
                        @{@"name": @"Hong Kong Style Cafe", @"code": @"hkcafe"},
                        @{@"name": @"Hot Dogs", @"code": @"hotdog"},
                        @{@"name": @"Hot Pot", @"code": @"hotpot"},
                        @{@"name": @"Hungarian", @"code": @"hungarian"},
                        @{@"name": @"Iberian", @"code": @"iberian"},
                        @{@"name": @"Indian", @"code": @"indpak"},
                        @{@"name": @"Indonesian", @"code": @"indonesian"},
                        @{@"name": @"International", @"code": @"international"},
                        @{@"name": @"Irish", @"code": @"irish"},
                        @{@"name": @"Island Pub", @"code": @"island_pub"},
                        @{@"name": @"Israeli", @"code": @"israeli"},
                        @{@"name": @"Italian", @"code": @"italian"},
                        @{@"name": @"Japanese", @"code": @"japanese"},
                        @{@"name": @"Jewish", @"code": @"jewish"},
                        @{@"name": @"Kebab", @"code": @"kebab"},
                        @{@"name": @"Korean", @"code": @"korean"},
                        @{@"name": @"Kosher", @"code": @"kosher"},
                        @{@"name": @"Kurdish", @"code": @"kurdish"},
                        @{@"name": @"Laos", @"code": @"laos"},
                        @{@"name": @"Laotian", @"code": @"laotian"},
                        @{@"name": @"Latin American", @"code": @"latin"},
                        @{@"name": @"Live/Raw Food", @"code": @"raw_food"},
                        @{@"name": @"Lyonnais", @"code": @"lyonnais"},
                        @{@"name": @"Malaysian", @"code": @"malaysian"},
                        @{@"name": @"Meatballs", @"code": @"meatballs"},
                        @{@"name": @"Mediterranean", @"code": @"mediterranean"},
                        @{@"name": @"Mexican", @"code": @"mexican"},
                        @{@"name": @"Middle Eastern", @"code": @"mideastern"},
                        @{@"name": @"Milk Bars", @"code": @"milkbars"},
                        @{@"name": @"Modern Australian", @"code": @"modern_australian"},
                        @{@"name": @"Modern European", @"code": @"modern_european"},
                        @{@"name": @"Mongolian", @"code": @"mongolian"},
                        @{@"name": @"Moroccan", @"code": @"moroccan"},
                        @{@"name": @"New Zealand", @"code": @"newzealand"},
                        @{@"name": @"Night Food", @"code": @"nightfood"},
                        @{@"name": @"Norcinerie", @"code": @"norcinerie"},
                        @{@"name": @"Open Sandwiches", @"code": @"opensandwiches"},
                        @{@"name": @"Oriental", @"code": @"oriental"},
                        @{@"name": @"Pakistani", @"code": @"pakistani"},
                        @{@"name": @"Parent Cafes", @"code": @"eltern_cafes"},
                        @{@"name": @"Parma", @"code": @"parma"},
                        @{@"name": @"Persian/Iranian", @"code": @"persian"},
                        @{@"name": @"Peruvian", @"code": @"peruvian"},
                        @{@"name": @"Pita", @"code": @"pita"},
                        @{@"name": @"Pizza", @"code": @"pizza"},
                        @{@"name": @"Polish", @"code": @"polish"},
                        @{@"name": @"Portuguese", @"code": @"portuguese"},
                        @{@"name": @"Potatoes", @"code": @"potatoes"},
                        @{@"name": @"Poutineries", @"code": @"poutineries"},
                        @{@"name": @"Pub Food", @"code": @"pubfood"},
                        @{@"name": @"Rice", @"code": @"riceshop"},
                        @{@"name": @"Romanian", @"code": @"romanian"},
                        @{@"name": @"Rotisserie Chicken", @"code": @"rotisserie_chicken"},
                        @{@"name": @"Rumanian", @"code": @"rumanian"},
                        @{@"name": @"Russian", @"code": @"russian"},
                        @{@"name": @"Salad", @"code": @"salad"},
                        @{@"name": @"Sandwiches", @"code": @"sandwiches"},
                        @{@"name": @"Scandinavian", @"code": @"scandinavian"},
                        @{@"name": @"Scottish", @"code": @"scottish"},
                        @{@"name": @"Seafood", @"code": @"seafood"},
                        @{@"name": @"Serbo Croatian", @"code": @"serbocroatian"},
                        @{@"name": @"Signature Cuisine", @"code": @"signature_cuisine"},
                        @{@"name": @"Singaporean", @"code": @"singaporean"},
                        @{@"name": @"Slovakian", @"code": @"slovakian"},
                        @{@"name": @"Soul Food", @"code": @"soulfood"},
                        @{@"name": @"Soup", @"code": @"soup"},
                        @{@"name": @"Southern", @"code": @"southern"},
                        @{@"name": @"Spanish", @"code": @"spanish"},
                        @{@"name": @"Steakhouses", @"code": @"steak"},
                        @{@"name": @"Sushi Bars", @"code": @"sushi"},
                        @{@"name": @"Swabian", @"code": @"swabian"},
                        @{@"name": @"Swedish", @"code": @"swedish"},
                        @{@"name": @"Swiss Food", @"code": @"swissfood"},
                        @{@"name": @"Tabernas", @"code": @"tabernas"},
                        @{@"name": @"Taiwanese", @"code": @"taiwanese"},
                        @{@"name": @"Tapas Bars", @"code": @"tapas"},
                        @{@"name": @"Tapas/Small Plates", @"code": @"tapasmallplates"},
                        @{@"name": @"Tex-Mex", @"code": @"tex-mex"},
                        @{@"name": @"Thai", @"code": @"thai"},
                        @{@"name": @"Traditional Norwegian", @"code": @"norwegian"},
                        @{@"name": @"Traditional Swedish", @"code": @"traditional_swedish"},
                        @{@"name": @"Trattorie", @"code": @"trattorie"},
                        @{@"name": @"Turkish", @"code": @"turkish"},
                        @{@"name": @"Ukrainian", @"code": @"ukrainian"},
                        @{@"name": @"Uzbek", @"code": @"uzbek"},
                        @{@"name": @"Vegan", @"code": @"vegan"},
                        @{@"name": @"Vegetarian", @"code": @"vegetarian"},
                        @{@"name": @"Venison", @"code": @"venison"},
                        @{@"name": @"Vietnamese", @"code": @"vietnamese"},
                        @{@"name": @"Wok", @"code": @"wok"},
                        @{@"name": @"Wraps", @"code": @"wraps"},
                        @{@"name": @"Yugoslav", @"code": @"yugoslav"}];
}

@end
