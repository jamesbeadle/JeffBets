import BettingTypes "../types/betting_types";
import BaseOdds "../utilities/BaseOdds";
import Float "mo:base/Float";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Nat8 "mo:base/Nat8";
import FootballTypes "mo:waterway-mops/FootballTypes";
import FootballDTOs "../dtos/football_dtos";
import BettingUtilities "../utilities/betting_utilities";

module {

  public class ResultsOddsGenerator() {
    public func getOnFormHomeFavouriteOdds(stats: BettingTypes.Stats) : BettingTypes.TeamSelectionOdds{
      var home_odds_factor: Float = 1;
      var away_odds_factor: Float = 1;
      var draw_odds_factor: Float = 1;
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
      return {
        awayOdds = BettingUtilities.formatOdds(away_odds_factor, BaseOdds.AWAY_WIN_ODDS);
        drawOdds = BettingUtilities.formatOdds(draw_odds_factor, BaseOdds.DRAW_ODDS);
        homeOdds = BettingUtilities.formatOdds(home_odds_factor, BaseOdds.HOME_WIN_ODDS);
      }
    };
  };
};
