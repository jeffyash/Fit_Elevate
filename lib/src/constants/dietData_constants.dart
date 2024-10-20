import 'package:fitelevate/src/constants/path_constants.dart';
import 'package:fitelevate/src/constants/text_constants.dart';
import '../models/diet_data.dart';
import 'plan_text.dart';

class DataConstants {

// Diet
   static final List<DietPlanData> weightloss_dietPlans = [
    DietPlanData(
      title: PlansTextConstants.lowCarbDietTitle,
      image: 'images/low_carb.png',
    ),
    DietPlanData(
      title: PlansTextConstants.mediterraneanDietTitle,
      image: 'images/mediterranean_diet.jpg',
    ),
    DietPlanData(
      title: PlansTextConstants.intermittentFastingTitle,
      image: 'images/intermittent_fasting.jpg',
    ),
    DietPlanData(
      title: PlansTextConstants.veganDietTitle,
      image: 'images/vegan.jpg',
    ),
    // Add more diet plans as needed
  ];

   static final List<DietPlanDetails> weightLossDietPlan = [
     DietPlanDetails(
         title:PlansTextConstants.lowCarbDietTitle,
         description: PlansTextConstants.lowCarbDietDescription,
         foodsToInclude: PlansTextConstants.lowCarbDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.lowCarbDietFoodsToAvoid,
         dietGoal: PlansTextConstants.lowCarbDietGoal
     ),
     DietPlanDetails(
          title: PlansTextConstants.mediterraneanDietTitle,
         description: PlansTextConstants.mediterraneanDietDescription,
         foodsToInclude: PlansTextConstants.mediterraneanDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.mediterraneanDietFoodsToAvoid,
         dietGoal: PlansTextConstants.mediterraneanDietGoal
     ),
     DietPlanDetails(
       title:PlansTextConstants.intermittentFastingTitle ,
         description: PlansTextConstants.intermittentFastingDescription,
         foodsToInclude: PlansTextConstants.intermittentFastingFoodsToInclude,
         foodsToAvoid: PlansTextConstants.intermittentFastingFoodsToAvoid,
         dietGoal: PlansTextConstants.intermittentFastingGoal
     ),
     DietPlanDetails(
       title: PlansTextConstants.veganDietTitle,
         description: PlansTextConstants.veganDietDescription,
         foodsToInclude: PlansTextConstants.veganDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.veganDietFoodsToAvoid,
         dietGoal: PlansTextConstants.veganDietGoal,
     ),
     // Add more diet plans as needed
   ];
   //Weight Gain
   static final List<DietPlanData> weightgain_dietPlans = [
     DietPlanData(
       title: PlansTextConstants.highCalorieDietTitle,
       image: 'images/High-Calorie-Diet.jpg',
     ),
     DietPlanData(
       title: PlansTextConstants.highProteinDietTitle,
       image: 'images/High-protein.jpg',
     ),
     DietPlanData(
       title: PlansTextConstants.balancedDietWithHealthyFatsTitle,
       image: 'images/BalancedDiet.jpg',
     ),

     // Add more diet plans as needed
   ];
   static final List<DietPlanDetails> weightGainDietPlan = [
     DietPlanDetails(
         title:PlansTextConstants.highCalorieDietTitle,
         description: PlansTextConstants.highCalorieDietDescription,
         foodsToInclude: PlansTextConstants.highCalorieDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.highCalorieDietFoodsToAvoid,
         dietGoal: PlansTextConstants.highCalorieDietGoal
     ),
     DietPlanDetails(
         title: PlansTextConstants.highProteinDietTitle,
         description: PlansTextConstants.highProteinDietDescription,
         foodsToInclude: PlansTextConstants.highProteinDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.highProteinDietFoodsToAvoid,
         dietGoal: PlansTextConstants.highProteinDietGoal
     ),
     DietPlanDetails(
         title:PlansTextConstants.balancedDietWithHealthyFatsTitle ,
         description: PlansTextConstants.balancedDietWithHealthyFatsDescription,
         foodsToInclude: PlansTextConstants.balancedDietWithHealthyFatsFoodsToInclude,
         foodsToAvoid: PlansTextConstants.balancedDietWithHealthyFatsFoodsToAvoid,
         dietGoal: PlansTextConstants.balancedDietWithHealthyFatsGoal
     ),
     DietPlanDetails(
       title: PlansTextConstants.veganDietTitle,
       description: PlansTextConstants.veganDietDescription,
       foodsToInclude: PlansTextConstants.veganDietFoodsToInclude,
       foodsToAvoid: PlansTextConstants.veganDietFoodsToAvoid,
       dietGoal: PlansTextConstants.veganDietGoal,
     ),

     // Add more diet plans as needed
   ];
   static final List<DietPlanData> weightmaintenance_dietPlans = [
   DietPlanData(
   title: PlansTextConstants.balancedDietWithHealthyFatsTitle,
   image: 'images/BalancedDiet.jpg',
   ),
   DietPlanData(
   title: PlansTextConstants.lowCarbDietTitle,
   image: 'images/low_carb.png',
   ),
   DietPlanData(
   title: PlansTextConstants.mediterraneanDietTitle,
   image: 'images/mediterranean_diet.jpg',
   ),
     DietPlanData(
   title: PlansTextConstants.highProteinDietTitle,
   image: 'images/High-protein.jpg',
   ),
  ];
   static final List<DietPlanDetails> weightMaintenanceDietPlan = [
     DietPlanDetails(
         title:PlansTextConstants.balancedDietWithHealthyFatsTitle ,
         description: PlansTextConstants.balancedDietWithHealthyFatsDescription,
         foodsToInclude: PlansTextConstants.balancedDietWithHealthyFatsFoodsToInclude,
         foodsToAvoid: PlansTextConstants.balancedDietWithHealthyFatsFoodsToAvoid,
         dietGoal: PlansTextConstants.balancedDietWithHealthyFatsGoal
     ),
     DietPlanDetails(
         title:PlansTextConstants.lowCarbDietTitle,
         description: PlansTextConstants.lowCarbDietDescription,
         foodsToInclude: PlansTextConstants.lowCarbDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.lowCarbDietFoodsToAvoid,
         dietGoal: PlansTextConstants.lowCarbDietGoal
     ),
     DietPlanDetails(
         title: PlansTextConstants.mediterraneanDietTitle,
         description: PlansTextConstants.mediterraneanDietDescription,
         foodsToInclude: PlansTextConstants.mediterraneanDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.mediterraneanDietFoodsToAvoid,
         dietGoal: PlansTextConstants.mediterraneanDietGoal
     ),
     DietPlanDetails(
         title: PlansTextConstants.highProteinDietTitle,
         description: PlansTextConstants.highProteinDietDescription,
         foodsToInclude: PlansTextConstants.highProteinDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.highProteinDietFoodsToAvoid,
         dietGoal: PlansTextConstants.highProteinDietGoal
     ),

     // Add more diet plans as needed
   ];
   static final List<DietPlanData> muscleGain_dietPlans = [
     DietPlanData(
   title: PlansTextConstants.highProteinDietTitle,
   image: 'images/High-protein.jpg',
   ),
  ];
   static final List<DietPlanDetails> muscleGainDietPlan = [

     DietPlanDetails(
         title: PlansTextConstants.highProteinDietTitle,
         description: PlansTextConstants.highProteinDietDescription,
         foodsToInclude: PlansTextConstants.highProteinDietFoodsToInclude,
         foodsToAvoid: PlansTextConstants.highProteinDietFoodsToAvoid,
         dietGoal: PlansTextConstants.highProteinDietGoal
     ),

     // Add more diet plans as needed
   ];
}


