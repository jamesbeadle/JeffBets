import Ids "mo:waterway-mops/Ids";

module AppCommands {

  public type UpdateUsername = {
    principalId: Ids.PrincipalId;
    username: Text;
  };

  public type UpdateProfilePicture = {
    principalId: Ids.PrincipalId;
    profilePicture: Blob;
    profilePictureExtension: Text;
  };

  public type UpdateWithdrawalAddress = {
    principalId: Ids.PrincipalId;
    withdrawalAddress: Text;
  };
  
};
