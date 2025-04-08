import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatus {
  version: string;
  onHold: boolean;
}
export type AuditRecord = {};
export type BetResult = { Won: null } | { Lost: null } | { Open: null };
export interface BetSlip {
  id: bigint;
  status: SelectionStatus;
  result: BetResult;
  betType: BetType;
  totalWinnings: bigint;
  totalStake: bigint;
  placedBy: PrincipalId;
  placedOn: bigint;
  selections: Array<Selection>;
  expectedReturns: bigint;
  settledOn: bigint;
}
export type BetType =
  | { SevenFold: null }
  | { Patent: null }
  | { FiveFold: null }
  | { FourFold: null }
  | { Goliath: null }
  | { Double: null }
  | { Lucky15: null }
  | { Lucky31: null }
  | { Lucky63: null }
  | { SuperHeinz: null }
  | { Treble: null }
  | { Trixie: null }
  | { TenFold: null }
  | { EightFold: null }
  | { Heinz: null }
  | { Yankee: null }
  | { SixFold: null }
  | { NineFold: null }
  | { Canadian: null }
  | { Single: null };
export interface BettableHomepageFixtures {
  fixtures: Array<HomePageFixture>;
}
export interface BothTeamsToScoreAndWinnerDetail {
  bothTeamsToScore: boolean;
  matchResult: MatchResult;
}
export interface BothTeamsToScoreDetail {
  bothTeamsToScore: boolean;
}
export type Category =
  | { MissPenalty: null }
  | { LastAssist: null }
  | { PenaltyMissed: null }
  | { FirstAssist: null }
  | { AnytimeGoalscorer: null }
  | { CorrectResult: null }
  | { HalfTimeScore: null }
  | { BothTeamsToScore: null }
  | { HalfTimeFullTimeResult: null }
  | { LastGoalscorer: null }
  | { RedCard: null }
  | { ScoreHatrick: null }
  | { CorrectScore: null }
  | { AnytimeAssist: null }
  | { YellowCard: null }
  | { BothTeamsToScoreAndWinner: null }
  | { FirstGoalscorer: null }
  | { ScoreBrace: null };
