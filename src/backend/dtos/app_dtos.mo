import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import BettingTypes "../types/betting_types";

module DTOs {

  public type AppStatusDTO = {
    onHold : Bool;
    version: Text;
  };

  public type ProfileDTO = {
    principalId : Ids.PrincipalId;
    joinedDate: Int;
    termsAcceptedDate: Int;
    username : Text; 
    profilePicture: ?Blob;
    profilePictureExtension: Text;
    withdrawalAddress: Text;
    accountOnPause: Bool;
    maxBetLimit: Nat64;
    monthlyBetLimit: Nat64;
    monthlyBetTotal: Nat64;
    accountBalance: Nat64;
    kycComplete: Bool;
    kycSubmissionDate: Int;
    kycApprovalDate: Int;
    kycRef: Text;
  };
  
  public type MatchOddsDTO = {
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

  public type HomePageFixtureDTO = {
    leagueId: FootballIds.LeagueId;
    gameweek: FootballDefinitions.GameweekNumber;
    fixtureId: FootballIds.FixtureId;
    homeOdds: Float;
    drawOdds: Float;
    awayOdds: Float;
  };

  public type CountryDTO = {
    id : Ids.CountryId;
    name : Text;
    code : Text;
  };

  public type DataHashDTO = {
    category : Text;
    hash : Text;
  };

};
