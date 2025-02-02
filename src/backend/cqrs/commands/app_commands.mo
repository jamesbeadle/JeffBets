import Base "../../types/base_types";

module AppCommands {

  public type UpdateUsername = {
    principalId: Base.PrincipalId;
    username: Text;
  };

  public type UpdateProfilePicture = {
    principalId: Base.PrincipalId;
    profilePicture: Blob;
    profilePictureExtension: Text;
  };

  public type UpdateWithdrawalAddress = {
    principalId: Base.PrincipalId;
    withdrawalAddress: Text;
  };
  
};
