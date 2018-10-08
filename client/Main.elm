module Main exposing (main)

import Browser
import Debug exposing (log, toString)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Body)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Url.Builder as Builder exposing (QueryParameter)


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


type alias Form =
    { email : String
    , password : String
    }


type FormField
    = Email
    | Password


type alias Token =
    String


type alias Model =
    { todos : List Todo
    , field : String
    , token : Maybe Token
    , form : Form
    , origin : Maybe String
    }


init : Maybe String -> ( Model, Cmd Msg )
init origin =
    ( Model [] "" Nothing { email = "", password = "" } origin
    , fetchTodos origin
    )



-- UPDATE


type Msg
    = NoOp
    | FetchedAll (Result Http.Error (List Todo))
    | Created (Result Http.Error Todo)
    | Add
    | UpdateField String
    | UpdateEmailForm String
    | UpdatePasswordForm String
    | SignedIn (Result Http.Error Token)
    | SubmittedForm


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
            ( model, add model )

        UpdateField str ->
            ( { model | field = str }
            , Cmd.none
            )

        UpdateEmailForm val ->
            ( { model
                | form =
                    { email = val
                    , password = model.form.password
                    }
              }
            , Cmd.none
            )

        UpdatePasswordForm val ->
            ( { model
                | form =
                    { password = val
                    , email = model.form.email
                    }
              }
            , Cmd.none
            )

        SignedIn result ->
            case result of
                Ok val ->
                    ( { model
                        | token = Just val
                        , form = Form "" ""
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )

        SubmittedForm ->
            ( model
            , signIn model
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ section [ class "todoapp" ]
            [ header [ class "header" ]
                [ input
                    [ value model.field
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
                [ todosView model.todos
                ]
            ]
        , case model.token of
            Just _ ->
                text ""

            Nothing ->
                signInFormView model.form
        ]


signInFormView form =
    Html.form [ onSubmit SubmittedForm ]
        [ label []
            [ text "Email"
            , input
                [ type_ "text"
                , onInput UpdateEmailForm
                , value form.email
                , attribute "autocomplete" "email"
                ]
                []
            ]
        , label []
            [ text "Password"
            , input
                [ type_ "password"
                , onInput UpdatePasswordForm
                , value form.password
                , autocomplete True
                ]
                []
            ]
        , button
            [ style "background-color" "lightgray" ]
            [ text "Sign in" ]
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


resourceUrl : Maybe String -> (List String -> List QueryParameter -> String)
resourceUrl origin =
    case origin of
        Just o ->
            Builder.crossOrigin o

        Nothing ->
            Builder.absolute


fetchTodos : Maybe String -> Cmd Msg
fetchTodos origin =
    Http.send FetchedAll <|
        Http.get (resourceUrl origin [ "todos" ] []) <|
            Decode.list todoDecoder


add : Model -> Cmd Msg
add { field, origin, todos, token } =
    let
        json =
            Encode.object
                [ ( "id", Encode.int (nextId todos) )
                , ( "title", Encode.string field )
                ]

        body =
            Http.stringBody "application/json" (Encode.encode 0 json)

        req =
            post (resourceUrl origin [ "todos" ] []) token body todoDecoder
    in
    Http.send Created req


signIn : Model -> Cmd Msg
signIn { origin, form } =
    let
        body =
            Encode.object
                [ ( "email", Encode.string form.email )
                , ( "password", Encode.string form.password )
                ]
                |> Http.jsonBody
    in
    Http.send SignedIn <|
        Http.post
            (resourceUrl origin [ "authentication" ] [])
            body
            (Decode.field "token" Decode.string)


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


post : String -> Maybe Token -> Body -> Decoder a -> Http.Request a
post url token body decoder =
    Http.request
        { method = "POST"
        , url = url
        , expect = Http.expectJson decoder
        , headers =
            case token of
                Just t ->
                    [ Http.header "Authorization" ("Token token=" ++ t) ]

                Nothing ->
                    []
        , body = body
        , timeout = Nothing
        , withCredentials = False
        }