class FoodData {
  static List<FoodItems> lowcarb_breakfast = [
    FoodItems(
      foodTitle: TextConstants.avocadoToast,
      foodImage: PathConstants.avocadoToast,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtWithBerries,
      foodImage: PathConstants.greekYogurtWithBerries,
    ),
    FoodItems(
      foodTitle: TextConstants.eggMuffins,
      foodImage: PathConstants.eggMuffins,
    ),
    FoodItems(
      foodTitle: TextConstants.chiaSeedPudding,
      foodImage: PathConstants.chiaSeedPudding,
    ),
    FoodItems(
      foodTitle: TextConstants.smoothieBowl,
      foodImage: PathConstants.smoothieBowl,
    ),
  ];

  static List<FoodItems> lowcarb_lunch = [
    FoodItems(
      foodTitle: TextConstants.chickenSalad,
      foodImage: PathConstants.chickenSalad,
    ),
    FoodItems(
      foodTitle: TextConstants.chickenTikka,
      foodImage: PathConstants.chickenTikka,
    ),
    FoodItems(
      foodTitle: TextConstants.cauliflowerRice,
      foodImage: PathConstants.cauliflowerRice,
    ),
    FoodItems(
      foodTitle: TextConstants.chickenCurry,
      foodImage: PathConstants.chickenCurry,
    ),
    FoodItems(
      foodTitle: TextConstants.palakPaneer,
      foodImage: PathConstants.palakPaneer,
    ),
  ];

