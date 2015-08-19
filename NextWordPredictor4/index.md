---
title       : Next Word Predictor
subtitle    : emphasizing the "artificial" and scandalizing the "intelligence" in A.I. 
author      : Lawrence Lau
job         : Use your keyboard's left and right arrows to navigate slides
logo        : 
framework   : io2012      # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax, quiz, bootstrap]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides

---

## What Is This App??

This app takes an user-input phrase (English only s'il vous plait) and predicts the next word. For example, given the phrase 

```r
"Beauty and the"
```

it will predict the next word, which most of us in the Western world would think is 


```r
"Beast"  
```

But how does it work, you ask?  Ah, here's how the magic happens.

An algorithm, (which I call Crooked Arrow), is exposed to and trained from a huge volume of written texts comprised of Tweets, blogs, and news articles in English.  Collectively, this group of texts is called the Corpus.  A small subset of the Corpus is set aside and used later to test the accuracy of Crooked Arrow. You don't want to include that subset in the algorithm's training subset otherwise the accuracy will show a confirmation bias that overstates the result.  

After the algorithm is honed, it's then included as part of the function that powers the app.  The function takes the user-input phrase, passes it through the algorithm, and then returns and displays the most likely next word.  

It sounds easy enough conceptually.  Let's take a deeper look at the actual algorithm.  

--- 

## The Algorithm (Crooked Arrow)

Crooked Arrow is inherently an n-gram based algorithm. That is, it breaks down the user-input phrase into trigrams (groups of three words) and searches the Corpus for quadgrams (groups of four words) that contain those trigrams.  It then ranks those matching quadgrams based on the number of times those quadgrams appear in the Corpus (the frequency).  Should there be no quadgrams found which contain those trigrams, then a Katz back-off model[*](https://en.wikipedia.org/wiki/Katz%27s_back-off_model) is used to find the most reliable result based on the Corpus. 

Even though the matching ngrams are ranked on frequency, it's not always quite as simple as taking the most frequently observed ngram and deciding the result is found within.  Why?  Well remember the Corpus that Crooked Arrow is trained on isn't a comprehensive collection of everything ever written in the English language. So the probabilities it calculates based on observed frequencies alone  won't take into account words not appearing in the Corpus. In creating the algorithm, I had to decide between several different methods of calculating and assigning the likeliest probability result.  The methods I considered were:

1.)  Maximum Likelihood Estimation [(MLE)](http://en.wikipedia.org/wiki/Maximum_likelihood) - calculates the result based on observed phenomena only. 

2.)  Simple Good-Turing [(SGT)](http://en.wikipedia.org/wiki/Good%E2%80%93Turing_frequency_estimation) - takes into account unseen observations.

3.)  Additive Smoothing [(or Laplace Smoothing)](https://en.wikipedia.org/wiki/Additive_smoothing) - takes into account unseen observations.  

From my research, Laplace Smoothing's smoothing process overcompensated for observations unknown and unseen when compared to Simple Good-Turing. Theoretically, SGT is the best method for statistically predicting the result.  However in my algorithm I actually use the MLE method-  in my tests, it ran incrementally faster, albeit ~3% less accurate.  Since I'm uploading the app to shinyapps.io I need the app to be as trim as it can be to give the user the best possible experience.  I opted to go with speed over accuracy.  To be honest, it's only incrementally faster, but because I designed the app to constantly run as the user generated input (instead of necessitating button pushes by the user after every input phrase) I need it to be as fast as possible otherwise the accrued lag would be an app killer. 

*Follow [the link](https://en.wikipedia.org/wiki/Katz%27s_back-off_model) for a more technical description of Katz's back-off model.  Basically the idea is it makes smaller ngrams until a reliable match is found.

---

## Further Details

- The first iteration of the app included a function which analyzed a phrase for misspelled words if the original input phrase returned no matches. (This function was also based on ngram combinations, but with letters instead of words.) However I decided not to include that functionf or the published version because it added considerable processing time, making the experience frustrating, and also because it wasn't that accurate.  

- I originally intended to not filter swear words from results.  But I found accuracy was higher and processing time lower with them filtered, so they're now filtered.  

- You'll recall I named the algorithm "Crooked Arrow". That's because like a crooked arrow, the algorithm actually isn't that accurate (it's about 20% accurate).  And the longer the phrase (or to go with the analogy, the longer the distance the arrow covers), the less accurate the result is. Accordingly, the first few words of a sentence or phrase construction are predicted more accurately than the last few.   

- If I had more processing power I would add the following features:  a larger training corpus set, a regionalized corpus training set based on the user's geographic information (you/ya'll/you guys etc), a dictionary and thesaurus based on word correlations and prepositions (for synonyms and antonyms), and a secondary "fail-safe" algorithm that identifies phrases with "significant" words (for example in the phrase "Very early observations on the Bills game: Offense still struggling but the", the significant words are "Bills", "game", "offense", "struggling", "but".)



--- 

## Use It!

The app's interface is easy enough to use.  Simply enter a phrase in the text box and click "THE BUTTON".  Once you click "THE BUTTON", the app will constantly run and update until you shut the window.  If after you click "THE BUTTON" you leave the text box completely blank, it will display an error in the result box but don't mind it, that will disappear once you populate the text box again.  

Without further ado, here's the app!

[Next Word Predictor](https://ll8054.shinyapps.io/NextWordPredictor4)

