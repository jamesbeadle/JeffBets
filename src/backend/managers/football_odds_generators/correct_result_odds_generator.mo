import BettingTypes "../../types/betting_types";
import BaseOdds "../../utilities/BaseOdds";
import Float "mo:base/Float";
import Nat8 "mo:base/Nat8";
import Debug "mo:base/Debug";
import BettingUtilities "../../utilities/betting_utilities";

module {

  public class CorrectResultOddsGenerator() {

    public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.TeamSelectionOdds{
      var home_odds_factor: Float = 1;
      var away_odds_factor: Float = 1;
      var draw_odds_factor: Float = 1;
      
      let homeTeamGood = stats.homeTeamPriorSeasonFinish <= 4;
      let homeTeamAverage = stats.homeTeamPriorSeasonFinish > 4 and stats.homeTeamPriorSeasonFinish < 13;
      let homeTeamBad = stats.homeTeamPriorSeasonFinish >= 13;
      let awayTeamGood = stats.awayTeamPriorSeasonFinish <= 4;
      let awayTeamAverage = stats.awayTeamPriorSeasonFinish > 4 and stats.awayTeamPriorSeasonFinish < 13;
      let awayTeamBad = stats.awayTeamPriorSeasonFinish >= 13;

      if(homeTeamGood){
        home_odds_factor := home_odds_factor * 0.5;
        draw_odds_factor := draw_odds_factor * 1.5;
        away_odds_factor := away_odds_factor * 1.5;
      };

      if(homeTeamAverage){
        home_odds_factor := home_odds_factor * 1;
        draw_odds_factor := draw_odds_factor * 1;
        away_odds_factor := away_odds_factor * 1;
      };

      if(homeTeamBad){
        home_odds_factor := home_odds_factor * 1.5;
        draw_odds_factor := draw_odds_factor * 0.5;
        away_odds_factor := away_odds_factor * 0.5;
      };

      if(homeTeamGood and awayTeamGood){
        home_odds_factor := home_odds_factor * 2;
        draw_odds_factor := draw_odds_factor * 1;
        away_odds_factor := away_odds_factor * 0.5;
      };

      if(homeTeamGood and awayTeamAverage){
          home_odds_factor := home_odds_factor * 1.2;
          draw_odds_factor := draw_odds_factor * 1;
          away_odds_factor := away_odds_factor * 1.5;
      };

      if(homeTeamGood and awayTeamBad){
          home_odds_factor := 0.625; 
          draw_odds_factor := 1;
          away_odds_factor := 2.5; 
      };

      if(homeTeamAverage and awayTeamGood){
          home_odds_factor := 1.25;
          draw_odds_factor := 1;
          away_odds_factor := 0.75;
      };

      if(homeTeamAverage and awayTeamAverage){
          home_odds_factor := 1.125;
          draw_odds_factor := 1;
          away_odds_factor := 0.875;
      };

      if(homeTeamAverage and awayTeamBad){
          home_odds_factor := 0.75; //bournemouth
          draw_odds_factor := 1.125;
          away_odds_factor := 1.25; //wolves
      };

      if(homeTeamBad and awayTeamGood){
          home_odds_factor := 1.25;
          draw_odds_factor := 1;
          away_odds_factor := 0.75;
      };

      if(homeTeamBad and awayTeamAverage){
          home_odds_factor := 1.125;
          draw_odds_factor := 1;
          away_odds_factor := 0.875;
      };

      if(homeTeamBad and awayTeamBad){
          home_odds_factor := 1.5; //Leicester
          draw_odds_factor := 0.9;
          away_odds_factor := 0.5; //Brentford
      };
      
      return {
        awayOdds = BettingUtilities.formatOdds(away_odds_factor, BaseOdds.AWAY_WIN_ODDS);
        drawOdds = BettingUtilities.formatOdds(draw_odds_factor, BaseOdds.DRAW_ODDS);
        homeOdds = BettingUtilities.formatOdds(home_odds_factor, BaseOdds.HOME_WIN_ODDS);
      }
    };   

    public func getOffFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.TeamSelectionOdds{
      var home_odds_factor: Float = 1;
      var away_odds_factor: Float = 1;
      var draw_odds_factor: Float = 1;
      
      let homeTeamGood = stats.homeTeamPriorSeasonFinish <= 4;
      let homeTeamAverage = stats.homeTeamPriorSeasonFinish > 4 and stats.homeTeamPriorSeasonFinish < 13;
      let homeTeamBad = stats.homeTeamPriorSeasonFinish >= 13;
      let awayTeamGood = stats.awayTeamPriorSeasonFinish <= 4;
      let awayTeamAverage = stats.awayTeamPriorSeasonFinish > 4 and stats.awayTeamPriorSeasonFinish < 13;
      let awayTeamBad = stats.awayTeamPriorSeasonFinish >= 13;

      if(homeTeamGood){

        if(awayTeamGood){
          home_odds_factor := 1.25; //Man City
          draw_odds_factor := 1;
          away_odds_factor := 0.55; //Liverpool
        };
        
        if(awayTeamAverage){
          home_odds_factor := 1.25; //villa
          draw_odds_factor := 0.9;
          away_odds_factor := 0.55; //chelsea
        };

        if(awayTeamBad){
          home_odds_factor := 1.25; //inferred
          draw_odds_factor := 0.8; //inferred
          away_odds_factor := 0.55; //inferred
        };
        
      };

      if(homeTeamAverage){
        if(awayTeamGood){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };

        if(awayTeamAverage){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
        
        if(awayTeamBad){
          home_odds_factor := 0.835; //Newcastle
          draw_odds_factor := 1;
          away_odds_factor := 0.9375; //Forest
        };
      };

      if(homeTeamBad){
        if(awayTeamGood){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };

        if(awayTeamAverage){
          home_odds_factor := 1; 
          draw_odds_factor := 1;
          away_odds_factor := 1; 
        };
        
        if(awayTeamBad){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
      };
      
      return {
        awayOdds = BettingUtilities.formatOdds(away_odds_factor, BaseOdds.AWAY_WIN_ODDS);
        drawOdds = BettingUtilities.formatOdds(draw_odds_factor, BaseOdds.DRAW_ODDS);
        homeOdds = BettingUtilities.formatOdds(home_odds_factor, BaseOdds.HOME_WIN_ODDS);
      }
    };

    public func getOnFormAwayFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.TeamSelectionOdds{
      var home_odds_factor: Float = 1;
      var away_odds_factor: Float = 1;
      var draw_odds_factor: Float = 1;
      
      let homeTeamGood = stats.homeTeamPriorSeasonFinish <= 4;
      let homeTeamAverage = stats.homeTeamPriorSeasonFinish > 4 and stats.homeTeamPriorSeasonFinish < 13;
      let homeTeamBad = stats.homeTeamPriorSeasonFinish >= 13;
      let awayTeamGood = stats.awayTeamPriorSeasonFinish <= 4;
      let awayTeamAverage = stats.awayTeamPriorSeasonFinish > 4 and stats.awayTeamPriorSeasonFinish < 13;
      let awayTeamBad = stats.awayTeamPriorSeasonFinish >= 13;

      if(homeTeamGood){

        if(awayTeamGood){
          home_odds_factor := 1.75; //aston villa
          draw_odds_factor := 1;
          away_odds_factor := 0.425; //liverpool
        };
        
        if(awayTeamAverage){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };

        if(awayTeamBad){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
        
      };

      if(homeTeamAverage){
        if(awayTeamGood){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };

        if(awayTeamAverage){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
        
        if(awayTeamBad){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
      };

      if(homeTeamBad){
        if(awayTeamGood){
          home_odds_factor := 1; 
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };

        if(awayTeamAverage){
          home_odds_factor := 1.5; //ipswich
          draw_odds_factor := 1;
          away_odds_factor := 0.4375; //tottenham
        };
        
        if(awayTeamBad){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
      };
      
      return {
        awayOdds = BettingUtilities.formatOdds(away_odds_factor, BaseOdds.AWAY_WIN_ODDS);
        drawOdds = BettingUtilities.formatOdds(draw_odds_factor, BaseOdds.DRAW_ODDS);
        homeOdds = BettingUtilities.formatOdds(home_odds_factor, BaseOdds.HOME_WIN_ODDS);
      }
    };

    public func getOffFormAwayFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.TeamSelectionOdds{
      var home_odds_factor: Float = 1;
      var away_odds_factor: Float = 1;
      var draw_odds_factor: Float = 1;
      
      let homeTeamGood = stats.homeTeamPriorSeasonFinish <= 4;
      let homeTeamAverage = stats.homeTeamPriorSeasonFinish > 4 and stats.homeTeamPriorSeasonFinish < 13;
      let homeTeamBad = stats.homeTeamPriorSeasonFinish >= 13;
      let awayTeamGood = stats.awayTeamPriorSeasonFinish <= 4;
      let awayTeamAverage = stats.awayTeamPriorSeasonFinish > 4 and stats.awayTeamPriorSeasonFinish < 13;
      let awayTeamBad = stats.awayTeamPriorSeasonFinish >= 13;

      if(homeTeamGood){

        if(awayTeamGood){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
        
        if(awayTeamAverage){
          home_odds_factor := 1.125;
          draw_odds_factor := 0.85;
          away_odds_factor := 0.6;
        };

        if(awayTeamBad){
          home_odds_factor := 1; 
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
        
      };

      if(homeTeamAverage){
        if(awayTeamGood){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };

        if(awayTeamAverage){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
        
        if(awayTeamBad){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
      };

      if(homeTeamBad){
        if(awayTeamGood){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };

        if(awayTeamAverage){
          home_odds_factor := 1; //Fulham //??southampton brighton came out badly
          draw_odds_factor := 0.9;
          away_odds_factor := 0.825; //Palace
        };
        
        if(awayTeamBad){
          home_odds_factor := 1;
          draw_odds_factor := 1;
          away_odds_factor := 1;
        };
      };
      
      return {
        awayOdds = BettingUtilities.formatOdds(away_odds_factor, BaseOdds.AWAY_WIN_ODDS);
        drawOdds = BettingUtilities.formatOdds(draw_odds_factor, BaseOdds.DRAW_ODDS);
        homeOdds = BettingUtilities.formatOdds(home_odds_factor, BaseOdds.HOME_WIN_ODDS);
      }
    };
  };
};
