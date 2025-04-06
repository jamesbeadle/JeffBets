import Ids "mo:waterway-mops/Ids";
import BettingTypes "../../types/betting_types";

module BettingQueries {

  public type GetUserBets = {
    principalId: Ids.PrincipalId;
  };

  public type UserBetsList = {
    bets: [BettingTypes.BetSlip];
  };

  public type GetBetslipFixtures = {
    selections: [BettingTypes.Selection];
  };

};
