import BettingTypes "../../types/betting_types";
import BaseOdds "../../utilities/BaseOdds";

module {

  public class GoalsOverUnderOddsGenerator() {

    public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.OverUnderSelectionOdds{
      return {
        overOdds = [
          {
            margin = 0.5;
            odds = BaseOdds.OVER_ODDS_ZERO_POINT_FIVE;
          },
          {
            margin = 1.5;
            odds = BaseOdds.OVER_ODDS_ONE_POINT_FIVE;
          },
          {
            margin = 2.5;
            odds = BaseOdds.OVER_ODDS_TWO_POINT_FIVE;
          },
          {
            margin = 3.5;
            odds = BaseOdds.OVER_ODDS_THREE_POINT_FIVE;
          },
          {
            margin = 4.5;
            odds = BaseOdds.OVER_ODDS_FOUR_POINT_FIVE;
          },
          {
            margin = 5.5;
            odds = BaseOdds.OVER_ODDS_FIVE_POINT_FIVE;
          },
          {
            margin = 6.5;
            odds = BaseOdds.OVER_ODDS_SIX_POINT_FIVE;
          },
          {
            margin = 7.5;
            odds = BaseOdds.OVER_ODDS_SEVEN_POINT_FIVE;
          }
        ];
        underOdds = [
          {
            margin = 0.5;
            odds = BaseOdds.UNDER_ODDS_ZERO_POINT_FIVE;
          },
          {
            margin = 1.5;
            odds = BaseOdds.UNDER_ODDS_ONE_POINT_FIVE;
          },
          {
            margin = 2.5;
            odds = BaseOdds.UNDER_ODDS_TWO_POINT_FIVE;
          },
          {
            margin = 3.5;
            odds = BaseOdds.UNDER_ODDS_THREE_POINT_FIVE;
          },
          {
            margin = 4.5;
            odds = BaseOdds.UNDER_ODDS_FOUR_POINT_FIVE;
          },
          {
            margin = 5.5;
            odds = BaseOdds.UNDER_ODDS_FIVE_POINT_FIVE;
          },
          {
            margin = 6.5;
            odds = BaseOdds.UNDER_ODDS_SIX_POINT_FIVE;
          },
          {
            margin = 7.5;
            odds = BaseOdds.UNDER_ODDS_SEVEN_POINT_FIVE;
          }
        ];
      };
    };

    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.OverUnderSelectionOdds{
      return {
        overOdds = [
          {
            margin = 0.5;
            odds = BaseOdds.OVER_ODDS_ZERO_POINT_FIVE;
          },
          {
            margin = 1.5;
            odds = BaseOdds.OVER_ODDS_ONE_POINT_FIVE;
          },
          {
            margin = 2.5;
            odds = BaseOdds.OVER_ODDS_TWO_POINT_FIVE;
          },
          {
            margin = 3.5;
            odds = BaseOdds.OVER_ODDS_THREE_POINT_FIVE;
          },
          {
            margin = 4.5;
            odds = BaseOdds.OVER_ODDS_FOUR_POINT_FIVE;
          },
          {
            margin = 5.5;
            odds = BaseOdds.OVER_ODDS_FIVE_POINT_FIVE;
          },
          {
            margin = 6.5;
            odds = BaseOdds.OVER_ODDS_SIX_POINT_FIVE;
          },
          {
            margin = 7.5;
            odds = BaseOdds.OVER_ODDS_SEVEN_POINT_FIVE;
          }
        ];
        underOdds = [
          {
            margin = 0.5;
            odds = BaseOdds.UNDER_ODDS_ZERO_POINT_FIVE;
          },
          {
            margin = 1.5;
            odds = BaseOdds.UNDER_ODDS_ONE_POINT_FIVE;
          },
          {
            margin = 2.5;
            odds = BaseOdds.UNDER_ODDS_TWO_POINT_FIVE;
          },
          {
            margin = 3.5;
            odds = BaseOdds.UNDER_ODDS_THREE_POINT_FIVE;
          },
          {
            margin = 4.5;
            odds = BaseOdds.UNDER_ODDS_FOUR_POINT_FIVE;
          },
          {
            margin = 5.5;
            odds = BaseOdds.UNDER_ODDS_FIVE_POINT_FIVE;
          },
          {
            margin = 6.5;
            odds = BaseOdds.UNDER_ODDS_SIX_POINT_FIVE;
          },
          {
            margin = 7.5;
            odds = BaseOdds.UNDER_ODDS_SEVEN_POINT_FIVE;
          }
        ];
      };
    };

    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.OverUnderSelectionOdds{
      return {
        overOdds = [
          {
            margin = 0.5;
            odds = BaseOdds.OVER_ODDS_ZERO_POINT_FIVE;
          },
          {
            margin = 1.5;
            odds = BaseOdds.OVER_ODDS_ONE_POINT_FIVE;
          },
          {
            margin = 2.5;
            odds = BaseOdds.OVER_ODDS_TWO_POINT_FIVE;
          },
          {
            margin = 3.5;
            odds = BaseOdds.OVER_ODDS_THREE_POINT_FIVE;
          },
          {
            margin = 4.5;
            odds = BaseOdds.OVER_ODDS_FOUR_POINT_FIVE;
          },
          {
            margin = 5.5;
            odds = BaseOdds.OVER_ODDS_FIVE_POINT_FIVE;
          },
          {
            margin = 6.5;
            odds = BaseOdds.OVER_ODDS_SIX_POINT_FIVE;
          },
          {
            margin = 7.5;
            odds = BaseOdds.OVER_ODDS_SEVEN_POINT_FIVE;
          }
        ];
        underOdds = [
          {
            margin = 0.5;
            odds = BaseOdds.UNDER_ODDS_ZERO_POINT_FIVE;
          },
          {
            margin = 1.5;
            odds = BaseOdds.UNDER_ODDS_ONE_POINT_FIVE;
          },
          {
            margin = 2.5;
            odds = BaseOdds.UNDER_ODDS_TWO_POINT_FIVE;
          },
          {
            margin = 3.5;
            odds = BaseOdds.UNDER_ODDS_THREE_POINT_FIVE;
          },
          {
            margin = 4.5;
            odds = BaseOdds.UNDER_ODDS_FOUR_POINT_FIVE;
          },
          {
            margin = 5.5;
            odds = BaseOdds.UNDER_ODDS_FIVE_POINT_FIVE;
          },
          {
            margin = 6.5;
            odds = BaseOdds.UNDER_ODDS_SIX_POINT_FIVE;
          },
          {
            margin = 7.5;
            odds = BaseOdds.UNDER_ODDS_SEVEN_POINT_FIVE;
          }
        ];
      };
    };

    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.OverUnderSelectionOdds{
      return {
        overOdds = [
          {
            margin = 0.5;
            odds = BaseOdds.OVER_ODDS_ZERO_POINT_FIVE;
          },
          {
            margin = 1.5;
            odds = BaseOdds.OVER_ODDS_ONE_POINT_FIVE;
          },
          {
            margin = 2.5;
            odds = BaseOdds.OVER_ODDS_TWO_POINT_FIVE;
          },
          {
            margin = 3.5;
            odds = BaseOdds.OVER_ODDS_THREE_POINT_FIVE;
          },
          {
            margin = 4.5;
            odds = BaseOdds.OVER_ODDS_FOUR_POINT_FIVE;
          },
          {
            margin = 5.5;
            odds = BaseOdds.OVER_ODDS_FIVE_POINT_FIVE;
          },
          {
            margin = 6.5;
            odds = BaseOdds.OVER_ODDS_SIX_POINT_FIVE;
          },
          {
            margin = 7.5;
            odds = BaseOdds.OVER_ODDS_SEVEN_POINT_FIVE;
          }
        ];
        underOdds = [
          {
            margin = 0.5;
            odds = BaseOdds.UNDER_ODDS_ZERO_POINT_FIVE;
          },
          {
            margin = 1.5;
            odds = BaseOdds.UNDER_ODDS_ONE_POINT_FIVE;
          },
          {
            margin = 2.5;
            odds = BaseOdds.UNDER_ODDS_TWO_POINT_FIVE;
          },
          {
            margin = 3.5;
            odds = BaseOdds.UNDER_ODDS_THREE_POINT_FIVE;
          },
          {
            margin = 4.5;
            odds = BaseOdds.UNDER_ODDS_FOUR_POINT_FIVE;
          },
          {
            margin = 5.5;
            odds = BaseOdds.UNDER_ODDS_FIVE_POINT_FIVE;
          },
          {
            margin = 6.5;
            odds = BaseOdds.UNDER_ODDS_SIX_POINT_FIVE;
          },
          {
            margin = 7.5;
            odds = BaseOdds.UNDER_ODDS_SEVEN_POINT_FIVE;
          }
        ];
      };
    };
  };
};
