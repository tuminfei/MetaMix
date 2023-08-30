import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import ICRaw "mo:base/ExperimentalInternetComputer";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";
import TrieMap "mo:base/TrieMap";

import Types "./types";
import Wordlists "eip39_wordlists";
import Conversion "util/conversion";
import Utils "util/utils";

shared actor class MetaMix(owner : Principal) = Self {
  stable var _owner : Principal = owner;

  public shared (msg) func setOwner(owner : Principal) : async () {
    assert (msg.caller == _owner);
    _owner := owner;
  };

  public query (msg) func getOwner() : async Principal {
    _owner;
  };

  public shared (msg) func getRandomToken(remaingTokenSize : Nat) : async [Text] {
    var wordlists : [Text] = Wordlists.get_worklists();
    var wordlists_size : Nat = wordlists.size();
    var random_word : [Text] = [];
    var bucket_counts : [Nat] = [0, 256, 512, 768, 1024, 1280, 1536, 1792];

    var seed = await Random.blob();
    var generator = Random.Finite(seed);

    for (i in Iter.range(0, 23)) {
      var bucket_index = i % bucket_counts.size();
      var random : Nat = Conversion.valueToNat(#Nat8(Utils.unwrap(generator.byte())));
      var word_index : Nat = bucket_counts[bucket_index] + random;
      if (word_index > Nat.sub(wordlists_size, 1)) {
        word_index := word_index % wordlists_size;
      };
      random_word := Array.append(random_word, [wordlists[word_index]]);
    };

    Debug.print(debug_show ("+++++: ", random_word));
    return random_word;
  };
};
