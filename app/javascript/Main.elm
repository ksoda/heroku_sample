module Main exposing (main)

import Debug exposing (crash)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy, lazy2)


main =
    beginnerProgram
        { model = model
        , update = update
        , view = view
        }


type alias Model =
    { todo : String
    , todos : List String
    }


model : Model
model =
    { todo = ""
    , todos = []
    }


type Msg
    = UpdateTodo String
    | AddTodo
    | RemoveAll
    | RemoveItem String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTodo text ->
            { model | todo = text }

        AddTodo ->
            { model
                | todos = model.todo :: model.todos
                , todo = ""
            }

        RemoveAll ->
            { model | todos = [] }

        RemoveItem text ->
            { model | todos = List.filter (\x -> x /= text) model.todos }


todoItem : String -> Html Msg
todoItem todo =
    li []
        [ text todo
        , button [ onClick (RemoveItem todo) ] [ text "x" ]
        ]


todoList : List String -> Html Msg
todoList todos =
    let
        child =
            List.map todoItem todos
    in
    ul [] child


view : Model -> Html Msg
view model =
    div []
        [ input
            [ type_ "text"
            , onInput UpdateTodo
            , value model.todo
            ]
            []
        , button [ onClick AddTodo ] [ text "Submit" ]
        , button [ onClick RemoveAll ] [ text "Remove All" ]
        , div [] [ todoList model.todos ]
        ]
