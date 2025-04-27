import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import BettingTypes "../types/betting_types";
import BettingEnums "../enums/betting_enums";

module BettingQueries {

  public type GetUserBets = {
  };

  public type UserBets = {
    bets: [BetSlip];
  };

  public type BetSlip = {
      id: Nat;
      placedBy: Ids.PrincipalId;
      placedOn: Int;
      status: BettingEnums.SelectionStatus;
      result: BettingEnums.BetResult;
      selections: [Selection];
      betType: BettingEnums.BetType;
      totalStake: Nat64;
      expectedReturns: Nat64;
      totalWinnings: Nat64;
      settledOn: Int;
      ecosystem: TokenisedEcosystem;
  };

  public type Selection = {
    leagueId: FootballIds.LeagueId;
    selectionType: BettingEnums.Category;
    selectionDetail: BettingTypes.SelectionDetail;
    status: BettingEnums.SelectionStatus;
    result: BettingEnums.BetResult;
    odds: Float;
    stake: Nat64;
    fixtureId: FootballIds.FixtureId;
    winnings: Float;
    expectedReturns: Nat64;
  };

  public type GetBetslipFixtures = {
    selections: [BettingTypes.Selection];
  };

  public type GetMatchOdds = {
    leagueId: FootballIds.LeagueId;
    fixtureId: FootballIds.FixtureId;
  };
  
  public type MatchOdds = {
    leagueId: FootballIds.LeagueId;
    fixtureId: FootballIds.FixtureId;
    correctResults: BettingTypes.TeamSelectionOdds;
    correctScores: [BettingTypes.ScoreSelectionOdds];
    halfTimeScores: [BettingTypes.ScoreSelectionOdds];
    firstGoalscorers: [BettingTypes.PlayerSelectionOdds];
    lastGoalscorers: [BettingTypes.PlayerSelectionOdds];
    anytimeScorers: [BettingTypes.PlayerSelectionOdds];
    yellowCards: [BettingTypes.PlayerSelectionOdds];
    redCards: [BettingTypes.PlayerSelectionOdds];
    penaltyMissed: BettingTypes.MissPenaltyOdds;
    penaltyMissers: [BettingTypes.PlayerSelectionOdds];
    firstAssisters: [BettingTypes.PlayerSelectionOdds];
    lastAssist: [BettingTypes.PlayerSelectionOdds];
    anytimeAssist: [BettingTypes.PlayerSelectionOdds];
    scoresBrace: [BettingTypes.PlayerSelectionOdds];
    scoresHatTrick: [BettingTypes.PlayerSelectionOdds];
    goalsOverUnder: BettingTypes.OverUnderSelectionOdds;
    bothTeamsToScore: BettingTypes.YesNoSelectionOdds;
    halfTimeFullTimeResult: [BettingTypes.HalfTimeFullTimeOdds];
    bothTeamsToScoreAndWinner: [BettingTypes.ResultAndYesNoSelectionOdds];
  };

  public type GetBettableHomepageFixtures = {
    leagueId: FootballIds.LeagueId;
  };

  public type BettableHomepageFixtures = {
    fixtures: [HomePageFixture]
  };

  public type HomePageFixture = {
    leagueId: FootballIds.LeagueId;
    gameweek: FootballDefinitions.GameweekNumber;
    fixtureId: FootballIds.FixtureId;
    homeOdds: Float;
    drawOdds: Float;
    awayOdds: Float;
  };
};
