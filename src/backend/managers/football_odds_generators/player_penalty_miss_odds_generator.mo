import Float "mo:base/Float";
import PlayerQueries "mo:waterway-mops/queries/football-queries/PlayerQueries";
import BettingTypes "../../types/betting_types";

module {

  public class PlayerPenaltyMissOddsGenerator() {
    public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats, player: PlayerQueries.Player) : Float{

      

      if(player.position == #Forward){
        return 0.5;
      };

      return 1;
    };
    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats, player: PlayerQueries.Player) : Float{
      return 1;
    };
    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats, player: PlayerQueries.Player) : Float{
      return 1;
    };
    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats, player: PlayerQueries.Player) : Float{
      return 1;
    };
  };
};
