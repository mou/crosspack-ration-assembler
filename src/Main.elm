module Main exposing (Msg(..), main, update, view)

import Browser
import Data.Menu exposing (Menu, menuDecoder)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Platform.Sub
import String



-- Model and Types


type alias Model =
    { days : Int
    , maxKcal : Maybe Int
    , maxPrice : Maybe Int
    , menu : MenuState
    }


type MenuState
    = Fetching
    | Fetched Menu
    | FetchFailed String


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1 Nothing Nothing Fetching
    , Http.get
        { url = "menu.json"
        , expect = Http.expectJson MenuFetched menuDecoder
        }
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Updates


type Msg
    = BuildRations
    | SetRationDays String
    | SetMaxKcal String
    | SetMaxPrice String
    | MenuFetched (Result Http.Error Menu)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( case msg of
        BuildRations ->
            model

        SetRationDays days ->
            let
                result =
                    String.toInt days
            in
            case result of
                Just number ->
                    { model | days = number }

                Nothing ->
                    model

        SetMaxKcal kcal ->
            let
                result =
                    String.toInt kcal
            in
            case result of
                Just number ->
                    { model | maxKcal = Just number }

                Nothing ->
                    model

        SetMaxPrice price ->
            let
                result =
                    String.toInt price
            in
            case result of
                Just number ->
                    { model | maxPrice = Just number }

                Nothing ->
                    model

        MenuFetched result ->
            case result of
                Ok menu ->
                    { model | menu = Fetched menu }

                Err _ ->
                    { model | menu = FetchFailed "Error fetching menu" }
    , Cmd.none
    )



-- View


selectOption : Int -> Int -> Html Msg
selectOption currentValue num =
    let
        strVal =
            String.fromInt num

        selectedAttributes =
            if num == currentValue then
                [ selected True ]

            else
                []
    in
    option (List.concat [ [ value strVal ], selectedAttributes ]) [ text strVal ]


view : Model -> Html Msg
view model =
    main_ [] <|
        case .menu model of
            Fetching ->
                [ h1
                    []
                    [ text "Собери свой рацион" ]
                , p [] [ text "Загрузка меню..." ]
                ]

            Fetched menu ->
                [ h1
                    []
                    [ text "Собери свой рацион" ]
                , p []
                    [ text "Меню загружено 23 минуты назад"
                    , br [] []
                    , text ("Доступно для закааза: " ++ (.dishes menu |> List.length |> String.fromInt) ++ " блюда")
                    ]
                , Html.form []
                    [ p []
                        [ label [ for "ration-days" ] [ text "На сколько дней составить рацион" ]
                        , select [ id "ration-days", name "ration_days", onInput SetRationDays ]
                            (List.range 1 5
                                |> List.map (selectOption (.days model))
                            )
                        ]
                    , p []
                        [ label [ for "ration-kcal", name "ration_kcal" ] [ text "Максимальная каллорийность:" ]
                        , input [ id "ration-kcal", onInput SetMaxKcal ] []
                        ]
                    , p []
                        [ label [ for "ration-price", name "ration_price" ] [ text "Максимальная стоимость за день:" ]
                        , input [ id "ration-price", onInput SetMaxPrice ] []
                        ]
                    , button [ type_ "button", onClick BuildRations ] [ text "Подобрать" ]
                    ]
                ]

            FetchFailed _ ->
                []