  static List<FoodItems> lowcarb_dinner = [
    FoodItems(
      foodTitle: TextConstants.tandooriSalmon,
      foodImage: PathConstants.tandooriSalmon,
    ),
    FoodItems(
      foodTitle: TextConstants.stuffedBellPeppers,
      foodImage: PathConstants.stuffedBellPeppers,
    ),
    FoodItems(
      foodTitle: TextConstants.beefStirFry,
      foodImage: PathConstants.beefStirFry,
    ),
    FoodItems(
      foodTitle: TextConstants.shrimpSkewers,
      foodImage: PathConstants.shrimpSkewers,
    ),
    FoodItems(
      foodTitle: TextConstants.broccoliAndCheese,
      foodImage: PathConstants.broccoliAndCheese,
    ),
  ];

  static List<FoodItems> lowcarb_snacks = [
    FoodItems(
      foodTitle: TextConstants.celerySticksWithHummus,
      foodImage: PathConstants.celerySticksWithHummus,
    ),
    FoodItems(
      foodTitle: TextConstants.almonds,
      foodImage: PathConstants.almonds,
    ),
    FoodItems(
      foodTitle: TextConstants.roastedChickPeas,
      foodImage: PathConstants.roastedChickPeas,
    ),
    FoodItems(
      foodTitle: TextConstants.hardBoiledEggs,
      foodImage: PathConstants.hardBoiledEggs,
    ),
    FoodItems(
      foodTitle: TextConstants.cucumberSlicesWithDip,
      foodImage: PathConstants.cucumberSlicesWithDip,
    ),
  ];
  // Mediterranean
// Breakfast
  static List<FoodItems> mediterranean_breakfast = [
    FoodItems(
      foodTitle: TextConstants.mediterraneanOmelette,
      foodImage: PathConstants.mediterraneanOmelette,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtWithHoney,
      foodImage: PathConstants.greekYogurtWithHoney,
    ),
    FoodItems(
      foodTitle: TextConstants.wholeGrainToastWithAvocado,
      foodImage: PathConstants.wholeGrainToastWithAvocado,
    ),
    FoodItems(
      foodTitle: TextConstants.fruitSalad,
      foodImage: PathConstants.fruitSalad,
    ),
    FoodItems(
      foodTitle: TextConstants.smoothieBowl,
      foodImage: PathConstants.smoothieBowl,
    ),
  ];

// Lunch
  static List<FoodItems> mediterranean_lunch = [
    FoodItems(
      foodTitle: TextConstants.quinoaTabbouleh,
      foodImage: PathConstants.quinoaTabbouleh,
    ),
    FoodItems(
      foodTitle: TextConstants.grilledChickenSalad,
      foodImage: PathConstants.grilledChickenSalad,
    ),
    FoodItems(
      foodTitle: TextConstants.chickpeaSalad,
      foodImage: PathConstants.chickpeaSalad,
    ),
    FoodItems(
      foodTitle: TextConstants.grilledVegetableWrap,
      foodImage: PathConstants.grilledVegetableWrap,
    ),
    FoodItems(
      foodTitle: TextConstants.lentilSoup,
      foodImage: PathConstants.lentilSoup,
    ),
    FoodItems(
      foodTitle: TextConstants.paneerTikkaSalad,
      foodImage: PathConstants.paneerTikkaSalad,
    ),
  ];

// Dinner
  static List<FoodItems> mediterranean_dinner = [
    FoodItems(
      foodTitle: TextConstants.bakedSalmon,
      foodImage: PathConstants.bakedSalmon,
    ),
    FoodItems(
      foodTitle: TextConstants.ratatouille,
      foodImage: PathConstants.ratatouille,
    ),
    FoodItems(
      foodTitle: TextConstants.grilledShrimpSkewers,
      foodImage: PathConstants.grilledShrimpSkewers,
    ),
    FoodItems(
      foodTitle: TextConstants.chickenSouvlaki,
      foodImage: PathConstants.chickenSouvlaki,
    ),
    FoodItems(
      foodTitle: TextConstants.tandooriChicken,
      foodImage: PathConstants.tandooriChicken,
    ),
  ];

// Snacks
  static List<FoodItems> mediterranean_snacks = [
    FoodItems(
      foodTitle: TextConstants.hummusWithVeggies,
      foodImage: PathConstants.hummusWithVeggies,
    ),
    FoodItems(
      foodTitle: TextConstants.mixedNuts,
      foodImage: PathConstants.mixedNuts,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtParfait,
      foodImage: PathConstants.greekYogurtParfait,
    ),
    FoodItems(
      foodTitle: TextConstants.appleSlicesWithAlmondButter,
      foodImage: PathConstants.appleSlicesWithAlmondButter,
    ),
    FoodItems(
      foodTitle: TextConstants.olivesAndFeta,
      foodImage: PathConstants.olivesAndFeta,
    ),
  ];

