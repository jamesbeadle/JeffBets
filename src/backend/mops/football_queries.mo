import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";

module FootballQueries {

  public type GetLeagues = {
    page: Nat;
    searchTerm: Text;
    countryId: Ids.CountryId;
  };

  public type LeaguesList = {
    page: Nat;
    searchTerm: Text;
    countryId: Ids.CountryId;
    entries : [DTOs.LeagueDTO];
    totalEntries: Nat;
  };

  public type GetFixtures = {
    leagueId: FootballIds.LeagueId;
    seasonId: FootballIds.SeasonId;
  };

  public type FixturesList = {
    fixtures: [FootballDTOs.FixtureDTO];
  };

  public type GetPlayers = {
    leagueId: FootballIds.LeagueId;
  };

  public type PlayersList = {
    players: [FootballDTOs.PlayerDTO];
  };
};
