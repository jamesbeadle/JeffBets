import BettingTypes "../../types/betting_types";

module {

  public class HalfTimeCorrectScoreOddsGenerator() {
    public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats) : [BettingTypes.ScoreSelectionOdds]{
      return [];
    };
    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats) : [BettingTypes.ScoreSelectionOdds]{
      return [];
    };
    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats) : [BettingTypes.ScoreSelectionOdds]{
      return [];
    };
    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats) : [BettingTypes.ScoreSelectionOdds]{
      return [];
    };
  };
};
