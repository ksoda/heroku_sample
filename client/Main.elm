module Main exposing (main)

import Browser
import Debug exposing (log, toString)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Json.Encode as Encode


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Todo =
    { id : Int, title : String }


type alias Model =
    { todos : List Todo
    , field : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] ""
    , fetchTodos
    )



-- UPDATE


type Msg
    = NoOp
    | FetchedAll (Result Http.Error (List Todo))
    | Created (Result Http.Error Todo)
    | Add
    | UpdateField String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FetchedAll result ->
            case result of
                Ok todos ->
                    ( { model | todos = todos }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        Created result ->
            case result of
                Ok t ->
                    ( { model | todos = model.todos ++ [ t ], field = "" }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        Add ->
            ( model, add model.field (nextId model.todos) )

        UpdateField str ->
            ( { model | field = str }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view { todos, field } =
    section [ class "todoapp" ]
        [ header [ class "header" ]
            [ input
                [ value field
                , onInput UpdateField
                , autofocus True
                ]
                []
            , button
                [ onClick Add
                , style "padding" "3px .5em"
                , style "background-color" "lightgray"
                ]
                [ text "+" ]
            ]
        , section [ class "main" ]
            [ todosView todos
            ]
        ]


todosView : List Todo -> Html Msg
todosView todos =
    ul [ class "todo-list" ] (List.map todoView todos)


todoView : Todo -> Html Msg
todoView { title } =
    li []
        [ div [ class "view" ]
            [ label [] [ text title ] ]
        ]



-- HTTP


resourceUrl : String
resourceUrl =
    "http://localhost:3000/todos"


fetchTodos : Cmd Msg
fetchTodos =
    Http.send FetchedAll <|
        Http.get resourceUrl <|
            Decode.list todoDecoder


add : String -> Int -> Cmd Msg
add title id =
    let
        json =
            Encode.object
                [ ( "id", Encode.int id )
                , ( "title", Encode.string title )
                ]

        body =
            Http.stringBody "application/json" (Encode.encode 0 json)
    in
    Http.send Created <|
        Http.post resourceUrl body todoDecoder


todoDecoder : Decode.Decoder Todo
todoDecoder =
    Decode.map2 Todo
        (Decode.field "id" Decode.int)
        (Decode.field "title" Decode.string)


nextId : List Todo -> Int
nextId todos =
    let
        max =
            todos
                |> List.map .id
                |> List.maximum
    in
    Maybe.withDefault 0 max + 1
