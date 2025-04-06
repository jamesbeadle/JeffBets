import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Ids "mo:waterway-mops/Ids";
import FootballTypes "mo:waterway-mops/football/FootballTypes";
import FixtureQueries "mo:waterway-mops/queries/football-queries/FixtureQueries";
import BettingEnums "../enums/betting_enums";

module BettingTypes {

    /* Match odds related types */

    public type MatchOdds = {
        leagueId: FootballIds.LeagueId;
        gameweek: FootballDefinitions.GameweekNumber;
        fixtureId: FootballIds.FixtureId;
        correctResults: TeamSelectionOdds;
        correctScores: [ScoreSelectionOdds];
        halfTimeScores: [ScoreSelectionOdds];
        firstGoalscorers: [PlayerSelectionOdds];
        lastGoalscorers: [PlayerSelectionOdds];
        anytimeScorers: [PlayerSelectionOdds];
        yellowCards: [PlayerSelectionOdds];
        redCards: [PlayerSelectionOdds];
        penaltyMissed: MissPenaltyOdds;
        penaltyMissers: [PlayerSelectionOdds];
        firstAssisters: [PlayerSelectionOdds];
        lastAssist: [PlayerSelectionOdds];
        anytimeAssist: [PlayerSelectionOdds];
        scoresBrace: [PlayerSelectionOdds];
        scoresHatTrick: [PlayerSelectionOdds];
        goalsOverUnder: OverUnderSelectionOdds;
        bothTeamsToScore: YesNoSelectionOdds;
        halfTimeFullTimeResult: [HalfTimeFullTimeOdds];
        bothTeamsToScoreAndWinner: [ResultAndYesNoSelectionOdds];
    };

    public type TeamSelectionOdds = {
        homeOdds: Float;
        drawOdds: Float;
        awayOdds: Float;
    };

    public type ScoreSelectionOdds = {
        homeGoals: Nat8;
        awayGoals: Nat8;
        odds: Float;
    };

    public type PlayerSelectionOdds = {
        playerId: FootballIds.PlayerId;
        odds: Float;
    };

    public type OverUnderSelectionOdds = {
        overOdds: [OverUnderSelection];
        underOdds: [OverUnderSelection];
    };

    public type OverUnderSelection = {
        margin: Float;
        odds: Float;
    };

    public type YesNoSelectionOdds = {
        yesOdds: Float;
        noOdds: Float;
    };

    public type HalfTimeFullTimeOdds = {
        firstHalfResult: MatchResult;
        secondHalfResult: MatchResult;
        odds: Float;
    };

    public type ResultAndYesNoSelectionOdds = {
        result: MatchResult;
        isYes: Bool;
        odds: Float;
    };

    public type MissPenaltyOdds = {
        homeTeam: Float;
        awayTeam: Float;
    };

    /* Betting slip related types */

    public type BetSlip = {
        id: Nat;
        placedBy: Ids.PrincipalId;
        placedOn: Int;
        status: BettingEnums.SelectionStatus;
        result: BettingEnums.BetResult;
        selections: [Selection];
        betType: BetType;
        totalStake: Nat64;
        expectedReturns: Nat64;
        totalWinnings: Nat64;
        settledOn: Int;
    };

    public type Selection = {
        leagueId: FootballIds.LeagueId;
        selectionType: Category;
        selectionDetail: SelectionDetail;
        status: BettingEnums.SelectionStatus;
        result: BettingEnums.BetResult;
        odds: Float;
        stake: Nat64;
        fixtureId: FootballIds.FixtureId;
        winnings: Float;
        expectedReturns: Nat64;
    };

    public type Event = {
        fixtureId: FootballIds.FixtureId;
        results: EventResults; 
    };

