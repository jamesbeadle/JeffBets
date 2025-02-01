
import FootballTypes "../types/football_types";
import BaseTypes "../types/base_types";
import DTOs "../dtos/dtos";

module FootballDataQueries {

  public type GetLeaguesDTO = {
    page: Nat;
    searchTerm: Text;
    countryId: BaseTypes.CountryId;
  };

  public type LeaguesListDTO = {
    page: Nat;
    searchTerm: Text;
    countryId: BaseTypes.CountryId;
    entries : [DTOs.LeagueDTO];
    totalEntries: Nat;
  };

  public type GetFixturesDTO = {
    leagueId: FootballTypes.LeagueId;
    seasonId: FootballTypes.SeasonId;
  };

  public type GetPlayersDTO = {
    leagueId: FootballTypes.LeagueId;
  };
};
