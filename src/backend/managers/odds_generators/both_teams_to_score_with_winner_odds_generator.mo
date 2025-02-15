import Float "mo:base/Float";
import BettingTypes "../../types/betting_types";
import BaseOdds "../../utilities/BaseOdds";

module {

  public class BothTeamsToScoreWithWinnerOddsGenerator() {
    public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats) : [BettingTypes.ResultAndYesNoSelectionOdds]{
        return [];
    };
    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats) : [BettingTypes.ResultAndYesNoSelectionOdds]{
        return [];
    };
    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats) : [BettingTypes.ResultAndYesNoSelectionOdds]{
        return [];
    };
    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats) : [BettingTypes.ResultAndYesNoSelectionOdds]{
        return [];
    };
  };
};
