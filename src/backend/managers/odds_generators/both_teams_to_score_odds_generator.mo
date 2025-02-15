import BettingTypes "../../types/betting_types";
import BaseOdds "../../utilities/BaseOdds";

module {

  public class BothTeamsToScoreOddsGenerator() {
     public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.YesNoSelectionOdds{
        return {
            noOdds = BaseOdds.BOTH_TEAMS_NOT_TO_SCORE; 
            yesOdds = BaseOdds.BOTH_TEAMS_TO_SCORE;
        };
    };
    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.YesNoSelectionOdds{
        return {
            noOdds = BaseOdds.BOTH_TEAMS_NOT_TO_SCORE; 
            yesOdds = BaseOdds.BOTH_TEAMS_TO_SCORE;
        };
    };
    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.YesNoSelectionOdds{
        return {
            noOdds = BaseOdds.BOTH_TEAMS_NOT_TO_SCORE; 
            yesOdds = BaseOdds.BOTH_TEAMS_TO_SCORE;
        };
    };
    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.YesNoSelectionOdds{
        return {
            noOdds = BaseOdds.BOTH_TEAMS_NOT_TO_SCORE; 
            yesOdds = BaseOdds.BOTH_TEAMS_TO_SCORE;
        };
    };
  };
};
