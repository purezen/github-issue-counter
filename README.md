# Github Issue Counter

This is a web application made using the Ruby on Rails framework.

It has a running instance at [https://github-issue-counter.herokuapp.com](https://github-issue-counter.herokuapp.com)

Github provides an API for developers to make brief interactions with the platform. They also provide a gem named Octokit [[link]](octokit.github.io) to enable that functionality using Ruby.
This app makes use of the Octokit gem to retrieve the open issues from Github and sorts them according to when they were opened.

Given more time, I would have implemented some operations using AJAX for seamless user experience. I would have also attempted to optimize the part of the app which performs the retrieval of information from the github link by caching etc.