  // Intermittent Fasting
// Breakfast
  static List<FoodItems> intermittent_breakfast = [
    FoodItems(
      foodTitle: TextConstants.scrambledEggs,
      foodImage: PathConstants.scrambledEggs,
    ),
    FoodItems(
      foodTitle: TextConstants.avocadoToast,
      foodImage: PathConstants.avocadoToasts,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtWithBerries,
      foodImage: PathConstants.greekYogurtWithBerry,
    ),
    FoodItems(
      foodTitle: TextConstants.oatmealWithChiaSeeds,
      foodImage: PathConstants.oatmealWithChiaSeeds,
    ),
    FoodItems(
      foodTitle: TextConstants.smoothieWithSpinach,
      foodImage: PathConstants.smoothieWithSpinach,
    ),
  ];

// Lunch
  static List<FoodItems> intermittent_lunch = [
    FoodItems(
      foodTitle: TextConstants.grilledChickenSalads,
      foodImage: PathConstants.grilledChickenSalads,
    ),
    FoodItems(
      foodTitle: TextConstants.quinoaBowl,
      foodImage: PathConstants.quinoaBowl,
    ),
    FoodItems(
      foodTitle: TextConstants.turkeyWrap,
      foodImage: PathConstants.turkeyWrap,
    ),
    FoodItems(
      foodTitle: TextConstants.lentilSoup,
      foodImage: PathConstants.lentilSoups,
    ),
    FoodItems(
      foodTitle: TextConstants.chickpeaSalads,
      foodImage: PathConstants.chickpeaSalads,
    ),
  ];

// Dinner
  static List<FoodItems> intermittent_dinner = [
    FoodItems(
      foodTitle: TextConstants.bakedSalmon,
      foodImage: PathConstants.bakedSalmons,
    ),
    FoodItems(
      foodTitle: TextConstants.stirFriedTofu,
      foodImage: PathConstants.stirFriedTofu,
    ),
    FoodItems(
      foodTitle: TextConstants.grilledShrimp,
      foodImage: PathConstants.grilledShrimp,
    ),
    FoodItems(
      foodTitle: TextConstants.turkeyMeatballs,
      foodImage: PathConstants.turkeyMeatballs,
    ),
    FoodItems(
      foodTitle: TextConstants.stuffedBellPeppers,
      foodImage: PathConstants.stuffedBellPepper,
    ),
  ];

// Snacks
  static List<FoodItems> intermittent_snacks = [
    FoodItems(
      foodTitle: TextConstants.appleSlicesWithAlmondButter,
      foodImage: PathConstants.appleSliceWithAlmondButter,
    ),
    FoodItems(
      foodTitle: TextConstants.carrotSticksWithHummus,
      foodImage: PathConstants.carrotSticksWithHummus,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtWithGranola,
      foodImage: PathConstants.greekYogurtWithGranola,
    ),
    FoodItems(
      foodTitle: TextConstants.mixedNuts,
      foodImage: PathConstants.mixedNut,
    ),
    FoodItems(
      foodTitle: TextConstants.fruitSalad,
      foodImage: PathConstants.fruitSalads,
    ),

  ];

