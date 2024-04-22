module Evergreen.V135.User exposing (..)

import Evergreen.V135.EmailAddress
import Time


type Role
    = AdminRole
    | UserRole


type alias LoginData =
    { username : String
    , role : Role
    }


type alias User =
    { id : String
    , realname : String
    , username : String
    , email : Evergreen.V135.EmailAddress.EmailAddress
    , created_at : Time.Posix
    , updated_at : Time.Posix
    , role : Role
    , recentLoginEmails : List Time.Posix
    }


type alias Id =
    String
