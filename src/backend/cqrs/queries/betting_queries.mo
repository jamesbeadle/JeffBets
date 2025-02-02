import Base "../../types/base_types";
import BettingTypes "../../types/betting_types";

module BettingQueries {

  public type GetUserBets = {
    principalId: Base.PrincipalId;
  };

  public type UserBetsList = {
    bets: [BettingTypes.BetSlip];
  };

  public type GetBetslipFixtures = {
    selections: [BettingTypes.Selection];
  };

};