  // Vegan
// Breakfast
  static List<FoodItems> vegan_breakfast = [
    FoodItems(
      foodTitle: TextConstants.tofuScramble,
      foodImage: PathConstants.tofuScramble,
    ),
    FoodItems(
      foodTitle: TextConstants.chiaPudding,
      foodImage: PathConstants.chiaPudding,
    ),
    FoodItems(
      foodTitle: TextConstants.avocadoToast,
      foodImage: PathConstants.avocadoToastVegan,
    ),
    FoodItems(
      foodTitle: TextConstants.smoothieBowl,
      foodImage: PathConstants.smoothieBowlVegan,
    ),
    FoodItems(
      foodTitle: TextConstants.peanutButterOatmeal,
      foodImage: PathConstants.peanutButterOatmeal,
    ),
  ];

// Lunch
  static List<FoodItems> vegan_lunch = [
    FoodItems(
      foodTitle: TextConstants.quinoaSalad,
      foodImage: PathConstants.quinoaSalad,
    ),
    FoodItems(
      foodTitle: TextConstants.veggieWrap,
      foodImage: PathConstants.veggieWrap,
    ),
    FoodItems(
      foodTitle: TextConstants.falafelWithHummus,
      foodImage: PathConstants.falafelWithHummus,
    ),
    FoodItems(
      foodTitle: TextConstants.blackBeanBowl,
      foodImage: PathConstants.blackBeanBowl,
    ),
    FoodItems(
      foodTitle: TextConstants.lentilSoup,
      foodImage: PathConstants.lentilSoupVegan,
    ),
  ];

// Dinner
  static List<FoodItems> vegan_dinner = [
    FoodItems(
      foodTitle: TextConstants.vegetableStirFry,
      foodImage: PathConstants.vegetableStirFry,
    ),
    FoodItems(
      foodTitle: TextConstants.stuffedSweetPotatoes,
      foodImage: PathConstants.stuffedSweetPotatoes,
    ),
    FoodItems(
      foodTitle: TextConstants.veganChili,
      foodImage: PathConstants.veganChili,
    ),
    FoodItems(
      foodTitle: TextConstants.roastedVegetablePasta,
      foodImage: PathConstants.roastedVegetablePasta,
    ),
    FoodItems(
      foodTitle: TextConstants.lentilCurry,
      foodImage: PathConstants.lentilCurry,
    ),
  ];

// Snacks
  static List<FoodItems> vegan_snacks = [
    FoodItems(
      foodTitle: TextConstants.roastedChickpeas,
      foodImage: PathConstants.roastedChickpeasVegan,
    ),
    FoodItems(
      foodTitle: TextConstants.mixedNutsAndSeeds,
      foodImage: PathConstants.mixedNutsVegan,
    ),
    FoodItems(
      foodTitle: TextConstants.appleSlicesWithAlmondButter,
      foodImage: PathConstants.appleSlicesWithAlmondButterVegan,
    ),
    FoodItems(
      foodTitle: TextConstants.guacamoleWithVeggies,
      foodImage: PathConstants.guacamoleWithVeggies,
    ),
    FoodItems(
      foodTitle: TextConstants.fruitSalad,
      foodImage: PathConstants.fruitSaladVegan,
    ),
  ];

