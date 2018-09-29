module Main exposing (main)

import Browser
import Html exposing (..)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Todo =
    String


type alias Model =
    { todos : List Todo
    }


init =
    { todos =
        [ "Task1"
        , "Task2"
        ]
    }



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        (model.todos
            |> List.map
                (\x ->
                    li [] [ text x ]
                )
        )
