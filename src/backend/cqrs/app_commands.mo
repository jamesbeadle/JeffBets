import Base "../types/base_types";

module AppCommands {

  public type UpdateAppStatusDTO = {
    onHold : Bool;
    version: Text;
  };

  public type UpdateUsernameDTO = {
    principalId: Base.PrincipalId;
    username: Text;
  };

  public type UpdateProfilePictureDTO = {
    principalId: Base.PrincipalId;
    profilePicture: Blob;
    profilePictureExtension: Text;
  };

  public type UpdateWithdrawalAddressDTO = {
    principalId: Base.PrincipalId;
    withdrawalAddress: Text;
  };
};
