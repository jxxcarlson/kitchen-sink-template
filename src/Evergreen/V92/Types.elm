module Evergreen.V92.Types exposing (..)

import AssocList
import BiDict
import Browser
import Browser.Navigation
import Dict
import Evergreen.V92.Id
import Evergreen.V92.LocalUUID
import Evergreen.V92.Postmark
import Evergreen.V92.Route
import Evergreen.V92.Stripe.Codec
import Evergreen.V92.Stripe.Product
import Evergreen.V92.Stripe.PurchaseForm
import Evergreen.V92.Stripe.Stripe
import Evergreen.V92.Untrusted
import Evergreen.V92.User
import Evergreen.V92.Weather
import Http
import Lamdera
import Time
import Url


type alias InitData2 =
    { prices :
        AssocList.Dict
            (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId)
            { priceId : Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.PriceId
            , price : Evergreen.V92.Stripe.Stripe.Price
            }
    , productInfo : AssocList.Dict (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId) Evergreen.V92.Stripe.Stripe.ProductInfo
    }


type alias LoadingModel =
    { key : Browser.Navigation.Key
    , now : Time.Posix
    , window :
        Maybe
            { width : Int
            , height : Int
            }
    , route : Evergreen.V92.Route.Route
    , initData : Maybe InitData2
    }


type SignInState
    = SignedOut
    | SignUp
    | SignedIn


type AdminDisplay
    = ADStripe
    | ADUser
    | ADKeyValues


type alias BackendModel =
    { randomAtmosphericNumbers : Maybe (List Int)
    , localUuidData : Maybe Evergreen.V92.LocalUUID.Data
    , userDictionary : Dict.Dict String Evergreen.V92.User.User
    , sessions : BiDict.BiDict Lamdera.SessionId String
    , orders : AssocList.Dict (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.StripeSessionId) Evergreen.V92.Stripe.Codec.Order
    , pendingOrder : AssocList.Dict (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.StripeSessionId) Evergreen.V92.Stripe.Codec.PendingOrder
    , expiredOrders : AssocList.Dict (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.StripeSessionId) Evergreen.V92.Stripe.Codec.PendingOrder
    , prices : AssocList.Dict (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId) Evergreen.V92.Stripe.Codec.Price2
    , time : Time.Posix
    , products : Evergreen.V92.Stripe.Stripe.ProductInfoDict
    , keyValueStore : Dict.Dict String String
    }


type alias LoadedModel =
    { key : Browser.Navigation.Key
    , now : Time.Posix
    , window :
        { width : Int
        , height : Int
        }
    , showTooltip : Bool
    , prices :
        AssocList.Dict
            (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId)
            { priceId : Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.PriceId
            , price : Evergreen.V92.Stripe.Stripe.Price
            }
    , productInfoDict : AssocList.Dict (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId) Evergreen.V92.Stripe.Stripe.ProductInfo
    , selectedProduct : Maybe ( Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId, Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.PriceId, Evergreen.V92.Stripe.Product.Product_ )
    , form : Evergreen.V92.Stripe.PurchaseForm.PurchaseForm
    , currentUser : Maybe Evergreen.V92.User.User
    , signInState : SignInState
    , realname : String
    , username : String
    , email : String
    , password : String
    , passwordConfirmation : String
    , adminDisplay : AdminDisplay
    , backendModel : Maybe BackendModel
    , route : Evergreen.V92.Route.Route
    , message : String
    , weatherData : Maybe Evergreen.V92.Weather.WeatherData
    , inputCity : String
    , inputKey : String
    , inputValue : String
    , kvValue : String
    }


type FrontendModel
    = Loading LoadingModel
    | Loaded LoadedModel


type FrontendMsg
    = NoOp
    | UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Tick Time.Posix
    | GotWindowSize Int Int
    | PressedShowTooltip
    | MouseDown
    | BuyProduct (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId) (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.PriceId) Evergreen.V92.Stripe.Product.Product_
    | PressedSelectTicket (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId) (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.PriceId)
    | FormChanged Evergreen.V92.Stripe.PurchaseForm.PurchaseForm
    | PressedSubmitForm (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.ProductId) (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.PriceId)
    | PressedCancelForm
    | AskToRenewPrices
    | SignIn
    | SetSignInState SignInState
    | SubmitSignIn
    | SubmitSignOut
    | SubmitSignUp
    | InputRealname String
    | InputUsername String
    | InputEmail String
    | InputPassword String
    | InputPasswordConfirmation String
    | SetAdminDisplay AdminDisplay
    | SetViewport
    | CopyTextToClipboard String
    | Chirp
    | RequestWeatherData String
    | InputCity String
    | InputKey String
    | InputValue String
    | AddKeyValuePair String String
    | GetValueWithKey String
    | GotValue (Result Http.Error String)
    | DataUploaded (Result Http.Error ())


type ToBackend
    = SubmitFormRequest (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.PriceId) (Evergreen.V92.Untrusted.Untrusted Evergreen.V92.Stripe.PurchaseForm.PurchaseFormValidated)
    | CancelPurchaseRequest
    | AdminInspect (Maybe Evergreen.V92.User.User)
    | RenewPrices
    | SignInRequest String String
    | SignOutRequest String
    | SignUpRequest String String String String
    | GetWeatherData String


type BackendMsg
    = GotTime Time.Posix
    | GotAtmosphericRandomNumbers (Result Http.Error String)
    | GotPrices (Result Http.Error (List Evergreen.V92.Stripe.Stripe.PriceData))
    | GotPrices2 Lamdera.ClientId (Result Http.Error (List Evergreen.V92.Stripe.Stripe.PriceData))
    | OnConnected Lamdera.SessionId Lamdera.ClientId
    | CreatedCheckoutSession Lamdera.SessionId Lamdera.ClientId (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.PriceId) Evergreen.V92.Stripe.PurchaseForm.PurchaseFormValidated (Result Http.Error ( Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.StripeSessionId, Time.Posix ))
    | ExpiredStripeSession (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.StripeSessionId) (Result Http.Error ())
    | ConfirmationEmailSent (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.StripeSessionId) (Result Http.Error Evergreen.V92.Postmark.PostmarkSendResponse)
    | ErrorEmailSent (Result Http.Error Evergreen.V92.Postmark.PostmarkSendResponse)
    | GotWeatherData Lamdera.ClientId (Result Http.Error Evergreen.V92.Weather.WeatherData)


type ToFrontend
    = InitData InitData2
    | GotMessage String
    | SubmitFormResponse (Result String (Evergreen.V92.Id.Id Evergreen.V92.Stripe.Stripe.StripeSessionId))
    | AdminInspectResponse BackendModel
    | UserSignedIn (Maybe Evergreen.V92.User.User)
    | ReceivedWeatherData (Result Http.Error Evergreen.V92.Weather.WeatherData)
