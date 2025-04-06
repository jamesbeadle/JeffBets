import Ids "mo:waterway-mops/Ids";

module UserQueries {

  public type GetProfile = {
  };

  public type Profile = {
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
  
};
