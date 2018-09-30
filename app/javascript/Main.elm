module Main exposing (main)

import Browser
import Html exposing (..)
import Http
import Json.Decode as Decode


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
    | FetchAll (Result Http.Error (List Todo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FetchAll result ->
            case result of
                Ok todos ->
                    ( { model | todos = todos }, Cmd.none )

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
        Http.get "http://localhost:3000/todos" <|
            Decode.list todoDecoder


todoDecoder : Decode.Decoder Todo
todoDecoder =
    Decode.field "title" Decode.string
