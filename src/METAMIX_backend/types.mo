import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";

module {
  public type Result<T, E> = Result.Result<T, E>;
  public type Account = { owner : Principal };

  public type KeyType = {
    #secp256k1;
    #ecdsa;
    #ed25519;
    #sr25519;
  };

  public type AddressType = {
    #account;
    #main;
  };

  public type Wallet = {
    id : Nat;
    title : Text;
    seed : Text;
    key_type : KeyType;
    mnemonic : Text;
    blockchain_id : Nat;
    public_key : [Nat8];
    private_key : [Nat8];
    address : Text;
    default_address_type : AddressType;
  };

  public type BlockChain = {
    id : Nat;
    title : Text;
    chain_id : Nat;
    key_type : KeyType;
    token_code : Text;
    token_decimals : Nat;
  };

  public type Network = {
    id : Nat;
    blockchain_id : Nat;
    name : Text;
    url : Text;
    chain_id : Nat;
    token_code : Text;
    explorer_url : Text;
  };
};
