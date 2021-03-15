// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml_array from "bs-platform/lib/es6/caml_array.js";

function make(title, author, text) {
  return {
          title: title,
          author: author,
          text: text
        };
}

function title(t) {
  return t.title;
}

function author(t) {
  return t.author;
}

function text(t) {
  return t.text;
}

var Post = {
  make: make,
  title: title,
  author: author,
  text: text
};

var posts = [
  {
    title: "The Razor's Edge",
    author: "W. Somerset Maugham",
    text: [
      "\"I couldn't go back now. I'm on the threshold. I see vast lands of the spirit stretching out before me,\n    beckoning, and I'm eager to travel them.\"",
      "\"What do you expect to find in them?\"",
      "\"The answers to my questions. I want to make up my mind whether God is or God is not. I want to find out why\n    evil exists. I want to know whether I have an immortal soul or whether when I die it's the end.\""
    ]
  },
  {
    title: "Ship of Destiny",
    author: "Robin Hobb",
    text: [
      "He suddenly recalled a callow boy telling his tutor that he dreaded the sea voyage home, because he would have\n        to be among common men rather than thoughtful acolytes like himself. What had he said to Berandol?",
      "\"Good enough men, but not like us.\"",
      "Then, he had despised the sort of life where simply getting from day to day prevented a man from ever taking\n        stock of himself. Berandol had hinted to him then that a time out in the world might change his image of folk\n        who labored every day for their bread. Had it? Or had it changed his image of acolytes who spent so much time in\n        self-examination that they never truly experienced life?"
    ]
  },
  {
    title: "A Guide for the Perplexed: Conversations with Paul Cronin",
    author: "Werner Herzog",
    text: ["Our culture today, especially television, infantilises us. The indignity of it kills our imagination. May I propose a Herzog dictum? Those who read own the world. Those who watch television lose it. Sitting at home on your own, in front of the screen, is a very different experience from being in the communal spaces of the world, those centres of collective dreaming. Television creates loneliness. This is why sitcoms have added laughter tracks which try to cheat you out of your solitude. Television is a reflection of the world in which we live, designed to appeal to the lowest common denominator. It kills spontaneous imagination and destroys our ability to entertain ourselves, painfully erasing our patience and sensitivity to significant detail."]
  }
];

function appendPosts(param) {
  var body = document.body;
  var numOfPosts = posts.length;
  for(var i = 0; i < numOfPosts; ++i){
    var postDiv = document.createElement("div");
    postDiv.setAttribute("id", "block-" + String(i));
    postDiv.setAttribute("class", "post");
    var h2 = document.createElement("h2");
    h2.setAttribute("class", "post-heading");
    h2.innerText = Caml_array.get(posts, i).title;
    postDiv.appendChild(h2);
    var h3 = document.createElement("h3");
    h3.innerText = Caml_array.get(posts, i).author;
    postDiv.appendChild(h3);
    var numOfLines = Caml_array.get(posts, i).text.length;
    for(var j = 0; j < numOfLines; ++j){
      var para = document.createElement("p");
      para.setAttribute("class", "post-text");
      para.innerText = Caml_array.get(Caml_array.get(posts, i).text, j);
      postDiv.appendChild(para);
    }
    var removeBtn = document.createElement("button");
    removeBtn.setAttribute("id", "block-delete-" + String(i));
    removeBtn.setAttribute("class", "button button-danger");
    removeBtn.innerText = "Remove this post";
    postDiv.appendChild(removeBtn);
    body.appendChild(postDiv);
  }
  
}

appendPosts(undefined);

export {
  Post ,
  posts ,
  appendPosts ,
  
}
/*  Not a pure module */