  //weightGain
  static List<FoodItems> highcalorie_breakfast = [
    FoodItems(
      foodTitle: TextConstants.wholeGrainToastWithAvocadoAndScrambledEggs,
      foodImage: PathConstants.wholeGrainToastWithAvocadoAndScrambledEggs,
    ),
    FoodItems(
      foodTitle: TextConstants.smoothieWithPeanutButterBananaOatsProteinPowder,
      foodImage: PathConstants.smoothieWithPeanutButterBananaOatsProteinPowder,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtWithGranolaNutsAndHoney,
      foodImage: PathConstants.greekYogurtWithGranolaNutsAndHoney,
    ),
    FoodItems(
      foodTitle: TextConstants.oatmealWithAlmondButterChiaSeedsAndDriedFruits,
      foodImage: PathConstants.oatmealWithAlmondButterChiaSeedsAndDriedFruits,
    ),
    FoodItems(
      foodTitle: TextConstants.fullFatMilkWithWholeGrainCereal,
      foodImage: PathConstants.fullFatMilkWithWholeGrainCereal,
    ),
  ];

  static List<FoodItems> highcalorie_lunch = [
    FoodItems(
      foodTitle: TextConstants.grilledChickenSandwichWithAvocadoAndCheese,
      foodImage: PathConstants.grilledChickenSandwichWithAvocadoAndCheese,
    ),
    FoodItems(
      foodTitle: TextConstants.quinoaBowlWithChickpeasRoastedVegetablesAndTahiniDressing,
      foodImage: PathConstants.quinoaBowlWithChickpeasRoastedVegetablesAndTahiniDressing,
    ),
    FoodItems(
      foodTitle: TextConstants.butterChickenWithNaan,
      foodImage: PathConstants.butterChickenWithNaan,
    ),
    FoodItems(
      foodTitle: TextConstants.paneerTikkaMasalaWithRice,
      foodImage: PathConstants.paneerTikkaMasalaWithRice,
    ),
    FoodItems(
      foodTitle: TextConstants.lambRoganJoshWithJeeraRice,
      foodImage: PathConstants.lambRoganJoshWithJeeraRice,
    ),
  ];

  static List<FoodItems> highcalorie_dinner = [
    FoodItems(
      foodTitle: TextConstants.prawnCurryWithCoconutRice,
      foodImage: PathConstants.prawnCurryWithCoconutRice,
    ),
    FoodItems(
      foodTitle: TextConstants.paneerButterMasalaWithGarlicNaan,
      foodImage: PathConstants.paneerButterMasalaWithGarlicNaan,
    ),
    FoodItems(
      foodTitle: TextConstants.chickenCurryWithBasmatiRiceAndNaan,
      foodImage: PathConstants.chickenCurryWithBasmatiRiceAndNaan,
    ),
    FoodItems(
      foodTitle: TextConstants.stirFriedTofuWithBrownRiceAndVegetables,
      foodImage: PathConstants.stirFriedTofuWithBrownRiceAndVegetables,
    ),
    FoodItems(
      foodTitle: TextConstants.beefStewWithPotatoesAndCarrots,
      foodImage: PathConstants.beefStewWithPotatoesAndCarrots,
    ),
  ];


  static List<FoodItems> highcalorie_snacks = [
    FoodItems(
      foodTitle: TextConstants.trailMixWithNutsSeedsAndDriedFruits,
      foodImage: PathConstants.trailMixWithNutsSeedsAndDriedFruits,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtWithMixedBerriesAndHoney,
      foodImage: PathConstants.greekYogurtWithMixedBerriesAndHoney,
    ),
    FoodItems(
      foodTitle: TextConstants.cheeseAndWholeGrainCrackers,
      foodImage: PathConstants.cheeseAndWholeGrainCrackers,
    ),
    FoodItems(
      foodTitle: TextConstants.proteinShakeWithMilkBananaAndOats,
      foodImage: PathConstants.proteinShakeWithMilkBananaAndOats,
    ),
    FoodItems(
      foodTitle: TextConstants.peanutButterOnWholeGrainToast,
      foodImage: PathConstants.peanutButterOnWholeGrainToast,
    ),
  ];
  static  List<FoodItems> highProtein_breakfast = [
    FoodItems(
      foodTitle: TextConstants.scrambledEggsWithSpinachAndCheese,
      foodImage: PathConstants.scrambledEggsWithSpinachAndCheese,
    ),
    FoodItems(
      foodTitle: TextConstants.proteinPancakesWithGreekYogurtAndBerries,
      foodImage: PathConstants.proteinPancakesWithGreekYogurtAndBerries,
    ),
    FoodItems(
      foodTitle: TextConstants.cottageCheeseWithFruitAndHoney,
      foodImage: PathConstants.cottageCheeseWithFruitAndHoney,
    ),
    FoodItems(
      foodTitle: TextConstants.turkeySausageWithWholeGrainToastAndAvocado,
      foodImage: PathConstants.turkeySausageWithWholeGrainToastAndAvocado,
    ),
    FoodItems(
      foodTitle: TextConstants.smoothieWithProteinPowderAlmondMilkAndChiaSeeds,
      foodImage: PathConstants.smoothieWithProteinPowderAlmondMilkAndChiaSeeds,
    ),
  ];


