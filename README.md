[![CodeFactor](https://www.codefactor.io/repository/github/antonvasilev52/oxford_3000/badge)](https://www.codefactor.io/repository/github/antonvasilev52/oxford_3000)


# Oxford 3000 

Welcome to the home repository of Oxford 3000, a very basic, [Sinatra](http://sinatrarb.com)-based, quiz app.  
The app tests out your knowledge of 3000 most important words to learn in English, also known as [Oxford 3000](https://www.oxfordlearnersdictionaries.com/about/oxford3000). I took the definitions from the Merriam-Webster dictionary and thesaurus.

## How-to

1. Clone the repository.
2. Run:
    ```
    ruby main.rb
    ```
    This will start the Sinatra web server. The app will be availabe on http://127.0.0.1:4567
3. Go to http://127.0.0.1:4567 and enjoy the quiz :blush:

A live example is available ~~https://oxford3000.herokuapp.com~~ https://oxford3000.onrender.com/quiz
It was really sad to move leave Heroku. I really liked Heroku because of how well their site and docs are organized.
Moreover, Matz (Yukihiro Matsumoto, the founder of Ruby) worked there. But after their new paid model, I said to myself this project is too simple to pay for it. The good news is that Render is really cool and super easy to deploy. Would recommend it to my friends.

:warning: If you want to use the **Feedback** widget for sending emails from users, you have to configure your own SMTP server. Put your STMP credentials in the `Pony.mail` method but DO NOT expose the API key password in a plain form. Bad guys can rapidly disclose it and use for sending email spam.  
What you can do is:
Export your API key passowrd as an environment variable, for example:
    ```
  export EMAILAPI=<your passowrd>
    ```
Use it in Pony: `:password => ENV['EMAILAPI']`

## Credits
The Oxford_3000 app uses:  
 :microphone: Web framework: Sinatra 2.1.0  
 :tiger2: Web server: Puma 5.3.2 ("Sweetnighter")  
 :books: Definitions from Merriam-Webster's Collegiate® Dictionary and Merriam-Webster's Collegiate® Thesaurus using [Merriam-Webster API](https://dictionaryapi.com/products/index)  
 :rocket: Deployment platform: [Heroku](http://heroku.com)  
 :art: Background image: a photo from [Unsplash](https://unsplash.com/photos/tk9RQCq5eQo) by Kelly Sikkema  
:gem: IDE: CotEditor and RubyMine (many thanks to JetBrains fro their [open source license](https://www.jetbrains.com/community/opensource/#support)).  
:incoming_envelope: Email solution for feedback: [Pony](https://github.com/benprew/pony) + an SMTP server (such as [SendGrid](https://sendgrid.com) or [Sendinblue](https://www.sendinblue.com)).
