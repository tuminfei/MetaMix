let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.8.8-20230505/package-set.dhall sha256:a080991699e6d96dd2213e81085ec4ade973c94df85238de88bc7644a542de5d
let Package = { name : Text, version : Text, repo : Text, dependencies : List Text }
let additions = [
  { name = "crypto"
  , repo = "https://github.com/Bochslertech/crypto"
  , version = "v0.1"
  , dependencies = [ "base"]
  },
  { name = "ext"
  , repo = "https://github.com/Bochslertech/ext"
  , version = "v0.1"
  , dependencies = [ "base", "crypto" ]
  },
  { name = "array"
  , repo = "https://github.com/aviate-labs/array.mo"
  , version = "v0.1.1"
  , dependencies = [ "base" ]
  },
  { name = "hash"
  , repo = "https://github.com/aviate-labs/hash.mo"
  , version = "v0.1.0"
  , dependencies = [ "base" ]
  },
  { name = "encoding"
  , repo = "https://github.com/aviate-labs/encoding.mo"
  , version = "v0.3.0"
  , dependencies = [ "base", "array" ]
  },
  { name = "sha"
  , repo = "https://github.com/aviate-labs/sha.mo"
  , version = "v0.1.1"
  , dependencies = [ "base", "encoding" ]
  },
  { name = "principal"
  , repo = "https://github.com/aviate-labs/principal.mo"
  , version = "v0.2.4"
  , dependencies = [ "array", "base", "hash", "encoding", "sha" ],
  },
  { name = "parser-combinators"
  , repo = "https://github.com/aviate-labs/parser-combinators.mo"
  , version = "v0.1.0"
  , dependencies = ["base"]
  },
  { name = "json"
  , repo = "https://github.com/aviate-labs/json.mo"
  , version = "v0.1.2"
  , dependencies = [ "parser-combinators"],
  },
  { name = "cap"
  , repo = "https://github.com/Psychedelic/cap-motoko-library"
  , version = "v1.0.4"
  , dependencies = [ "base" ]
  },
  { name = "canistergeek"
  , repo = "https://github.com/usergeek/canistergeek-ic-motoko"
  , version = "v0.0.4"
  , dependencies = ["base"] : List Text
  },
  { name = "ecdsa"
  , repo = "https://github.com/tuminfei/ecdsa-motoko"
  , version = "v0.0.1"
  , dependencies = [ "base" ]
  },
  { name = "ed25519"
  , version = "v1.0.0"
  , repo = "https://github.com/nirvana369/ed25519.git"
  , dependencies = [ "base" ] : List Text
  }
] : List Package
in  upstream # additions