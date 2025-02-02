
import FootballTypes "../../types/football_types";
import BaseTypes "../../types/base_types";
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
