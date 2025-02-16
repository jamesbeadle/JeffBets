import BettingTypes "../types/betting_types";
import Float "mo:base/Float";
import Debug "mo:base/Debug";
import CorrectResultOddsGenerator "odds_generators/correct_result_odds_generator";
import FirstAssistOddsGenerator "odds_generators/first_assist_odds_generator";
import AnytimeAssistOddsGenerator "odds_generators/anytime_assist_odds_generator";
import LastAssistOddsGenerator "odds_generators/last_assist_odds_generator";
import FirstScorerOddsGenerator "odds_generators/first_scorer_odds_generator";
import AnytimeScorerOddsGenerator "odds_generators/anytime_scorer_odds_generator";
import LastScorerOddsGenerator "odds_generators/last_scorer_odds_generator";
import ScoreBraceOddsGenerator "odds_generators/score_brace_odds_generator";
import ScoreHattrickOddsGenerator "odds_generators/score_hattrick_odds_generator";
import PlayerPenaltyMissOddsGenerator "odds_generators/player_penalty_miss_odds_generator";
import TeamPenaltyMissOddsGenerator "odds_generators/team_penalty_miss_odds_generator";
import YellowCardOddsGenerator "odds_generators/yellow_card_odds_generator";
import RedCardOddsGenerator "odds_generators/red_card_odds_generator";
import BothTeamsToScoreOddsGenerator "odds_generators/both_teams_to_score_odds_generator";
import BothTeamsToScoreWithWinnerOddsGenerator "odds_generators/both_teams_to_score_with_winner_odds_generator";
import CorrectScoreOddsGenerator "odds_generators/correct_score_odds_generator";
import GoalsOverUnderOddsGenerator "odds_generators/goals_over_under_odds_generator";
import HalfTimeFullTimeOddsGenerator "odds_generators/half_time_full_time_odds_generator";
import HalfTimeCorrectScoreOddsGenerator "odds_generators/half_time_correct_score_odds_generator";
import FootballDTOs "../dtos/football_dtos";

