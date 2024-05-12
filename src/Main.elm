module Main exposing (..)
import Html exposing (Html, div)
import Browser
import Dict exposing (Dict)


type alias TournamentSummary = 
  { id : Int
  , name : String
  }

type alias Tournament =
  { id : Int
  , elimination :Dict String EliminationStage
  , groups : Dict String Group
  , name : String
  , stage : String
  , teams : Dict String Team
  }

type alias EliminationStage = 
  { name : String
  , matches : Dict String Match
  }

type alias Group  = 
  { name : String
  , matches : Dict String Match
  , teams : Dict String Team 
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


type alias Model = 
    { }

type Msg
    = NoOp

main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }

init : Model
init =
    { }

update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

view : Model -> Html Msg
view model =
    div [] []

