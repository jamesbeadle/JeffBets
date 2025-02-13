import FootballTypes "mo:waterway-mops/FootballTypes";
import BaseTypes "mo:waterway-mops/BaseTypes";
import DTOs "../../dtos/football_dtos";
import FootballDTOs "../../dtos/football_dtos";

module FootballQueries {

  public type GetLeagues = {
    page: Nat;
    searchTerm: Text;
    countryId: BaseTypes.CountryId;
  };

  public type LeaguesList = {
    page: Nat;
    searchTerm: Text;
    countryId: BaseTypes.CountryId;
    entries : [DTOs.LeagueDTO];
    totalEntries: Nat;
  };

  public type GetFixtures = {
    leagueId: FootballTypes.LeagueId;
    seasonId: FootballTypes.SeasonId;
  };

  public type FixturesList = {
    fixtures: [FootballDTOs.FixtureDTO];
  };

  public type GetPlayers = {
    leagueId: FootballTypes.LeagueId;
  };

  public type PlayersList = {
    players: [FootballDTOs.PlayerDTO];
  };
};
