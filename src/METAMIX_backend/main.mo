import Array "mo:base/Array";
import Blob "mo:base/Blob";
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
import Ed25519Lib "mo:ed25519";

import Types "./types";
import Wordlists "util/bip39_wordlists";
import Conversion "util/conversion";
import Utils "util/utils";

shared actor class MetaMix(owner : Principal) = Self {
    stable var _owner : Principal = owner;
    stable var next_mnemonic_id : Nat = 0;
    stable var next_wallet_id : Nat = 0;
    stable var next_blockchain_id : Nat = 0;
    stable var mnemonics_entries : [(Nat, [Text])] = [];
    stable var wallets_entries : [(Nat, Types.Wallet)] = [];
    stable var blockchains_entries : [(Nat, Types.BlockChain)] = [];

    var mnemonics : TrieMap.TrieMap<Nat, [Text]> = TrieMap.fromEntries(mnemonics_entries.vals(), Nat.equal, Hash.hash);
    var wallets : TrieMap.TrieMap<Nat, Types.Wallet> = TrieMap.fromEntries(wallets_entries.vals(), Nat.equal, Hash.hash);
    var blockchains : TrieMap.TrieMap<Nat, Types.BlockChain> = TrieMap.fromEntries(blockchains_entries.vals(), Nat.equal, Hash.hash);

    public shared ({ caller }) func caninster_init() : async () {
        if (next_blockchain_id < 3) {
            var blockchain_id = next_blockchain_id;
            next_blockchain_id += 1;
            let blockchain_ic : Types.BlockChain = {
                id = blockchain_id;
                title = "Dfinity";
                symbol = "IC";
                chain_id = 0;
                key_type = #ed25519;
                token_code = "IC";
                token_decimals = 18;
                address_type = #principal;
            };
            blockchains.put(blockchain_id, blockchain_ic);

            blockchain_id := next_blockchain_id;
            next_blockchain_id += 1;
            let blockchain_eth : Types.BlockChain = {
                id = blockchain_id;
                title = "Ethereum";
                symbol = "ETH";
                chain_id = 0;
                key_type = #secp256k1;
                token_code = "ETH";
                token_decimals = 18;
                address_type = #hex;
            };
            blockchains.put(blockchain_id, blockchain_eth);
        };
    };

    public shared (msg) func setOwner(owner : Principal) : async () {
        assert (msg.caller == _owner);
        _owner := owner;
    };

    public query (msg) func getOwner() : async Principal {
        _owner;
    };

    public query (msg) func get_blockchain(blockchain_id : Nat) : async ?Types.BlockChain {
        blockchains.get(blockchain_id);
    };

    public shared (msg) func add_mnemonic() : async Nat {
        let mnemonic_id = next_mnemonic_id;
        next_mnemonic_id += 1;
        let mnemonic : [Text] = await _generate_random_mnemonic(24);
        mnemonics.put(mnemonic_id, mnemonic);
        return mnemonic_id;
    };

    public query (msg) func get_mnemonic(mnemonic_id : Nat) : async ?[Text] {
        mnemonics.get(mnemonic_id);
    };

    public shared (msg) func add_wallet(wallet_type : Types.KeyType, title : Text) : async Types.Wallet {
        var private_key : [Nat8] = [];
        var public_key : [Nat8] = [];
        var seed : Text = "";
        var address : Text = "";
        let wallet_id = next_wallet_id;
        next_wallet_id += 1;
        switch (wallet_type) {
            case (#ed25519) {
                private_key := Ed25519Lib.Utils.randomPrivateKey();
                public_key := Ed25519Lib.ED25519.getPublicKey(private_key);
            };
            case (_) {};
        };
        let wallet : Types.Wallet = {
            id = wallet_id;
            title;
            blockchain_id = 1;
            address_type = #default;
            key_type = #ed25519;
            mnemonic = "";
            private_key;
            public_key;
            seed;
            address;
        };
        wallets.put(wallet_id, wallet);
        return wallet;
    };

    private func _generate_random_mnemonic(mnemonic_size : Nat) : async [Text] {
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

        Debug.print(debug_show ("random_word: ", random_word));
        return random_word;
    };

    system func preupgrade() {
        mnemonics_entries := Iter.toArray(mnemonics.entries());
        blockchains_entries := Iter.toArray(blockchains.entries());
    };
};
