@val external document: {..} = "document"
@val external window: {..} = "window"
@val external event: {..} = "event"
@bs.val external setTimeout: (unit => unit, int) => int = "setTimeout"
@bs.val external clearTimeout: int => unit = "clearTimeout"

module Post = {
  type t = {
    title: string,
    author: string,
    text: array<string>,
  }

  let make = (~title, ~author, ~text) => {title: title, author: author, text: text}
  let title = t => t.title
  let author = t => t.author
  let text = t => t.text
}

let posts = [
  Post.make(
    ~title="The Razor's Edge",
    ~author="W. Somerset Maugham",
    ~text=[
      "\"I couldn't go back now. I'm on the threshold. I see vast lands of the spirit stretching out before me,
    beckoning, and I'm eager to travel them.\"",
      "\"What do you expect to find in them?\"",
      "\"The answers to my questions. I want to make up my mind whether God is or God is not. I want to find out why
    evil exists. I want to know whether I have an immortal soul or whether when I die it's the end.\"",
    ],
  ),
  Post.make(
    ~title="Ship of Destiny",
    ~author="Robin Hobb",
    ~text=[
      "He suddenly recalled a callow boy telling his tutor that he dreaded the sea voyage home, because he would have
        to be among common men rather than thoughtful acolytes like himself. What had he said to Berandol?",
      "\"Good enough men, but not like us.\"",
      "Then, he had despised the sort of life where simply getting from day to day prevented a man from ever taking
        stock of himself. Berandol had hinted to him then that a time out in the world might change his image of folk
        who labored every day for their bread. Had it? Or had it changed his image of acolytes who spent so much time in
        self-examination that they never truly experienced life?",
    ],
  ),
  Post.make(
    ~title="A Guide for the Perplexed: Conversations with Paul Cronin",
    ~author="Werner Herzog",
    ~text=[
      "Our culture today, especially television, infantilises us. The indignity of it kills our imagination. May I propose a Herzog dictum? Those who read own the world. Those who watch television lose it. Sitting at home on your own, in front of the screen, is a very different experience from being in the communal spaces of the world, those centres of collective dreaming. Television creates loneliness. This is why sitcoms have added laughter tracks which try to cheat you out of your solitude. Television is a reflection of the world in which we live, designed to appeal to the lowest common denominator. It kills spontaneous imagination and destroys our ability to entertain ourselves, painfully erasing our patience and sensitivity to significant detail.",
    ],
  ),
]

let returnInt = (x) => {
  switch (x) {
  | Some (y) => y
  | None => -1
  }
}

let getIdFromEvent = (event) => {
  let postStringId = event["target"]["id"]
  let stringSize = Js.String.length(postStringId)
  let lastChar = Js.String.charAt(stringSize-1, postStringId)
  returnInt(Belt.Int.fromString(lastChar))
}

let removeDialogBox = (event) => {
  let postId = getIdFromEvent(event)
  let reservePost = document["getElementById"](`block-delete-dialog-${Belt.Int.toString(postId)}`)
  let _ = reservePost["remove"]()
}

let removePostById = (event, timerId) => {
  if timerId != -1 {
    clearTimeout(timerId)
  }
  let postId = getIdFromEvent(event)
  let reservePost = document["getElementById"](`block-${Belt.Int.toString(postId)}`)
  let _ = reservePost["remove"]()
  let _ = removeDialogBox(event)
}

let restore = (event, timerId) => {
  if timerId != -1 {
    clearTimeout(timerId)
  }
  let _ = removeDialogBox(event)
  let postId = getIdFromEvent(event)
  let reservePost = document["getElementById"](`block-${Belt.Int.toString(postId)}`)
  reservePost["style"]["display"] = "block"
}

let hide = (event) => {
  let postId = getIdFromEvent(event)
  let reservePost = document["getElementById"](`block-${Belt.Int.toString(postId)}`)
  reservePost["style"]["display"] = "none"
}

