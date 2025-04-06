import Result "mo:base/Result";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Enums "mo:waterway-mops/Enums";
module MopsAccountUtilities {


  private let base : Nat8 = 0x10;
  
  private let symbols = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
  ];

  private func decodeW4(char : Char) : Result.Result<Nat8, Enums.Error> {
    for (i in Iter.range(0, 15)) {
      if (symbols[i] == char) {
        return #ok(Nat8.fromNat(i));
      };
    };
    #err(#DecodeError);
  };

  public func decode(text : Text) : Result.Result<[Nat8], Enums.Error> {
    let next = text.chars().next;
    func parse() : Result.Result<Nat8, Enums.Error> {
      Option.get<Result.Result<Nat8, Enums.Error>>(
        do ? {
          let c1 = next()!;
          let c2 = next()!;
          Result.chain<Nat8, Nat8, Enums.Error>(
            decodeW4(c1),
            func(x1) {
              Result.chain<Nat8, Nat8, Enums.Error>(
                decodeW4(c2),
                func(x2) {
                  #ok(x1 * base + x2);
                },
              );
            },
          );
        },
        #err(#DecodeError),
      );
    };
    var i = 0;
    let n = text.size() / 2 + text.size() % 2;
    let array = Array.init<Nat8>(n, 0);
    while (i != n) {
      switch (parse()) {
        case (#ok w8) {
          array[i] := w8;
          i += 1;
        };
        case (#err err) {
          return #err err;
        };
      };
    };
    #ok(Array.freeze<Nat8>(array));
  };
}