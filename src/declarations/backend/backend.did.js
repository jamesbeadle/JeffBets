export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotFound: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    AlreadyExists: IDL.Null,
    CanisterCreateError: IDL.Null,
    CanisterFull: IDL.Null,
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const LeagueId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const GameweekNumber = IDL.Nat8;
  const HomePageFixtureDTO = IDL.Record({
    fixtureId: FixtureId,
    homeOdds: IDL.Float64,
    drawOdds: IDL.Float64,
    awayOdds: IDL.Float64,
    gameweek: GameweekNumber,
    leagueId: LeagueId,
  });
  const Result_8 = IDL.Variant({
    ok: IDL.Vec(HomePageFixtureDTO),
    err: Error,
  });
  const DataHashDTO = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_7 = IDL.Variant({ ok: IDL.Vec(DataHashDTO), err: Error });
  const PlayerId = IDL.Nat16;
  const PlayerSelectionOdds = IDL.Record({
    playerId: PlayerId,
    odds: IDL.Float64,
  });
  const ScoreSelectionOdds = IDL.Record({
    odds: IDL.Float64,
    homeGoals: IDL.Nat8,
    awayGoals: IDL.Nat8,
  });
  const YesNoSelectionOdds = IDL.Record({
    noOdds: IDL.Float64,
    yesOdds: IDL.Float64,
  });
  const TeamSelectionOdds = IDL.Record({
    homeOdds: IDL.Float64,
    drawOdds: IDL.Float64,
    awayOdds: IDL.Float64,
  });
  const MissPenaltyOdds = IDL.Record({
    homeTeam: IDL.Float64,
    awayTeam: IDL.Float64,
  });
  const OverUnderSelection = IDL.Record({
    odds: IDL.Float64,
    margin: IDL.Float64,
  });
  const OverUnderSelectionOdds = IDL.Record({
    overOdds: IDL.Vec(OverUnderSelection),
    underOdds: IDL.Vec(OverUnderSelection),
  });
  const MatchResult = IDL.Variant({
    HomeWin: IDL.Null,
    Draw: IDL.Null,
    AwayWin: IDL.Null,
  });
  const HalfTimeFullTimeOdds = IDL.Record({
    firstHalfResult: MatchResult,
    odds: IDL.Float64,
    secondHalfResult: MatchResult,
  });
  const ResultAndYesNoSelectionOdds = IDL.Record({
    result: MatchResult,
    odds: IDL.Float64,
    isYes: IDL.Bool,
  });
  const MatchOddsDTO = IDL.Record({
    fixtureId: FixtureId,
    lastAssist: IDL.Vec(PlayerSelectionOdds),
    correctScores: IDL.Vec(ScoreSelectionOdds),
    bothTeamsToScore: YesNoSelectionOdds,
    yellowCards: IDL.Vec(PlayerSelectionOdds),
    lastGoalscorers: IDL.Vec(PlayerSelectionOdds),
    halfTimeScores: IDL.Vec(ScoreSelectionOdds),
    anytimeAssist: IDL.Vec(PlayerSelectionOdds),
    penaltyMissers: IDL.Vec(PlayerSelectionOdds),
    redCards: IDL.Vec(PlayerSelectionOdds),
    anytimeScorers: IDL.Vec(PlayerSelectionOdds),
    correctResults: TeamSelectionOdds,
    penaltyMissed: MissPenaltyOdds,
    scoresHatTrick: IDL.Vec(PlayerSelectionOdds),
    scoresBrace: IDL.Vec(PlayerSelectionOdds),
    goalsOverUnder: OverUnderSelectionOdds,
    firstAssisters: IDL.Vec(PlayerSelectionOdds),
    leagueId: LeagueId,
    firstGoalscorers: IDL.Vec(PlayerSelectionOdds),
    halfTimeFullTimeResult: IDL.Vec(HalfTimeFullTimeOdds),
    bothTeamsToScoreAndWinner: IDL.Vec(ResultAndYesNoSelectionOdds),
  });
  const Result_6 = IDL.Variant({ ok: MatchOddsDTO, err: Error });
  const PrincipalId = IDL.Text;
  const ProfileDTO = IDL.Record({
    username: IDL.Text,
    maxBetLimit: IDL.Nat64,
    monthlyBetLimit: IDL.Nat64,
    withdrawalAddress: IDL.Text,
    profilePictureExtension: IDL.Text,
    accountBalance: IDL.Nat64,
    kycApprovalDate: IDL.Int,
    joinedDate: IDL.Int,
    accountOnPause: IDL.Bool,
    termsAcceptedDate: IDL.Int,
    kycComplete: IDL.Bool,
    kycRef: IDL.Text,
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    kycSubmissionDate: IDL.Int,
    principalId: PrincipalId,
    monthlyBetTotal: IDL.Nat64,
  });
  const Result_5 = IDL.Variant({ ok: ProfileDTO, err: Error });
  const GetUserAudit = IDL.Record({
    page: IDL.Nat,
    principalId: IDL.Text,
  });
  const AuditRecordDTO = IDL.Record({
    kycApprovalDate: IDL.Int,
    joinedDate: IDL.Int,
    termsAcceptedDate: IDL.Int,
    kycComplete: IDL.Bool,
    kycRef: IDL.Text,
    kycSubmissionDate: IDL.Int,
    principalId: PrincipalId,
  });
  const UserAuditList = IDL.Record({
    date: IDL.Int,
    offset: IDL.Nat,
    users: IDL.Vec(AuditRecordDTO),
  });
  const Result_4 = IDL.Variant({ ok: UserAuditList, err: Error });
  const GetUserBets = IDL.Record({ principalId: PrincipalId });
  const SelectionStatus = IDL.Variant({
    Void: IDL.Null,
    Unsettled: IDL.Null,
    Settled: IDL.Null,
  });
  const BetResult = IDL.Variant({
    Won: IDL.Null,
    Lost: IDL.Null,
    Open: IDL.Null,
  });
  const BetType = IDL.Variant({
    SevenFold: IDL.Null,
    Patent: IDL.Null,
    FiveFold: IDL.Null,
    FourFold: IDL.Null,
    Goliath: IDL.Null,
    Double: IDL.Null,
    Lucky15: IDL.Null,
    Lucky31: IDL.Null,
    Lucky63: IDL.Null,
    SuperHeinz: IDL.Null,
    Treble: IDL.Null,
    Trixie: IDL.Null,
    TenFold: IDL.Null,
    EightFold: IDL.Null,
    Heinz: IDL.Null,
    Yankee: IDL.Null,
    SixFold: IDL.Null,
    NineFold: IDL.Null,
    Canadian: IDL.Null,
    Single: IDL.Null,
  });
  const ClubId = IDL.Nat16;
  const PlayerEventDetail = IDL.Record({
    clubId: ClubId,
    playerId: PlayerId,
  });
  const ClubEventDetail = IDL.Record({ clubId: ClubId });
  const CorrectResultDetail = IDL.Record({ matchResult: MatchResult });
  const ScoreDetail = IDL.Record({
    homeGoals: IDL.Nat8,
    awayGoals: IDL.Nat8,
  });
  const BothTeamsToScoreDetail = IDL.Record({ bothTeamsToScore: IDL.Bool });
  const HalfTimeFullTimeResultDetail = IDL.Record({
    fullTimeResult: MatchResult,
    halfTimeResult: MatchResult,
  });
  const PlayerGroupEventDetail = IDL.Record({
    clubId: ClubId,
    playerId: PlayerId,
  });
  const BothTeamsToScoreAndWinnerDetail = IDL.Record({
    bothTeamsToScore: IDL.Bool,
    matchResult: MatchResult,
  });
  const SelectionDetail = IDL.Variant({
    MissPenalty: PlayerEventDetail,
    LastAssist: PlayerEventDetail,
    PenaltyMissed: ClubEventDetail,
    FirstAssist: PlayerEventDetail,
    AnytimeGoalscorer: PlayerEventDetail,
    CorrectResult: CorrectResultDetail,
    HalfTimeScore: ScoreDetail,
    BothTeamsToScore: BothTeamsToScoreDetail,
    HalfTimeFullTimeResult: HalfTimeFullTimeResultDetail,
    LastGoalscorer: PlayerEventDetail,
    RedCard: PlayerEventDetail,
    ScoreHatrick: PlayerGroupEventDetail,
    CorrectScore: ScoreDetail,
    AnytimeAssist: PlayerEventDetail,
    YellowCard: PlayerEventDetail,
    BothTeamsToScoreAndWinner: BothTeamsToScoreAndWinnerDetail,
    FirstGoalscorer: PlayerEventDetail,
    ScoreBrace: PlayerGroupEventDetail,
  });
  const Category = IDL.Variant({
    MissPenalty: IDL.Null,
    LastAssist: IDL.Null,
    PenaltyMissed: IDL.Null,
    FirstAssist: IDL.Null,
    AnytimeGoalscorer: IDL.Null,
    CorrectResult: IDL.Null,
    HalfTimeScore: IDL.Null,
    BothTeamsToScore: IDL.Null,
    HalfTimeFullTimeResult: IDL.Null,
    LastGoalscorer: IDL.Null,
    RedCard: IDL.Null,
    ScoreHatrick: IDL.Null,
    CorrectScore: IDL.Null,
    AnytimeAssist: IDL.Null,
    YellowCard: IDL.Null,
    BothTeamsToScoreAndWinner: IDL.Null,
    FirstGoalscorer: IDL.Null,
    ScoreBrace: IDL.Null,
  });
  const Selection = IDL.Record({
    status: SelectionStatus,
    result: BetResult,
    fixtureId: FixtureId,
    winnings: IDL.Float64,
    odds: IDL.Float64,
    stake: IDL.Nat64,
    expectedReturns: IDL.Nat64,
    selectionDetail: SelectionDetail,
    leagueId: LeagueId,
    selectionType: Category,
  });
  const BetSlip = IDL.Record({
    id: IDL.Nat,
    status: SelectionStatus,
    result: BetResult,
    betType: BetType,
    totalWinnings: IDL.Nat64,
    totalStake: IDL.Nat64,
    placedBy: PrincipalId,
    placedOn: IDL.Int,
    selections: IDL.Vec(Selection),
    expectedReturns: IDL.Nat64,
    settledOn: IDL.Int,
  });
  const UserBetsList = IDL.Record({ bets: IDL.Vec(BetSlip) });
  const Result_3 = IDL.Variant({ ok: UserBetsList, err: Error });
  const Result_2 = IDL.Variant({ ok: IDL.Bool, err: Error });
  const ShuftiAcceptedResponse = IDL.Record({
    reference: IDL.Text,
    event: IDL.Text,
  });
  const ShuftiRejectedResponse = IDL.Record({
    reference: IDL.Text,
    event: IDL.Text,
  });
  const ShuftiResponse = IDL.Variant({
    ShuftiAcceptedResponse: ShuftiAcceptedResponse,
    ShuftiRejectedResponse: ShuftiRejectedResponse,
  });
  const SeasonId = IDL.Nat16;
  const PauseAccount = IDL.Record({
    pauseDays: IDL.Nat,
    principalId: PrincipalId,
  });
  const SubmitBetslip = IDL.Record({
    expectedReturn: IDL.Nat64,
    seasonId: SeasonId,
    totalStake: IDL.Nat64,
    principalId: PrincipalId,
    leagueId: LeagueId,
  });
  const Result_1 = IDL.Variant({ ok: BetSlip, err: Error });
  const SetDailyBetLimit = IDL.Record({
    maxBetLimit: IDL.Nat64,
    principalId: PrincipalId,
  });
  const SetMonthlyBetLimit = IDL.Record({
    monthlyBetLimit: IDL.Nat64,
    principalId: PrincipalId,
  });
  const UpdateProfilePicture = IDL.Record({
    profilePictureExtension: IDL.Text,
    profilePicture: IDL.Vec(IDL.Nat8),
    principalId: PrincipalId,
  });
  const UpdateUsername = IDL.Record({
    username: IDL.Text,
    principalId: PrincipalId,
  });
  const UpdateWithdrawalAddress = IDL.Record({
    withdrawalAddress: IDL.Text,
    principalId: PrincipalId,
  });
  return IDL.Service({
    agreeTerms: IDL.Func([], [Result], []),
    getBettableHomepageFixtures: IDL.Func([LeagueId], [Result_8], ["query"]),
    getDataHashes: IDL.Func([], [Result_7], ["query"]),
    getMatchOdds: IDL.Func([LeagueId, FixtureId], [Result_6], ["query"]),
    getProfile: IDL.Func([], [Result_5], []),
    getUserAudit: IDL.Func([GetUserAudit], [Result_4], []),
    getUserBets: IDL.Func([GetUserBets], [Result_3], []),
    isAuditor: IDL.Func([], [Result_2], []),
    kycVerificationCallback: IDL.Func([ShuftiResponse], [Result], []),
    notifyAppsOfFixtureFinalised: IDL.Func(
      [SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfGameweekStarting: IDL.Func(
      [SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfLoan: IDL.Func([PlayerId], [Result], []),
    notifyAppsOfLoanExpired: IDL.Func([PlayerId], [Result], []),
    notifyAppsOfPositionChange: IDL.Func([PlayerId], [Result], []),
    notifyAppsOfRetirement: IDL.Func([PlayerId], [Result], []),
    notifyAppsOfSeasonComplete: IDL.Func([SeasonId], [Result], []),
    notifyAppsOfTransfer: IDL.Func([PlayerId], [Result], []),
    pauseAccount: IDL.Func([PauseAccount], [Result], []),
    placeBet: IDL.Func([SubmitBetslip], [Result_1], []),
    setDailyBetLimit: IDL.Func([SetDailyBetLimit], [Result], []),
    setMonthlyBetLimit: IDL.Func([SetMonthlyBetLimit], [Result], []),
    storeKYCReference: IDL.Func([IDL.Text], [], []),
    updateProfilePicture: IDL.Func([UpdateProfilePicture], [Result], []),
    updateUsername: IDL.Func([UpdateUsername], [Result], []),
    updateWithdrawalAddress: IDL.Func([UpdateWithdrawalAddress], [Result], []),
  });
};
export const init = ({ IDL }) => {
  return [];
};
