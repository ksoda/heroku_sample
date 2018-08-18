module Main exposing (main)

import Html
    exposing
        ( Html
        , beginnerProgram
        , div
        , button
        , text
        )
import Debug exposing (crash)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)


main =
    beginnerProgram
        { view = view
        , model = model
        , update = update
        }



-- { view=crash "undef"
-- , model=crash "undef"
-- , update=crash "undef"
-- }


type alias Model =
    Int


model : Model
model =
    0



-- Update


type Msg
    = Inc
    | Dec



-- update : Msg -> Model -> Model


update msg model =
    case msg of
        Inc ->
            model + 1

        Dec ->
            model - 1



-- View


view : Model -> Html Msg
view model =
    div
        []
        [ button
            [ grayBackground
            , onClick Dec
            ]
            [ text "-" ]
        , div [] [ text (toString model) ]
        , button
            [ grayBackground
            , onClick Inc
            ]
            [ text "+" ]
        ]


grayBackground =
    style [ ( "background", "lightgray" ) ]