let startRemovalTimer = (event) => {
  let timerId = setTimeout(() => removePostById(event, -1), 10000)
  let postId = getIdFromEvent(event)
  hide(event)

  let body = document["body"]

  let removePost = document["createElement"]("div")
  let _ = removePost["setAttribute"]("class", "post-deleted pt-1")
  let _ = removePost["setAttribute"]("id", `block-delete-dialog-${Belt.Int.toString(postId)}`)

    let para = document["createElement"]("p")
    let _ = para["setAttribute"]("class", "text-center")
    para["innerText"] = "This post from "

      let em = document["createElement"]("em")
      em["innerText"] = `${posts[postId].title} from ${posts[postId].author}`
      let _ = removePost["appendChild"](para)
      let _ = para["appendChild"](em)

    let text = document["createTextNode"](" will be permanently removed in 10 seconds.");
    let _ = para["appendChild"](text)

    let flexDiv = document["createElement"]("div")
    let _ = flexDiv["setAttribute"]("class", "flex-center")
    let _ = removePost["appendChild"](flexDiv)

    let restoreButton = document["createElement"]("button")
    let _ = restoreButton["setAttribute"]("id", `block-restore-${Belt.Int.toString(postId)}`)
    let _ = restoreButton["setAttribute"]("class", "button button-warning mr-1")
    restoreButton["innerText"] = "Restore"

    let evtHandlerRestore = (event) => {
      restore(event, timerId)
    }

    let _ = restoreButton["addEventListener"]("click", evtHandlerRestore)
    let _ = flexDiv["appendChild"](restoreButton)

    let deleteNow = document["createElement"]("button")
    let _ = deleteNow["setAttribute"]("id", `block-delete-immediate-${Belt.Int.toString(postId)}`)
    let _ = deleteNow["setAttribute"]("class", "button button-danger")
    deleteNow["innerText"] = "Delete Immediately"

    let evtHandlerRemoval = (event) => {
      removePostById(event, timerId)
    }
    let _ = deleteNow["addEventListener"]("click", evtHandlerRemoval, timerId)
    let _ = flexDiv["appendChild"](deleteNow)

    let progressBar = document["createElement"]("div")
    let _ = progressBar["setAttribute"]("class", "post-deleted-progress")
    let _ = removePost["appendChild"](progressBar)

  let afterBlockId = postId+1;
  let afterBlockNode = document["getElementById"](`block-${Belt.Int.toString(afterBlockId)}`)
  let _ = body["insertBefore"](removePost, afterBlockNode)
}

let appendPosts: unit => unit = () => {
  let body = document["body"]
  let numOfPosts = Js.Array.length(posts)
  for i in 0 to numOfPosts - 1 {

    let postDiv = document["createElement"]("div")
    let _ = postDiv["setAttribute"]("id", `block-${Belt.Int.toString(i)}`)
    let _ = postDiv["setAttribute"]("class", "post")

    let h2 = document["createElement"]("h2")
    let _ = h2["setAttribute"]("class", "post-heading")
    h2["innerText"] = posts[i].title
    let _ = postDiv["appendChild"](h2)

    let h3 = document["createElement"]("h3")
    h3["innerText"] = posts[i].author
    let _ = postDiv["appendChild"](h3)

    let numOfLines = Js.Array.length(posts[i].text)
    for j in 0 to numOfLines-1 {
      let para = document["createElement"]("p")
      let _ = para["setAttribute"]("class", "post-text")
      para["innerText"] = posts[i].text[j]
      let _ = postDiv["appendChild"](para)
    }

    let removeBtn = document["createElement"]("button")
    let _ = removeBtn["setAttribute"]("id", `block-delete-${Belt.Int.toString(i)}`)
    let _ = removeBtn["setAttribute"]("class", "button button-danger")
    removeBtn["innerText"] = "Remove this post"
    let _ = removeBtn["addEventListener"]("click", startRemovalTimer)
    let _ = postDiv["appendChild"](removeBtn)

    let _ = body["appendChild"](postDiv)
  }
}

appendPosts()