module Main exposing (main)

import Browser
import Html exposing (..)
import Http


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Todo =
    String


type alias Model =
    { todos : List Todo
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model []
    , fetchTodos
    )



-- UPDATE


type Msg
    = NoOp
    | FetchAll (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FetchAll result ->
            case result of
                Ok dummy ->
                    ( { model | todos = [ dummy ] }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



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



-- HTTP


fetchTodos : Cmd Msg
fetchTodos =
    Http.send FetchAll <|
        Http.getString "http://localhost:3000/todos"