  static  List<FoodItems> highProtein_lunch = [
    FoodItems(
      foodTitle: TextConstants.grilledChickenSaladWithAvocadoNutsAndOliveOil,
      foodImage: PathConstants.grilledChickenSaladWithAvocadoNutsAndOliveOil,
    ),
    FoodItems(
      foodTitle: TextConstants.quinoaAndBlackBeanBowlWithGuacamole,
      foodImage: PathConstants.quinoaAndBlackBeanBowlWithGuacamole,
    ),
    FoodItems(
      foodTitle: TextConstants.tunaSaladSandwichOnWholeGrainBread,
      foodImage: PathConstants.tunaSaladSandwichOnWholeGrainBread,
    ),
    FoodItems(
      foodTitle: TextConstants.turkeyBurgerWithSweetPotatoFries,
      foodImage: PathConstants.turkeyBurgerWithSweetPotatoFries,
    ),
    FoodItems(
      foodTitle: TextConstants.lentilSoupWithWholeGrainBread,
      foodImage: PathConstants.lentilSoupWithWholeGrainBread,
    ),
  ];

  static  List<FoodItems> highProtein_dinner = [
    FoodItems(
      foodTitle: TextConstants.bakedChickenBreastWithBrownRiceAndBroccoli,
      foodImage: PathConstants.bakedChickenBreastWithBrownRiceAndBroccoli,
    ),
    FoodItems(
      foodTitle: TextConstants.grilledFishWithQuinoaAndSauteedGreens,
      foodImage: PathConstants.grilledFishWithQuinoaAndSauteedGreens,
    ),
    FoodItems(
      foodTitle: TextConstants.beefStirFryWithVegetablesAndBrownRice,
      foodImage: PathConstants.beefStirFryWithVegetablesAndBrownRice,
    ),
    FoodItems(
      foodTitle: TextConstants.tofuAndVegetableCurryWithBasmatiRice,
      foodImage: PathConstants.tofuAndVegetableCurryWithBasmatiRice,
    ),
    FoodItems(
      foodTitle: TextConstants.grilledShrimpWithWholeWheatPastaAndMarinaraSauce,
      foodImage: PathConstants.grilledShrimpWithWholeWheatPastaAndMarinaraSauce,
    ),
  ];

  static  List<FoodItems> highProtein_snacks = [
    FoodItems(
      foodTitle: TextConstants.proteinBarsOrShakes,
      foodImage: PathConstants.proteinBarsOrShakes,
    ),
    FoodItems(
      foodTitle: TextConstants.eggs,
      foodImage: PathConstants.eggs,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtWithNutsAndHoney,
      foodImage: PathConstants.greekYogurtWithNutsAndHoney,
    ),
    FoodItems(
      foodTitle: TextConstants.cottageCheeseWithPineapple,
      foodImage: PathConstants.cottageCheeseWithPineapple,
    ),
    FoodItems(
      foodTitle: TextConstants.edamameWithSeaSalt,
      foodImage: PathConstants.edamameWithSeaSalt,
    ),
  ];

