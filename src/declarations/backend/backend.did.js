export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    InvalidProfilePicture: IDL.Null,
    DecodeError: IDL.Null,
    TooLong: IDL.Null,
    NotAllowed: IDL.Null,
    DuplicateData: IDL.Null,
    InvalidProperty: IDL.Null,
    NotFound: IDL.Null,
    IncorrectSetup: IDL.Null,
    AlreadyClaimed: IDL.Null,
    NotAuthorized: IDL.Null,
    MaxDataExceeded: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    NoPacketsRemaining: IDL.Null,
    UpdateFailed: IDL.Null,
    CanisterCreateError: IDL.Null,
    NeuronAlreadyUsed: IDL.Null,
    FailedInterCanisterCall: IDL.Null,
    InsufficientPacketsRemaining: IDL.Null,
    InsufficientFunds: IDL.Null,
    InEligible: IDL.Null,
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const AppStatus = IDL.Record({ version: IDL.Text, onHold: IDL.Bool });
  const Result_16 = IDL.Variant({ ok: AppStatus, err: Error });
  const LeagueId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const GameweekNumber = IDL.Nat8;
  const HomePageFixture = IDL.Record({
    fixtureId: FixtureId,
    homeOdds: IDL.Float64,
    drawOdds: IDL.Float64,
    awayOdds: IDL.Float64,
    gameweek: GameweekNumber,
    leagueId: LeagueId,
  });
  const Result_15 = IDL.Variant({
    ok: IDL.Vec(HomePageFixture),
    err: Error,
  });
  const GetClubs = IDL.Record({ leagueId: LeagueId });
  const ClubId = IDL.Nat16;
  const ShirtType = IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null });
  const Club = IDL.Record({
    id: ClubId,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
  });
  const Clubs = IDL.Record({ clubs: IDL.Vec(Club), leagueId: LeagueId });
  const Result_14 = IDL.Variant({ ok: Clubs, err: Error });
  const GetCountries = IDL.Record({});
  const CountryId = IDL.Nat16;
  const Country = IDL.Record({
    id: CountryId,
    code: IDL.Text,
    name: IDL.Text,
  });
  const Countries = IDL.Record({ countries: IDL.Vec(Country) });
  const Result_13 = IDL.Variant({ ok: Countries, err: Error });
  const DataHash = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_12 = IDL.Variant({ ok: IDL.Vec(DataHash), err: Error });
  const SeasonId = IDL.Nat16;
  const GetFixtures = IDL.Record({
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const FixtureStatusType = IDL.Variant({
    Unplayed: IDL.Null,
    Finalised: IDL.Null,
    Active: IDL.Null,
    Complete: IDL.Null,
  });
  const PlayerId = IDL.Nat16;
  const PlayerEventType = IDL.Variant({
    PenaltyMissed: IDL.Null,
    Goal: IDL.Null,
    GoalConceded: IDL.Null,
    Appearance: IDL.Null,
    PenaltySaved: IDL.Null,
    RedCard: IDL.Null,
    KeeperSave: IDL.Null,
    CleanSheet: IDL.Null,
    YellowCard: IDL.Null,
    GoalAssisted: IDL.Null,
    OwnGoal: IDL.Null,
    HighestScoringPlayer: IDL.Null,
  });
  const PlayerEventData = IDL.Record({
    fixtureId: FixtureId,
    clubId: ClubId,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType,
  });
  const Fixture = IDL.Record({
    id: FixtureId,
    status: FixtureStatusType,
    highestScoringPlayerId: PlayerId,
    seasonId: SeasonId,
    awayClubId: ClubId,
    events: IDL.Vec(PlayerEventData),
    homeClubId: ClubId,
    kickOff: IDL.Int,
    homeGoals: IDL.Nat8,
    gameweek: GameweekNumber,
    awayGoals: IDL.Nat8,
  });
  const Fixtures = IDL.Record({
    seasonId: SeasonId,
    fixtures: IDL.Vec(Fixture),
    leagueId: LeagueId,
  });
  const Result_11 = IDL.Variant({ ok: Fixtures, err: Error });
  const GetLeagues = IDL.Record({});
  const Gender = IDL.Variant({ Male: IDL.Null, Female: IDL.Null });
  const League = IDL.Record({
    id: LeagueId,
    logo: IDL.Vec(IDL.Nat8),
    name: IDL.Text,
    teamCount: IDL.Nat8,
    relatedGender: Gender,
    countryId: CountryId,
    abbreviation: IDL.Text,
    governingBody: IDL.Text,
    formed: IDL.Int,
  });
  const Leagues = IDL.Record({ leagues: IDL.Vec(League) });
  const Result_10 = IDL.Variant({ ok: Leagues, err: Error });
  const GetLoanedPlayers = IDL.Record({ leagueId: LeagueId });
  const PlayerStatus = IDL.Variant({
    OnLoan: IDL.Null,
    Active: IDL.Null,
    FreeAgent: IDL.Null,
    Retired: IDL.Null,
  });
  const PlayerPosition = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null,
  });
  const Player = IDL.Record({
    id: IDL.Nat16,
    status: PlayerStatus,
    clubId: ClubId,
    parentClubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    currentLoanEndDate: IDL.Int,
    shirtNumber: IDL.Nat8,
    parentLeagueId: LeagueId,
    position: PlayerPosition,
    lastName: IDL.Text,
    leagueId: LeagueId,
    firstName: IDL.Text,
  });
  const LoanedPlayers = IDL.Record({ players: IDL.Vec(Player) });
  const Result_9 = IDL.Variant({ ok: LoanedPlayers, err: Error });
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
  const MatchOdds = IDL.Record({
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
  const Result_8 = IDL.Variant({ ok: MatchOdds, err: Error });
  const GetPlayers = IDL.Record({ leagueId: LeagueId });
  const Players = IDL.Record({ players: IDL.Vec(Player) });
  const Result_7 = IDL.Variant({ ok: Players, err: Error });
  const PrincipalId = IDL.Text;
  const Profile = IDL.Record({
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
  const Result_6 = IDL.Variant({ ok: Profile, err: Error });
  const GetSeasons = IDL.Record({ leagueId: LeagueId });
  const Season = IDL.Record({
    id: IDL.Nat16,
    name: IDL.Text,
    year: IDL.Nat16,
  });
  const Seasons = IDL.Record({ seasons: IDL.Vec(Season) });
  const Result_5 = IDL.Variant({ ok: Seasons, err: Error });
  const GetUserAudit = IDL.Record({
    page: IDL.Nat,
    principalId: IDL.Text,
  });
  const AuditRecord = IDL.Record({});
  const UserAuditList = IDL.Record({
    date: IDL.Int,
    offset: IDL.Nat,
    users: IDL.Vec(AuditRecord),
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
  const BetType__1 = IDL.Variant({
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
  const Category__1 = IDL.Variant({
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
  const Selection__1 = IDL.Record({
    status: SelectionStatus,
    result: BetResult,
    fixtureId: FixtureId,
    winnings: IDL.Float64,
    odds: IDL.Float64,
    stake: IDL.Nat64,
    expectedReturns: IDL.Nat64,
    selectionDetail: SelectionDetail,
    leagueId: LeagueId,
    selectionType: Category__1,
  });
  const BetSlip__1 = IDL.Record({
    id: IDL.Nat,
    status: SelectionStatus,
    result: BetResult,
    betType: BetType__1,
    totalWinnings: IDL.Nat64,
    totalStake: IDL.Nat64,
    placedBy: PrincipalId,
    placedOn: IDL.Int,
    selections: IDL.Vec(Selection__1),
    expectedReturns: IDL.Nat64,
    settledOn: IDL.Int,
  });
  const UserBetsList = IDL.Record({ bets: IDL.Vec(BetSlip__1) });
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
    getAppStatus: IDL.Func([], [Result_16], ["query"]),
    getBettableHomepageFixtures: IDL.Func([LeagueId], [Result_15], ["query"]),
    getClubs: IDL.Func([GetClubs], [Result_14], []),
    getCountries: IDL.Func([GetCountries], [Result_13], []),
    getDataHashes: IDL.Func([], [Result_12], ["query"]),
    getFixtures: IDL.Func([GetFixtures], [Result_11], []),
    getLeagues: IDL.Func([GetLeagues], [Result_10], []),
    getLoanedPlayers: IDL.Func([GetLoanedPlayers], [Result_9], []),
    getMatchOdds: IDL.Func([LeagueId, FixtureId], [Result_8], ["query"]),
    getPlayers: IDL.Func([GetPlayers], [Result_7], []),
    getProfile: IDL.Func([], [Result_6], []),
    getSeasons: IDL.Func([GetSeasons], [Result_5], []),
    getUserAudit: IDL.Func([GetUserAudit], [Result_4], []),
    getUserBets: IDL.Func([GetUserBets], [Result_3], []),
    isAuditor: IDL.Func([], [Result_2], []),
    kycVerificationCallback: IDL.Func([ShuftiResponse], [Result], []),
    notifyAppsOfFixtureComplete: IDL.Func(
      [LeagueId, SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfFixtureFinalised: IDL.Func(
      [LeagueId, SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfGameweekStarting: IDL.Func(
      [LeagueId, SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfLoan: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfLoanExpired: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfPositionChange: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfRetirement: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfSeasonComplete: IDL.Func([LeagueId, SeasonId], [Result], []),
    notifyAppsOfTransfer: IDL.Func([LeagueId, PlayerId], [Result], []),
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