module {

  public class OddsGenerator() {

    private let correctResultOddsGenerator = CorrectResultOddsGenerator.CorrectResultOddsGenerator();
    private let firstAssistOddsGenerator = FirstAssistOddsGenerator.FirstAssistOddsGenerator();
    private let anytimeAssistOddsGenerator = AnytimeAssistOddsGenerator.AnytimeAssistOddsGenerator();
    private let lastAssistOddsGenerator = LastAssistOddsGenerator.LastAssistOddsGenerator();
    private let firstScorerOddsGenerator = FirstScorerOddsGenerator.FirstScorerOddsGenerator();
    private let anytimeScorerOddsGenerator = AnytimeScorerOddsGenerator.AnytimeScorerOddsGenerator();
    private let lastScorerOddsGenerator = LastScorerOddsGenerator.LastScorerOddsGenerator();
    private let scoreBraceOddsGenerator = ScoreBraceOddsGenerator.ScoreBraceOddsGenerator();
    private let scoreHattrickOddsGenerator = ScoreHattrickOddsGenerator.ScoreHattrickOddsGenerator();
    private let playerPenaltyMissOddsGenerator = PlayerPenaltyMissOddsGenerator.PlayerPenaltyMissOddsGenerator();
    private let teamPenaltyMissOddsGenerator = TeamPenaltyMissOddsGenerator.TeamPenaltyMissOddsGenerator();
    private let yellowCardOddsGenerator = YellowCardOddsGenerator.YellowCardOddsGenerator();
    private let redCardOddsGenerator = RedCardOddsGenerator.RedCardOddsGenerator();
    private let bothTeamsToScoreOddsGenerator = BothTeamsToScoreOddsGenerator.BothTeamsToScoreOddsGenerator();
    private let bothTeamsToScoreWithWinnerOddsGenerator = BothTeamsToScoreWithWinnerOddsGenerator.BothTeamsToScoreWithWinnerOddsGenerator();
    private let correctScoreOddsGenerator = CorrectScoreOddsGenerator.CorrectScoreOddsGenerator();
    private let goalsOverUnderOddsGenerator = GoalsOverUnderOddsGenerator.GoalsOverUnderOddsGenerator();
    private let halfTimeFullTimeOddsGenerator = HalfTimeFullTimeOddsGenerator.HalfTimeFullTimeOddsGenerator();
    private let halfTimeCorrectScoreOddsGenerator = HalfTimeCorrectScoreOddsGenerator.HalfTimeCorrectScoreOddsGenerator();
    
    

    public func getCorrectResultOdds(stats: BettingTypes.Stats) : BettingTypes.TeamSelectionOdds{
      
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return correctResultOddsGenerator.getOnFormHomeFavouriteOdds(stats);
      };

      if(homeFavourite and not homeFormBetter){
        return correctResultOddsGenerator.getOffFormHomeFavouriteOdds(stats);
      };

      if(not homeFavourite and homeFormBetter){
        return correctResultOddsGenerator.getOffFormAwayFavouriteOdds(stats);
      };
      
      return correctResultOddsGenerator.getOnFormAwayFavouriteOdds(stats);
    };
    
    public func getFirstAssistOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return firstAssistOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return firstAssistOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return firstAssistOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return firstAssistOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getAnytimeAssistOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return anytimeAssistOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return anytimeAssistOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return anytimeAssistOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return anytimeAssistOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getLastAssistOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return lastAssistOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return lastAssistOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return lastAssistOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return lastAssistOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getFirstGoalscorerOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return firstScorerOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return firstScorerOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return firstScorerOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return firstScorerOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };

    public func getAnytimeScorerOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return anytimeScorerOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return anytimeScorerOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return anytimeScorerOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return anytimeScorerOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getLastScorerOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return lastScorerOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return lastScorerOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return lastScorerOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return lastScorerOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getScoresBraceOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return scoreBraceOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return scoreBraceOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return scoreBraceOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return scoreBraceOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getScoreHatrickOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return scoreHattrickOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return scoreHattrickOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return scoreHattrickOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return scoreHattrickOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getPlayerPenaltyMissOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return playerPenaltyMissOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return playerPenaltyMissOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return playerPenaltyMissOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return playerPenaltyMissOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getTeamPenaltyMissOdds(stats: BettingTypes.Stats) : BettingTypes.MissPenaltyOdds{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return teamPenaltyMissOddsGenerator.getOnFormHomeFavouriteOdds(stats);
      };

      if(homeFavourite and not homeFormBetter){
        return teamPenaltyMissOddsGenerator.getOffFormHomeFavouriteOdds(stats);
      };

      if(not homeFavourite and homeFormBetter){
        return teamPenaltyMissOddsGenerator.getOffFormAwayFavouriteOdds(stats);
      };
      
      return teamPenaltyMissOddsGenerator.getOnFormAwayFavouriteOdds(stats);
    };
    
    public func getYellowCardOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return yellowCardOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return yellowCardOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return yellowCardOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return yellowCardOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };
    
    public func getRedCardOdds(stats: BettingTypes.Stats, player: FootballDTOs.PlayerDTO) : Float{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return redCardOddsGenerator.getOnFormHomeFavouriteOdds(stats, player);
      };

      if(homeFavourite and not homeFormBetter){
        return redCardOddsGenerator.getOffFormHomeFavouriteOdds(stats, player);
      };

      if(not homeFavourite and homeFormBetter){
        return redCardOddsGenerator.getOffFormAwayFavouriteOdds(stats, player);
      };
      
      return redCardOddsGenerator.getOnFormAwayFavouriteOdds(stats, player);
    };

    public func getBothTeamsToScoreOdds(stats: BettingTypes.Stats) : BettingTypes.YesNoSelectionOdds {
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return bothTeamsToScoreOddsGenerator.getOnFormHomeFavouriteOdds(stats);
      };

      if(homeFavourite and not homeFormBetter){
        return bothTeamsToScoreOddsGenerator.getOffFormHomeFavouriteOdds(stats);
      };

      if(not homeFavourite and homeFormBetter){
        return bothTeamsToScoreOddsGenerator.getOffFormAwayFavouriteOdds(stats);
      };
      
      return bothTeamsToScoreOddsGenerator.getOnFormAwayFavouriteOdds(stats);
    };
                          
    public func getBothTeamsToScoreWithWinnerOdds(stats: BettingTypes.Stats) : [BettingTypes.ResultAndYesNoSelectionOdds]{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return bothTeamsToScoreWithWinnerOddsGenerator.getOnFormHomeFavouriteOdds(stats);
      };

      if(homeFavourite and not homeFormBetter){
        return bothTeamsToScoreWithWinnerOddsGenerator.getOffFormHomeFavouriteOdds(stats);
      };

      if(not homeFavourite and homeFormBetter){
        return bothTeamsToScoreWithWinnerOddsGenerator.getOffFormAwayFavouriteOdds(stats);
      };
      
      return bothTeamsToScoreWithWinnerOddsGenerator.getOnFormAwayFavouriteOdds(stats);
    };

    public func getCorrectScoreOdds(stats: BettingTypes.Stats) : [BettingTypes.ScoreSelectionOdds]{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return correctScoreOddsGenerator.getOnFormHomeFavouriteOdds(stats);
      };

      if(homeFavourite and not homeFormBetter){
        return correctScoreOddsGenerator.getOffFormHomeFavouriteOdds(stats);
      };

      if(not homeFavourite and homeFormBetter){
        return correctScoreOddsGenerator.getOffFormAwayFavouriteOdds(stats);
      };
      
      return correctScoreOddsGenerator.getOnFormAwayFavouriteOdds(stats);
    };

    public func getGoalsOverUnderOdds(stats: BettingTypes.Stats) : BettingTypes.OverUnderSelectionOdds{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return goalsOverUnderOddsGenerator.getOnFormHomeFavouriteOdds(stats);
      };

      if(homeFavourite and not homeFormBetter){
        return goalsOverUnderOddsGenerator.getOffFormHomeFavouriteOdds(stats);
      };

      if(not homeFavourite and homeFormBetter){
        return goalsOverUnderOddsGenerator.getOffFormAwayFavouriteOdds(stats);
      };
      
      return goalsOverUnderOddsGenerator.getOnFormAwayFavouriteOdds(stats);
    };

    public func getHalfTimeFullTimeResultOdds(stats: BettingTypes.Stats) : [BettingTypes.HalfTimeFullTimeOdds]{
      let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return halfTimeFullTimeOddsGenerator.getOnFormHomeFavouriteOdds(stats);
      };

      if(homeFavourite and not homeFormBetter){
        return halfTimeFullTimeOddsGenerator.getOffFormHomeFavouriteOdds(stats);
      };

      if(not homeFavourite and homeFormBetter){
        return halfTimeFullTimeOddsGenerator.getOffFormAwayFavouriteOdds(stats);
      };
      
      return halfTimeFullTimeOddsGenerator.getOnFormAwayFavouriteOdds(stats);
    };

    public func getHalfTimeCorrectScoreOdds(stats: BettingTypes.Stats) : [BettingTypes.ScoreSelectionOdds]{
     let homeFavourite = stats.homeTeamPriorSeasonFinish < stats.awayTeamPriorSeasonFinish;
      let homeFormBetter = stats.totalHomeClubPoints > stats.totalAwayClubPoints;

      if(homeFavourite and homeFormBetter){
        return halfTimeCorrectScoreOddsGenerator.getOnFormHomeFavouriteOdds(stats);
      };

      if(homeFavourite and not homeFormBetter){
        return halfTimeCorrectScoreOddsGenerator.getOffFormHomeFavouriteOdds(stats);
      };

      if(not homeFavourite and homeFormBetter){
        return halfTimeCorrectScoreOddsGenerator.getOffFormAwayFavouriteOdds(stats);
      };
      
      return halfTimeCorrectScoreOddsGenerator.getOnFormAwayFavouriteOdds(stats);
    };

  };
};
