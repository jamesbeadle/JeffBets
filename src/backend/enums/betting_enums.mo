
module BettingEnums {


    public type SelectionStatus = {
        #Unsettled;
        #Settled;
        #Void;
    };

    public type BetResult = {
        #Open;
        #Won;
        #Lost;
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

};
