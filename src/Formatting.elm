module Formatting exposing (ordinalIndicator)


ordinalIndicator i =
    let
        i100 =
            i |> remainderBy 100

        i10 =
            i |> remainderBy 10
    in
    if 10 <= i100 && i100 <= 20 then
        "th"

    else
        case remainderBy 10 i of
            1 ->
                "st"

            2 ->
                "nd"

            3 ->
                "rd"

            _ ->
                "th"
