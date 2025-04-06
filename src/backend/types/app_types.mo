import BettingTypes "betting_types";
import Text "mo:base/Text";
import Ids "mo:waterway-mops/Ids";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import ShuftiTypes "shufti_types";
module AppTypes {

    public type Profile = {
        principalId : Ids.PrincipalId;
        termsAcceptedDate: Int;
        username : Text; 
        profilePicture: ?Blob;
        profilePictureExtension: Text;
        withdrawalAddress: Text;
        joinedDate: Int;
        accountOnPause: Bool;
        pauseEndDate: Int;
        maxBetLimit: Nat64;
        maxBetLimitSet: Int;
        monthlyBetLimit: Nat64;
        monthlyBetLimitSet: Int;
        monthlyBetTotals: [(Nat16, [(BaseDefinitions.CalendarMonth, Nat64)])];
        monthlyProfitLoss: [(Nat16, [(BaseDefinitions.CalendarMonth, Nat64)])];
        bets: [BettingTypes.BetSlip];
        kycComplete: Bool;
        kycSubmissionDate: Int;
        kycApprovalDate: Int;
        kycRef: Text;
    };

    public type KYCProfile = {
        principalId: Ids.PrincipalId;
        reference: Text;
        shuftiResponse: ?ShuftiTypes.ShuftiResponse;
        kycSubmissionDate: Int;
        kycApprovalDate: Int;
    };
};
