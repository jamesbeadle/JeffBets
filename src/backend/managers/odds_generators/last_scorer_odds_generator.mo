import Float "mo:base/Float";
import BettingTypes "../../types/betting_types";
import FootballDTOs "../../dtos/football_dtos";

module {

  public class LastScorerOddsGenerator() {
    public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      return 1;
    };
    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      return 1;
    };
    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      return 1;
    };
    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      return 1;
    };
  };
};