export interface Club {
  id: ClubId;
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
}
export interface ClubEventDetail {
  clubId: ClubId;
}
export type ClubId = number;
export interface Clubs {
  clubs: Array<Club>;
  leagueId: LeagueId;
}
export interface CorrectResultDetail {
  matchResult: MatchResult;
}
export interface Countries {
  countries: Array<Country>;
}
export interface Country {
  id: CountryId;
  code: string;
  name: string;
}
export type CountryId = number;
export interface DataHash {
  hash: string;
  category: string;
}
export type Error =
  | { InvalidProfilePicture: null }
  | { DecodeError: null }
  | { TooLong: null }
  | { NotAllowed: null }
  | { DuplicateData: null }
  | { InvalidProperty: null }
  | { NotFound: null }
  | { IncorrectSetup: null }
  | { AlreadyClaimed: null }
  | { NotAuthorized: null }
  | { MaxDataExceeded: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { NoPacketsRemaining: null }
  | { UpdateFailed: null }
  | { CanisterCreateError: null }
  | { NeuronAlreadyUsed: null }
  | { FailedInterCanisterCall: null }
  | { InsufficientPacketsRemaining: null }
  | { InsufficientFunds: null }
  | { InEligible: null };
export interface Fixture {
  id: FixtureId;
  status: FixtureStatusType;
  highestScoringPlayerId: PlayerId;
  seasonId: SeasonId;
  awayClubId: ClubId;
  events: Array<PlayerEventData>;
  homeClubId: ClubId;
  kickOff: bigint;
  homeGoals: number;
  gameweek: GameweekNumber;
  awayGoals: number;
}
export type FixtureId = number;
export type FixtureStatusType =
  | { Unplayed: null }
  | { Finalised: null }
  | { Active: null }
  | { Complete: null };
export interface Fixtures {
  seasonId: SeasonId;
  fixtures: Array<Fixture>;
  leagueId: LeagueId;
}
export type GameweekNumber = number;
export type Gender = { Male: null } | { Female: null };
export interface GetBettableHomepageFixtures {
  leagueId: LeagueId;
}
export interface GetClubs {
  leagueId: LeagueId;
}
export type GetCountries = {};
export interface GetFixtures {
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export type GetLeagues = {};
export interface GetLoanedPlayers {
  leagueId: LeagueId;
}
export interface GetMatchOdds {
  fixtureId: FixtureId;
  leagueId: LeagueId;
}
export interface GetPlayers {
  leagueId: LeagueId;
}
export interface GetSeasons {
  leagueId: LeagueId;
}
export interface GetUserAudit {
  page: bigint;
  principalId: string;
}
export interface GetUserBets {
  principalId: PrincipalId;
}
export interface HalfTimeFullTimeOdds {
  firstHalfResult: MatchResult;
  odds: number;
  secondHalfResult: MatchResult;
}
export interface HalfTimeFullTimeResultDetail {
  fullTimeResult: MatchResult;
  halfTimeResult: MatchResult;
}
export interface HomePageFixture {
  fixtureId: FixtureId;
  homeOdds: number;
  drawOdds: number;
  awayOdds: number;
  gameweek: GameweekNumber;
  leagueId: LeagueId;
}
export interface League {
  id: LeagueId;
  logo: Uint8Array | number[];
  name: string;
  teamCount: number;
  relatedGender: Gender;
  countryId: CountryId;
  abbreviation: string;
  governingBody: string;
  formed: bigint;
}
export type LeagueId = number;
export interface Leagues {
  leagues: Array<League>;
}
export interface LoanedPlayers {
  players: Array<Player>;
}
export interface MatchOdds {
  fixtureId: FixtureId;
  lastAssist: Array<PlayerSelectionOdds>;
  correctScores: Array<ScoreSelectionOdds>;
  bothTeamsToScore: YesNoSelectionOdds;
  yellowCards: Array<PlayerSelectionOdds>;
  lastGoalscorers: Array<PlayerSelectionOdds>;
  halfTimeScores: Array<ScoreSelectionOdds>;
  anytimeAssist: Array<PlayerSelectionOdds>;
  penaltyMissers: Array<PlayerSelectionOdds>;
  redCards: Array<PlayerSelectionOdds>;
  anytimeScorers: Array<PlayerSelectionOdds>;
  correctResults: TeamSelectionOdds;
  penaltyMissed: MissPenaltyOdds;
  scoresHatTrick: Array<PlayerSelectionOdds>;
  scoresBrace: Array<PlayerSelectionOdds>;
  goalsOverUnder: OverUnderSelectionOdds;
  firstAssisters: Array<PlayerSelectionOdds>;
  leagueId: LeagueId;
  firstGoalscorers: Array<PlayerSelectionOdds>;
  halfTimeFullTimeResult: Array<HalfTimeFullTimeOdds>;
  bothTeamsToScoreAndWinner: Array<ResultAndYesNoSelectionOdds>;
}
export type MatchResult =
  | { HomeWin: null }
  | { Draw: null }
  | { AwayWin: null };
export interface MissPenaltyOdds {
  homeTeam: number;
  awayTeam: number;
}
export interface OverUnderSelection {
  odds: number;
  margin: number;
}
export interface OverUnderSelectionOdds {
  overOdds: Array<OverUnderSelection>;
  underOdds: Array<OverUnderSelection>;
}
export interface PauseAccount {
  pauseDays: bigint;
  principalId: PrincipalId;
}
export interface Player {
  id: number;
  status: PlayerStatus;
  clubId: ClubId;
  parentClubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  currentLoanEndDate: bigint;
  shirtNumber: number;
  parentLeagueId: LeagueId;
  position: PlayerPosition;
  lastName: string;
  leagueId: LeagueId;
  firstName: string;
}
export interface PlayerEventData {
  fixtureId: FixtureId;
  clubId: ClubId;
  playerId: number;
  eventStartMinute: number;
  eventEndMinute: number;
  eventType: PlayerEventType;
}
export interface PlayerEventDetail {
  clubId: ClubId;
  playerId: PlayerId;
}
export type PlayerEventType =
  | { PenaltyMissed: null }
  | { Goal: null }
  | { GoalConceded: null }
  | { Appearance: null }
  | { PenaltySaved: null }
  | { RedCard: null }
  | { KeeperSave: null }
  | { CleanSheet: null }
  | { YellowCard: null }
  | { GoalAssisted: null }
  | { OwnGoal: null }
  | { HighestScoringPlayer: null };
export interface PlayerGroupEventDetail {
  clubId: ClubId;
  playerId: PlayerId;
}
export type PlayerId = number;
export type PlayerPosition =
  | { Goalkeeper: null }
  | { Midfielder: null }
  | { Forward: null }
  | { Defender: null };
export interface PlayerSelectionOdds {
  playerId: PlayerId;
  odds: number;
}
export type PlayerStatus =
  | { OnLoan: null }
  | { Active: null }
  | { FreeAgent: null }
  | { Retired: null };
export interface Players {
  players: Array<Player>;
}
export type PrincipalId = string;
export interface Profile {
  username: string;
  maxBetLimit: bigint;
  monthlyBetLimit: bigint;
  withdrawalAddress: string;
  profilePictureExtension: string;
  accountBalance: bigint;
  kycApprovalDate: bigint;
  joinedDate: bigint;
  accountOnPause: boolean;
  termsAcceptedDate: bigint;
  kycComplete: boolean;
  kycRef: string;
  profilePicture: [] | [Uint8Array | number[]];
  kycSubmissionDate: bigint;
  principalId: PrincipalId;
  monthlyBetTotal: bigint;
}
export type Result = { ok: null } | { err: Error };
export interface ResultAndYesNoSelectionOdds {
  result: MatchResult;
  odds: number;
  isYes: boolean;
}
export type Result_1 = { ok: boolean } | { err: Error };
export type Result_10 = { ok: Fixtures } | { err: Error };
export type Result_11 = { ok: Array<DataHash> } | { err: Error };
export type Result_12 = { ok: Countries } | { err: Error };
export type Result_13 = { ok: Clubs } | { err: Error };
export type Result_14 = { ok: BettableHomepageFixtures } | { err: Error };
export type Result_15 = { ok: AppStatus } | { err: Error };
export type Result_2 = { ok: UserBets } | { err: Error };
export type Result_3 = { ok: UserAuditList } | { err: Error };
export type Result_4 = { ok: Seasons } | { err: Error };
export type Result_5 = { ok: Profile } | { err: Error };
export type Result_6 = { ok: Players } | { err: Error };
export type Result_7 = { ok: MatchOdds } | { err: Error };
export type Result_8 = { ok: LoanedPlayers } | { err: Error };
export type Result_9 = { ok: Leagues } | { err: Error };
export interface ScoreDetail {
  homeGoals: number;
  awayGoals: number;
}
export interface ScoreSelectionOdds {
  odds: number;
  homeGoals: number;
  awayGoals: number;
}
export interface Season {
  id: number;
  name: string;
  year: number;
}
export type SeasonId = number;
export interface Seasons {
  seasons: Array<Season>;
}
export interface Selection {
  status: SelectionStatus;
  result: BetResult;
  fixtureId: FixtureId;
  winnings: number;
  odds: number;
  stake: bigint;
  expectedReturns: bigint;
  selectionDetail: SelectionDetail;
  leagueId: LeagueId;
  selectionType: Category;
}
export type SelectionDetail =
  | { MissPenalty: PlayerEventDetail }
  | { LastAssist: PlayerEventDetail }
  | { PenaltyMissed: ClubEventDetail }
  | { FirstAssist: PlayerEventDetail }
  | { AnytimeGoalscorer: PlayerEventDetail }
  | { CorrectResult: CorrectResultDetail }
  | { HalfTimeScore: ScoreDetail }
  | { BothTeamsToScore: BothTeamsToScoreDetail }
  | { HalfTimeFullTimeResult: HalfTimeFullTimeResultDetail }
  | { LastGoalscorer: PlayerEventDetail }
  | { RedCard: PlayerEventDetail }
  | { ScoreHatrick: PlayerGroupEventDetail }
  | { CorrectScore: ScoreDetail }
  | { AnytimeAssist: PlayerEventDetail }
  | { YellowCard: PlayerEventDetail }
  | { BothTeamsToScoreAndWinner: BothTeamsToScoreAndWinnerDetail }
  | { FirstGoalscorer: PlayerEventDetail }
  | { ScoreBrace: PlayerGroupEventDetail };
export type SelectionStatus =
  | { Void: null }
  | { Unsettled: null }
  | { Settled: null };
export interface SetDailyBetLimit {
  maxBetLimit: bigint;
  principalId: PrincipalId;
}
export interface SetMonthlyBetLimit {
  monthlyBetLimit: bigint;
  principalId: PrincipalId;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface ShuftiAcceptedResponse {
  reference: string;
  event: string;
}
export interface ShuftiRejectedResponse {
  reference: string;
  event: string;
}
export type ShuftiResponse =
  | {
      ShuftiAcceptedResponse: ShuftiAcceptedResponse;
    }
  | { ShuftiRejectedResponse: ShuftiRejectedResponse };
export interface SubmitBetslip {
  expectedReturn: bigint;
  seasonId: SeasonId;
  totalStake: bigint;
  principalId: PrincipalId;
  leagueId: LeagueId;
}
export interface TeamSelectionOdds {
  homeOdds: number;
  drawOdds: number;
  awayOdds: number;
}
export interface UpdateProfilePicture {
  profilePictureExtension: string;
  profilePicture: Uint8Array | number[];
  principalId: PrincipalId;
}
export interface UpdateUsername {
  username: string;
  principalId: PrincipalId;
}
export interface UpdateWithdrawalAddress {
  withdrawalAddress: string;
  principalId: PrincipalId;
}
export interface UserAuditList {
  date: bigint;
  offset: bigint;
  users: Array<AuditRecord>;
}
export interface UserBets {
  bets: Array<BetSlip>;
}
export interface YesNoSelectionOdds {
  noOdds: number;
  yesOdds: number;
}
export interface _SERVICE {
  agreeTerms: ActorMethod<[], Result>;
  getAppStatus: ActorMethod<[], Result_15>;
  getBettableHomepageFixtures: ActorMethod<
    [GetBettableHomepageFixtures],
    Result_14
  >;
  getClubs: ActorMethod<[GetClubs], Result_13>;
  getCountries: ActorMethod<[GetCountries], Result_12>;
  getDataHashes: ActorMethod<[], Result_11>;
  getFixtures: ActorMethod<[GetFixtures], Result_10>;
  getLeagues: ActorMethod<[GetLeagues], Result_9>;
  getLoanedPlayers: ActorMethod<[GetLoanedPlayers], Result_8>;
  getMatchOdds: ActorMethod<[GetMatchOdds], Result_7>;
  getPlayers: ActorMethod<[GetPlayers], Result_6>;
  getProfile: ActorMethod<[], Result_5>;
  getSeasons: ActorMethod<[GetSeasons], Result_4>;
  getUserAudit: ActorMethod<[GetUserAudit], Result_3>;
  getUserBets: ActorMethod<[GetUserBets], Result_2>;
  isAuditor: ActorMethod<[], Result_1>;
  kycVerificationCallback: ActorMethod<[ShuftiResponse], Result>;
  notifyAppsOfFixtureComplete: ActorMethod<
    [LeagueId, SeasonId, GameweekNumber],
    Result
  >;
  notifyAppsOfFixtureFinalised: ActorMethod<
    [LeagueId, SeasonId, GameweekNumber],
    Result
  >;
  notifyAppsOfGameweekStarting: ActorMethod<
    [LeagueId, SeasonId, GameweekNumber],
    Result
  >;
  notifyAppsOfLoan: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfLoanExpired: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfPositionChange: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfRetirement: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfSeasonComplete: ActorMethod<[LeagueId, SeasonId], Result>;
  notifyAppsOfTransfer: ActorMethod<[LeagueId, PlayerId], Result>;
  pauseAccount: ActorMethod<[PauseAccount], Result>;
  placeBet: ActorMethod<[SubmitBetslip], Result>;
  setDailyBetLimit: ActorMethod<[SetDailyBetLimit], Result>;
  setMonthlyBetLimit: ActorMethod<[SetMonthlyBetLimit], Result>;
  storeKYCReference: ActorMethod<[string], undefined>;
  updateProfilePicture: ActorMethod<[UpdateProfilePicture], Result>;
  updateUsername: ActorMethod<[UpdateUsername], Result>;
  updateWithdrawalAddress: ActorMethod<[UpdateWithdrawalAddress], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