  static  List<FoodItems> balancedDiet_breakfast = [
    FoodItems(
      foodTitle: TextConstants.wholeGrainToastWithAlmondButterAndBananaSlices,
      foodImage: PathConstants.wholeGrainToastWithAlmondButterAndBananaSlices,
    ),
    FoodItems(
      foodTitle: TextConstants.greekYogurtWithNutsSeedsAndHoney,
      foodImage: PathConstants.greekYogurtWithNutsSeedsAndHoney,
    ),
    FoodItems(
      foodTitle: TextConstants.smoothieWithAvocadoSpinachBananaAndFlaxseed,
      foodImage: PathConstants.smoothieWithAvocadoSpinachBananaAndFlaxseed,
    ),
    FoodItems(
      foodTitle: TextConstants.oatmealWithWalnutsChiaSeedsAndBerries,
      foodImage: PathConstants.oatmealWithWalnutsChiaSeedsAndBerries,
    ),
    FoodItems(
      foodTitle: TextConstants.scrambledEggsWithAvocadoAndCheese,
      foodImage: PathConstants.scrambledEggsWithAvocadoAndCheese,
    ),
  ];

  static  List<FoodItems> balancedDiet_lunch = [
    FoodItems(
      foodTitle: TextConstants.salmonSaladWithMixedGreensAvocadoAndOliveOilDressing,
      foodImage: PathConstants.salmonSaladWithMixedGreensAvocadoAndOliveOilDressing,
    ),
    FoodItems(
      foodTitle: TextConstants.quinoaBowlWithRoastedVegetablesAndTahini,
      foodImage: PathConstants.quinoaBowlWithRoastedVegetablesAndTahini,
    ),
    FoodItems(
      foodTitle: TextConstants.wholeGrainPastaWithPestoChickenAndSideSalad,
      foodImage: PathConstants.wholeGrainPastaWithPestoChickenAndSideSalad,
    ),
    FoodItems(
      foodTitle: TextConstants.moongDalKhichdiWithGheeAndVegetables,
      foodImage: PathConstants.moongDalKhichdiWithGheeAndVegetables,
    ),
    FoodItems(
      foodTitle: TextConstants.paneerTikkaWithMintChutneyAndWholeWheatRoti,
      foodImage: PathConstants.paneerTikkaWithMintChutneyAndWholeWheatRoti,
    ),
  ];

  static  List<FoodItems> balancedDiet_dinner = [
    FoodItems(
      foodTitle: TextConstants.bakedSalmonWithSweetPotatoAndSteamedBroccoli,
      foodImage: PathConstants.bakedSalmonWithSweetPotatoAndSteamedBroccoli,
    ),
    FoodItems(
      foodTitle: TextConstants.chickenCurryWithCoconutMilkAndBasmatiRice,
      foodImage: PathConstants.chickenCurryWithCoconutMilkAndBasmatiRice,
    ),
    FoodItems(
      foodTitle: TextConstants.grilledTofuWithQuinoaAndRoastedVegetables,
      foodImage: PathConstants.grilledTofuWithQuinoaAndRoastedVegetables,
    ),
    FoodItems(
      foodTitle: TextConstants.shrimpAndAvocadoSaladWithOliveOilDressing,
      foodImage: PathConstants.shrimpAndAvocadoSaladWithOliveOilDressing,
    ),
    FoodItems(
      foodTitle: TextConstants.vegetableKhichdiWithGhee,
      foodImage: PathConstants.vegetableKhichdiWithGhee,
    ),
  ];

  static  List<FoodItems> balancedDiet_snacks = [
    FoodItems(
      foodTitle: TextConstants.avocadoSlicesWithSeaSalt,
      foodImage: PathConstants.avocadoSlicesWithSeaSalt,
    ),
    FoodItems(
      foodTitle: TextConstants.almondsAndDarkChocolate,
      foodImage: PathConstants.almondsAndDarkChocolate,
    ),
    FoodItems(
      foodTitle: TextConstants.roastedChanaWithSpices,
      foodImage: PathConstants.roastedChanaWithSpices,
    ),
    FoodItems(
      foodTitle: TextConstants.roastedMakhanaWithSpices,
      foodImage: PathConstants.roastedMakhanaWithSpices,
    ),
    FoodItems(
      foodTitle: TextConstants.almondAndDateLadoo,
      foodImage: PathConstants.almondAndDateLadoo,
    ),
  ];
}