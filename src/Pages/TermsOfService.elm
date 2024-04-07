module Pages.TermsOfService exposing (view)

import Element exposing (Element)
import Element.Font
import Html.Attributes
import MarkdownThemed
import Types


view : Types.LoadedModel -> Element Types.FrontendMsg
view model =
    Element.text "Terms of Service"
