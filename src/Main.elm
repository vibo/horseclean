module Main exposing (..)
import Html exposing (Html, div)
import Browser
import Dict exposing (Dict)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString)
import Json.Decode.Pipeline exposing (required, optional, hardcoded)
import Platform.Cmd as Cmd
import Browser exposing (Document)
import Browser.Navigation as Nav
import Url exposing (Url)

type alias TournamentSummary = 
    { id : Int 
    , name : String
    }

type alias Bet = 
  { id: Int
  , bet : String
  , matchId : Int
  , userId : Int }

type alias Tournament =
  { id : Int
  , bets : Dict String Bet
  , eliminationRounds : Dict String EliminationStage
  , groups : Dict String Group
  , matches : Dict String Match
  , name : String
  , stage : String
  , teams : Dict String Team
  , users : Dict String User
  }

type alias EliminationStage = 
  { name : String
  , matches : List Int
  }

type alias Group  = 
  { name : String
  , matches : List Int
  , teams : List Int 
  }

type alias Team  = 
  { id : Int
  , name : String
  , logo : String
  }


type alias Match =
  { id : Int
  , awayScore : Int
  , awayTeamId : Int
  , date : String
  , groupId : Int
  , homeScore : List Int
  , homeTeamId : Int
  , outcome : String
  , status : String
  , tournamentId : Int
  , stageId : Int
  } 

type alias User =
  { id : Int
  , name : String
  , sub : String
  }

type alias Score =
  { id : Int 
  , score : Int
  }

type alias Highscore =
  Dict String Score

type Page
  = Login 
  | Home
  | Tournament
  | Highscore
  | Match

type alias Model = 
  { page: Page
  , tournaments : Dict String Tournament 
  }


type Msg
    = RequestTournaments
    | ReceieveTournaments (Result Http.Error (Dict String Tournament))


betsDecoder : Decoder Bet
betsDecoder =
  Decode.map4 Bet
    (Decode.field "id" Decode.int )
    (Decode.field "bet" Decode.string)
    (Decode.field "matchId" Decode.int)
    (Decode.field "userId" Decode.int)

matchDecoder : Decoder Match
matchDecoder = 
  Decode.succeed Match
    |> required "id" Decode.int
    |> required "awayScore" Decode.int
    |> required "awayTeamId" Decode.int
    |> required "date" Decode.string
    |> required "groupId" Decode.int
    |> required "homeScore" (Decode.list Decode.int)
    |> required "homeTeamId" Decode.int
    |> required "outcome" Decode.string
    |> required "status" Decode.string
    |> required "tournamentId" Decode.int
    |> required "stageId" Decode.int

eliminationStageDecoder : Decoder EliminationStage
eliminationStageDecoder =
  Decode.map2 EliminationStage
    (Decode.field "name" Decode.string)
    (Decode.field "matches" (Decode.list Decode.int))

groupDecoder : Decoder Group
groupDecoder = 
  Decode.map3 Group
    (Decode.field "name" Decode.string)
    (Decode.field "matches" (Decode.list Decode.int))
    (Decode.field "teams" (Decode.list Decode.int))

teamDecoder : Decoder Team
teamDecoder =
  Decode.map3 Team
    (Decode.field "id" Decode.int)
    (Decode.field "name" Decode.string)
    (Decode.field "logo" Decode.string)

userDecoder : Decoder User
userDecoder =
  Decode.map3 User
    (Decode.field "id" Decode.int)
    (Decode.field "name" Decode.string)
    (Decode.field "sub" Decode.string)

tournamentDecoder : Decoder Tournament
tournamentDecoder =
  Decode.succeed Tournament
    |> required "id" Decode.int
    |> required "bets" (Decode.dict betsDecoder)
    |> required "eliminationRounds" (Decode.dict eliminationStageDecoder)
    |> required "groups" (Decode.dict groupDecoder)
    |> required "matches" (Decode.dict matchDecoder)
    |> required "name" Decode.string
    |> required "stage" Decode.string
    |> required "teams" (Decode.dict teamDecoder)
    |> required "users" (Decode.dict userDecoder)

fetchTournaments : Cmd Msg
fetchTournaments =
  Http.get 
    { url = ""
    , expect = Http.expectJson ReceieveTournaments (Decode.dict tournamentDecoder) }


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


init : ( Model, Cmd Msg )
init =
    { tournaments = Dict.empty }

update : Msg -> Model -> (Model, Cmd.Cmd Msg)
update msg model =
  case msg of
    RequestTournaments ->
      (model, fetchTournaments)

    ReceieveTournaments (Ok tournaments) ->
      ({model | tournaments = tournaments }, Cmd.none)
    
    ReceieveTournaments (Err _) ->
      (model, Cmd.none)

view : Model -> Html Msg
view model =
  div [] []