    public type EventResults = {
        correctResult: CorrectResultDetail;
        correctScore: ScoreDetail;
        firstGoalscorer: PlayerEventDetail;
        lastGoalscorer: PlayerEventDetail;
        anytimeGoalscorer: [PlayerEventDetail];
        yellowCard: [PlayerEventDetail];
        redCard: [PlayerEventDetail];
        penaltyMissed: [ClubEventDetail];
        missPenalty : [PlayerEventDetail];
        firstAssist : PlayerEventDetail;
        lastAssist : PlayerEventDetail;
        anytimeAssist : [PlayerEventDetail];
        scoreBrace : [PlayerGroupEventDetail];
        scoreHatrick : [PlayerGroupEventDetail];
        halfTimeScore : ScoreDetail;
        bothTeamsToScore : BothTeamsToScoreDetail;
        halfTimeFullTimeResult : HalfTimeFullTimeResultDetail;
        bothTeamsToScoreAndWinner : BothTeamsToScoreAndWinnerDetail;
    };

    public type CorrectResultDetail = {
        matchResult: MatchResult;
    };

    public type ClubEventDetail = {
        clubId: FootballIds.ClubId;
    };

    public type ScoreDetail = {
        homeGoals: Nat8;
        awayGoals: Nat8;
    };

    public type PlayerEventDetail = {
        clubId: FootballIds.ClubId;
        playerId: FootballIds.PlayerId;
    };

    public type PlayerGroupEventDetail = {
        clubId: FootballIds.ClubId;
        playerId: FootballIds.PlayerId;
    };

    public type BothTeamsToScoreDetail = {
        bothTeamsToScore: Bool;
    };

    public type HalfTimeFullTimeResultDetail = {
        halfTimeResult: MatchResult;
        fullTimeResult: MatchResult;
    };

    public type BothTeamsToScoreAndWinnerDetail = {
        bothTeamsToScore: Bool;
        matchResult: MatchResult;
    };

    public type Category = {
        #CorrectResult;
        #CorrectScore;
        #FirstGoalscorer;
        #LastGoalscorer;
        #AnytimeGoalscorer;
        #YellowCard;
        #RedCard;
        #PenaltyMissed;
        #MissPenalty;
        #FirstAssist;
        #LastAssist;
        #AnytimeAssist;
        #ScoreBrace;
        #ScoreHatrick;
        #HalfTimeScore;
        #BothTeamsToScore;
        #HalfTimeFullTimeResult;
        #BothTeamsToScoreAndWinner;
    };


    public type BetType = {
        #Single;
        #Double;
        #Treble;
        #FourFold;
        #FiveFold;
        #SixFold;
        #SevenFold;
        #EightFold;
        #NineFold;
        #TenFold;
        #Lucky15;
        #Lucky31;
        #Lucky63;
        #Trixie;
        #Patent;
        #Yankee;
        #Canadian;
        #Heinz;
        #SuperHeinz;
        #Goliath;
    };


    public type MatchResult = {
        #HomeWin;
        #Draw;
        #AwayWin;
    };

    public type SelectionDetail = {
        #CorrectResult: CorrectResultDetail;
        #CorrectScore: ScoreDetail;
        #FirstGoalscorer: PlayerEventDetail;
        #LastGoalscorer: PlayerEventDetail;
        #AnytimeGoalscorer: PlayerEventDetail;
        #YellowCard: PlayerEventDetail;
        #RedCard: PlayerEventDetail;
        #PenaltyMissed: ClubEventDetail;
        #MissPenalty : PlayerEventDetail;
        #FirstAssist : PlayerEventDetail;
        #LastAssist : PlayerEventDetail;
        #AnytimeAssist : PlayerEventDetail;
        #ScoreBrace : PlayerGroupEventDetail;
        #ScoreHatrick : PlayerGroupEventDetail;
        #HalfTimeScore : ScoreDetail;
        #BothTeamsToScore : BothTeamsToScoreDetail;
        #HalfTimeFullTimeResult : HalfTimeFullTimeResultDetail;
        #BothTeamsToScoreAndWinner : BothTeamsToScoreAndWinnerDetail;
    };

    public type Stats = {
        currentSeasonFixtures: [FixtureQueries.Fixture];
        bettingFixture: FixtureQueries.Fixture;
        priorSeasonTable: FootballTypes.LeagueTable;
        homeTeamPriorSeasonFinish: Nat;
        awayTeamPriorSeasonFinish: Nat;
        totalHomeClubPoints: Nat;
        totalAwayClubPoints: Nat;
        totalGameweeks: Nat8;
        homeCurrentSeasonWinPercentage: Float;
        awayCurrentSeasonWinPercentage: Float;
    };


    



};
