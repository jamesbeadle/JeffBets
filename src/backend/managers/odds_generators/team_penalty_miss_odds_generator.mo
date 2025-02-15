import Float "mo:base/Float";
import BettingTypes "../../types/betting_types";
import BaseOdds "../../utilities/BaseOdds";

module {

  public class TeamPenaltyMissOddsGenerator() {
    public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.MissPenaltyOdds{
      return {
        homeTeam = BaseOdds.HOME_TEAM_PENALTY_MISS;
        awayTeam = BaseOdds.AWAY_TEAM_PENALTY_MISS;
      }
    };
    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.MissPenaltyOdds{
      return {
        homeTeam = BaseOdds.HOME_TEAM_PENALTY_MISS;
        awayTeam = BaseOdds.AWAY_TEAM_PENALTY_MISS;
      }
    };
    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.MissPenaltyOdds{
      return {
        homeTeam = BaseOdds.HOME_TEAM_PENALTY_MISS;
        awayTeam = BaseOdds.AWAY_TEAM_PENALTY_MISS;
      }
    };
    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.MissPenaltyOdds{
      return {
        homeTeam = BaseOdds.HOME_TEAM_PENALTY_MISS;
        awayTeam = BaseOdds.AWAY_TEAM_PENALTY_MISS;
      }
    };
  };
};
