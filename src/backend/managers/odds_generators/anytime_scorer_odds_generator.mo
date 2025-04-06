import Float "mo:base/Float";
import BettingTypes "../../types/betting_types";

module {

  public class AnytimeScorerOddsGenerator() {
     public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      
      let homeTeamGood = stats.homeTeamPriorSeasonFinish <= 4;
      let homeTeamAverage = stats.homeTeamPriorSeasonFinish > 4 and stats.homeTeamPriorSeasonFinish < 13;
      let homeTeamBad = stats.homeTeamPriorSeasonFinish >= 13;
      let awayTeamGood = stats.awayTeamPriorSeasonFinish <= 4;
      let awayTeamAverage = stats.awayTeamPriorSeasonFinish > 4 and stats.awayTeamPriorSeasonFinish < 13;
      let awayTeamBad = stats.awayTeamPriorSeasonFinish >= 13;

      if(homeTeamGood){

        if(awayTeamGood){
        };
        
        if(awayTeamAverage){
        };

        if(awayTeamBad){
        };
        
      };

      if(homeTeamAverage){
        if(awayTeamGood){
        };

        if(awayTeamAverage){
        };
        
        if(awayTeamBad){
        };
      };

      if(homeTeamBad){
        if(awayTeamGood){
        };

        if(awayTeamAverage){
        };
        
        if(awayTeamBad){
        };
      };
      
      return 0;
    };

    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      
      let homeTeamGood = stats.homeTeamPriorSeasonFinish <= 4;
      let homeTeamAverage = stats.homeTeamPriorSeasonFinish > 4 and stats.homeTeamPriorSeasonFinish < 13;
      let homeTeamBad = stats.homeTeamPriorSeasonFinish >= 13;
      let awayTeamGood = stats.awayTeamPriorSeasonFinish <= 4;
      let awayTeamAverage = stats.awayTeamPriorSeasonFinish > 4 and stats.awayTeamPriorSeasonFinish < 13;
      let awayTeamBad = stats.awayTeamPriorSeasonFinish >= 13;

      if(homeTeamGood){

        if(awayTeamGood){
        };
        
        if(awayTeamAverage){
        };

        if(awayTeamBad){
        };
        
      };

      if(homeTeamAverage){
        if(awayTeamGood){
        };

        if(awayTeamAverage){
        };
        
        if(awayTeamBad){
        };
      };

      if(homeTeamBad){
        if(awayTeamGood){
        };

        if(awayTeamAverage){
        };
        
        if(awayTeamBad){
        };
      };
      
      return 0;
    };

    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      
      let homeTeamGood = stats.homeTeamPriorSeasonFinish <= 4;
      let homeTeamAverage = stats.homeTeamPriorSeasonFinish > 4 and stats.homeTeamPriorSeasonFinish < 13;
      let homeTeamBad = stats.homeTeamPriorSeasonFinish >= 13;
      let awayTeamGood = stats.awayTeamPriorSeasonFinish <= 4;
      let awayTeamAverage = stats.awayTeamPriorSeasonFinish > 4 and stats.awayTeamPriorSeasonFinish < 13;
      let awayTeamBad = stats.awayTeamPriorSeasonFinish >= 13;

      if(homeTeamGood){

        if(awayTeamGood){
        };
        
        if(awayTeamAverage){
        };

        if(awayTeamBad){
        };
        
      };

      if(homeTeamAverage){
        if(awayTeamGood){
        };

        if(awayTeamAverage){
        };
        
        if(awayTeamBad){
        };
      };

      if(homeTeamBad){
        if(awayTeamGood){
        };

        if(awayTeamAverage){
        };
        
        if(awayTeamBad){
        };
      };
      
      return 0;
    };

    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      
      let homeTeamGood = stats.homeTeamPriorSeasonFinish <= 4;
      let homeTeamAverage = stats.homeTeamPriorSeasonFinish > 4 and stats.homeTeamPriorSeasonFinish < 13;
      let homeTeamBad = stats.homeTeamPriorSeasonFinish >= 13;
      let awayTeamGood = stats.awayTeamPriorSeasonFinish <= 4;
      let awayTeamAverage = stats.awayTeamPriorSeasonFinish > 4 and stats.awayTeamPriorSeasonFinish < 13;
      let awayTeamBad = stats.awayTeamPriorSeasonFinish >= 13;

      if(homeTeamGood){

        if(awayTeamGood){
        };
        
        if(awayTeamAverage){
        };

        if(awayTeamBad){
        };
        
      };

      if(homeTeamAverage){
        if(awayTeamGood){
        };

        if(awayTeamAverage){
        };
        
        if(awayTeamBad){
        };
      };

      if(homeTeamBad){
        if(awayTeamGood){
        };

        if(awayTeamAverage){
        };
        
        if(awayTeamBad){
        };
      };
      
      return 0;
    };
  };
};
