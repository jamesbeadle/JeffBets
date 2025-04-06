import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Ids "mo:waterway-mops/Ids";
import FootballEnums "mo:waterway-mops/football/FootballEnums";
import FootballTypes "mo:waterway-mops/football/FootballTypes";
import Enums "mo:waterway-mops/Enums";


module DTOs {

  public type LeagueStatusDTO = {
    leagueId: FootballIds.LeagueId;
    activeSeasonId: FootballIds.SeasonId;
    activeGameweek: FootballDefinitions.GameweekNumber;
    lastConfirmedGameweek: FootballDefinitions.GameweekNumber;
    transferWindowActive: Bool;
    seasonActive : Bool;
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

  public type PlayerDTO = {
    id : Nat16;
    clubId : FootballIds.ClubId;
    position : FootballEnums.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Ids.CountryId;
    status : FootballEnums.PlayerStatus;
    leagueId: FootballIds.LeagueId;
    parentLeagueId: FootballIds.LeagueId;
    parentClubId: FootballIds.ClubId;
    currentLoanEndDate: Int;
  };

  public type LoanedPlayerDTO = {
    id : Nat16;
    clubId : FootballIds.ClubId;
    position : FootballEnums.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Ids.CountryId;
    status : FootballEnums.PlayerStatus;
    currentLoanEndDate: Int;
    parentClubId: FootballIds.ClubId;
    parentLeagueId: FootballIds.LeagueId;
    leagueId: FootballIds.LeagueId;
  };

  public type SnapshotPlayerDTO = {
    leagueId: FootballIds.LeagueId;
    id : Nat16;
    clubId : FootballIds.ClubId;
    position : FootballEnums.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Ids.CountryId;
    status : FootballEnums.PlayerStatus;
    totalPoints: Int;
  };

  public type PlayerScoreDTO = {
    id : Nat16;
    points : Int16;
    clubId : FootballIds.ClubId;
    goalsScored : Int16;
    goalsConceded : Int16;
    position : FootballEnums.PlayerPosition;
    nationality : Ids.CountryId;
    dateOfBirth : Int;
    saves : Int16;
    assists : Int16;
    events : [FootballTypes.PlayerEventData];
  };

  public type PlayerPointsDTO = {
    id : Nat16;
    gameweek : FootballDefinitions.GameweekNumber;
    points : Int16;
    clubId : FootballIds.ClubId;
    position : FootballEnums.PlayerPosition;
    events : [FootballTypes.PlayerEventData];
  };

  public type PlayerDetailDTO = {
    id : FootballIds.PlayerId;
    clubId : FootballIds.ClubId;
    position : FootballEnums.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Ids.CountryId;
    seasonId : FootballIds.SeasonId;
    gameweeks : [PlayerGameweekDTO];
    valueHistory : [FootballTypes.ValueHistory];
    status : FootballEnums.PlayerStatus;
    parentClubId : FootballIds.ClubId;
    latestInjuryEndDate : Int;
    injuryHistory : [FootballTypes.InjuryHistory];
    retirementDate : Int;
  };

  public type PlayerGameweekDTO = {
    number : Nat8;
    events : [FootballTypes.PlayerEventData];
    points : Int16;
    fixtureId : FootballIds.FixtureId;
  };

  public type SeasonDTO = {
    id : FootballIds.SeasonId;
    name : Text;
    year : Nat16;
  };

  public type FixtureDTO = {
    id : Nat32;
    seasonId : FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    kickOff : Int;
    homeClubId : FootballIds.ClubId;
    awayClubId : FootballIds.ClubId;
    homeGoals : Nat8;
    awayGoals : Nat8;
    status : FootballEnums.FixtureStatusType;
    highestScoringPlayerId : Nat16;
    events : [FootballTypes.PlayerEventData];
  };

  public type LeagueDTO = {
    id: FootballIds.LeagueId;
    name: Text;
    abbreviation: Text;
    teamCount: Nat8;
    relatedGender: Enums.Gender;
    governingBody: Text;
    formed: Int;
    countryId: Ids.CountryId;
    logo: Blob;
  };

  public type ClubDTO = {
    id : FootballIds.ClubId;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : FootballEnums.ShirtType;
  };
  
};
