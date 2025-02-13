import FootballTypes "mo:waterway-mops/FootballTypes";
import Base "mo:waterway-mops/BaseTypes";
import BettingTypes "../types/betting_types";

module DTOs {

  public type AppStatusDTO = {
    onHold : Bool;
    version: Text;
  };

  public type ProfileDTO = {
    principalId : Base.PrincipalId;
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
    leagueId: FootballTypes.LeagueId;
    fixtureId: FootballTypes.FixtureId;
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
    leagueId: FootballTypes.LeagueId;
    gameweek: FootballTypes.GameweekNumber;
    fixtureId: FootballTypes.FixtureId;
    homeOdds: Float;
    drawOdds: Float;
    awayOdds: Float;
  };

  public type CountryDTO = {
    id : Base.CountryId;
    name : Text;
    code : Text;
  };

  public type DataHashDTO = {
    category : Text;
    hash : Text;
  };

};
