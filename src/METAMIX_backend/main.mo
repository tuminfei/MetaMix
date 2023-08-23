import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Error "mo:base/Error";
import ICRaw "mo:base/ExperimentalInternetComputer";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";
import TrieMap "mo:base/TrieMap";

import Types "./types";
shared actor class MetaMix(owner : Principal) = Self {
  stable var _owner : Principal = owner;

  public shared (msg) func setOwner(owner : Principal) : async () {
    assert (msg.caller == _owner);
    _owner := owner;
  };

  public query (msg) func getOwner() : async Principal {
    _owner;
  };
};
