open Webapi.Dom

@scope("Document") @val external readyState: string = "readyState"

let ready = f => {
  if readyState != "loading" {
    f()
  } else {
    Document.addEventListener("DOMContentLoaded", _event => f(), document)
  }
}

let match = (~onReady=true, path, f) => {
  let pathFragments = Js.String2.split(path, "#")

  if pathFragments->Js.Array2.length != 2 {
    Js.Console.error(
      "[PSJ] Path must be of the format `controller#action` or `module/controller#action`. Received: " ++
      path,
    )
  } else {
    let metaTag = document |> Document.querySelector("meta[name='psj']")

    switch metaTag {
    | None => ()
    | Some(tag) =>
      let controller = Element.getAttribute("controller", tag)
      let action = Element.getAttribute("action", tag)

      switch (controller, action) {
      | (Some(controller), Some(action)) =>
        if controller == pathFragments[0] && action == pathFragments[1] {
          Js.log("[PSJ] Matched " ++ path)
          onReady ? ready(f) : f()
        }
      | (None, Some(_)) => Js.Console.error("[PSJ] Meta tag is missing the controller prop.")
      | (Some(_), None) => Js.Console.error("[PSJ] Meta tag is missing the action prop.")
      | (None, None) =>
        Js.Console.error("[PSJ] Meta tag is missing both the controller or action prop.")
      }
    }
  }
}

let matchPaths = (~onReady=true, paths, f) => {
  let _ = Js.Array2.some(paths, path => {
    let pathFragments = Js.String2.split(path, "/")
    let currentPathFragments = Location.pathname(location)->Js.String2.split("/")

    if Js.Array2.length(pathFragments) == Js.Array2.length(currentPathFragments) {
      let matched = Js.Array2.everyi(pathFragments, (fragment, index) => {
        if fragment == "*" || Js.String2.charAt(fragment, 0) == ":" {
          true
        } else if fragment == currentPathFragments[index] {
          true
        } else {
          false
        }
      })

      if matched {
        Js.log("[PSJ] Matched " ++ path)
        onReady ? ready(f) : f()
      }

      matched
    } else {
      false
    }
  })
}
