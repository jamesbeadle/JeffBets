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
      
      let totalClubs = (stats.totalGameweeks / 2) + 1;  
      var finishDifference: Float = (Float.fromInt(stats.awayTeamPriorSeasonFinish) / Float.fromInt(Nat8.toNat(totalClubs))) - (Float.fromInt(stats.homeTeamPriorSeasonFinish) / Float.fromInt(Nat8.toNat(totalClubs)));
      if(finishDifference <= 2){
        finishDifference := 2;
      };
      
      if(finishDifference > 20){
        finishDifference := 20;
      };
      
      if(stats.homeTeamPriorSeasonFinish < 5){
        //top 4 club odds
        home_odds_factor := 1.25 / finishDifference;
        draw_odds_factor := 4 / finishDifference;
        away_odds_factor := 6 / finishDifference;
      };

      if(stats.homeTeamPriorSeasonFinish >= 5 and stats.homeTeamPriorSeasonFinish < 13){
        //mid table last season
        home_odds_factor := 1.5 / finishDifference;
        draw_odds_factor := 3 / finishDifference;
        away_odds_factor := 4 / finishDifference;
      };

      if(stats.homeTeamPriorSeasonFinish >= 13){
        //bad last season
        home_odds_factor := 1.75 / finishDifference;
        draw_odds_factor := 2 / finishDifference;
        away_odds_factor := 2 / finishDifference;
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

      let totalClubs = (stats.totalGameweeks / 2) + 1;  
      var finishDifference: Float = (Float.fromInt(stats.awayTeamPriorSeasonFinish) / Float.fromInt(Nat8.toNat(totalClubs))) - (Float.fromInt(stats.homeTeamPriorSeasonFinish) / Float.fromInt(Nat8.toNat(totalClubs)));
      if(finishDifference <= 2){
        finishDifference := 2;
      };
      
      if(finishDifference > 20){
        finishDifference := 20;
      };

      if(stats.homeTeamPriorSeasonFinish < 5){
        //top 4 club odds
        home_odds_factor := 1.5 / finishDifference;
        draw_odds_factor := 3.5 / finishDifference;
        away_odds_factor := 4 / finishDifference;
      };

      if(stats.homeTeamPriorSeasonFinish >= 5 and stats.homeTeamPriorSeasonFinish < 13){
        //mid table last season
      };

      if(stats.homeTeamPriorSeasonFinish >= 13){
        //bad last season
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

      if(stats.homeTeamPriorSeasonFinish < 5){
        //top 4 club odds
      };

      if(stats.homeTeamPriorSeasonFinish >= 5 and stats.homeTeamPriorSeasonFinish < 13){
        //mid table last season
      };

      if(stats.homeTeamPriorSeasonFinish >= 13){
        //bad last season
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

      if(stats.homeTeamPriorSeasonFinish < 5){
        //top 4 club odds
      };

      if(stats.homeTeamPriorSeasonFinish >= 5 and stats.homeTeamPriorSeasonFinish < 13){
        //mid table last season
      };

      if(stats.homeTeamPriorSeasonFinish >= 13){
        //bad last season
      };

      return {
        awayOdds = BettingUtilities.formatOdds(away_odds_factor, BaseOdds.AWAY_WIN_ODDS);
        drawOdds = BettingUtilities.formatOdds(draw_odds_factor, BaseOdds.DRAW_ODDS);
        homeOdds = BettingUtilities.formatOdds(home_odds_factor, BaseOdds.HOME_WIN_ODDS);
      }
    };
  };
};
