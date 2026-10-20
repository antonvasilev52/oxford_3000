[![CodeFactor](https://www.codefactor.io/repository/github/antonvasilev52/oxford_3000/badge)](https://www.codefactor.io/repository/github/antonvasilev52/oxford_3000)

![GitHub code size](https://img.shields.io/github/languages/code-size/antonvasilev52/oxford_3000?style=plastic&logo=ruby&logoColor=red&labelColor=white&color=green)


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

:warning: The **Feedback** widget sends emails through the [Brevo HTTP API](https://developers.brevo.com/reference/send-transational-emails) (port 443), not SMTP — Render's free plan blocks outbound SMTP ports (25/465/587). To enable it, create a restricted Brevo API key (*Transactional email: All*) and export it:
    ```
  export BREVO_API_KEY=<your api key>
    ```
Set the same variable in your host's dashboard (on Render: *Service → Environment*). Never commit the key to git.

## Credits
The Oxford_3000 app uses:  
 :microphone: Web framework: Sinatra 2.1.0  
 :tiger2: Web server: Puma 5.3.2 ("Sweetnighter")  
 :books: Definitions from Merriam-Webster's Collegiate® Dictionary and Merriam-Webster's Collegiate® Thesaurus using [Merriam-Webster API](https://dictionaryapi.com/products/index)  
 :rocket: Deployment platform: [Render](https://render.com)  
 :art: Background image: a photo from [Unsplash](https://unsplash.com/photos/tk9RQCq5eQo) by Kelly Sikkema  
:gem: IDE: CotEditor and RubyMine (many thanks to JetBrains fro their [open source license](https://www.jetbrains.com/community/opensource/#support)).  
:incoming_envelope: Email solution for feedback: [Brevo](https://www.brevo.com/) transactional email API (HTTPS), formerly Sendinblue.
