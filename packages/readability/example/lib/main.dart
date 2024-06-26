import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:readability/readability.dart';

void main() {
  runApp(const ReadabilityExample());
}

class ReadabilityExample extends StatefulWidget {
  const ReadabilityExample({super.key});

  @override
  State<ReadabilityExample> createState() => _ReadabilityExampleState();
}

class _ReadabilityExampleState extends State<ReadabilityExample> {
  String sylablesCount = '';
  String? score;
  Duration x = Duration.zero;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 100),
            TextField(
              onChanged: (value) async {
                // sylablesCount = await countSyllables(text: value);
                final timer = Stopwatch()..start();
                final instance =
                    await Readability.getInstance(Language.english);
                log("started");
                try {
                  final scoree =
                      (await instance.calculateScore(txt + txt + txt + txt));
                  log(scoree.rawMetrics.sentencesCount.toString());
                  score = scoree.toString();
                  x = timer.elapsed;
                } catch (e) {
                  score = e.toString();
                }
                log("lasted ${timer.elapsedMilliseconds}");
                setState(() {});
              },
            ),
            const SizedBox(height: 100),
            Text(score ?? '0'),
            Text(x.inMilliseconds.toString()),
          ],
        ),
      ),
    );
  }
}

const String txt =
    "hey guys welcome back to lingo Marina a channel where I share my journey of learning English with you and today we're going to talk about pronunciation something that has been evolving like crazy just take a quick look at a video that I made seven years ago and this was a great experience for me because I wanted to enter United States universities and many of them required around 100 or around 90. so I was well above the grade I needed oh my God who is that person why does she sound like a different person and this is what's going to happen to you when you embark on a journey of improving your pronunciation and the thing is if you start living in an English-speaking environment after you're 25 which in my case was the case I moved to the us at the age of 25. I am 100 sure that even in 40 years I will still sound a little bit Russian because if you are seven and you move to a new country your accent goes away because this is how a brain works there is more plasticity when you're 25 you have your whole history in another country you know you work on your accent and yes you see it improves like compare me right now to Marina from 2016. two different people right so I hope this encourages you to work on your pronunciation we're going to talk about some things that you can improve right now but believe me it's a never-ending process and this is why I love it I honestly enjoy my constant progress and most of all I enjoy sharing it with you so let's talk about some things that you could take away with you after watching this video now let's start with my favorite V sound versus sound in some languages like mine Russian there is no sound so when somebody tries to mimic Russian accent I will call you very soon see what I'm doing I'm not saying well I will call you wait for it see when I try to do my full Russian accent I actually replace and this is what I used to do 10 years ago 20 years ago five years ago it still slips sometimes the thing is there is a very clear difference between these two sounds let's compare went vent like one sound changes the whole meaning of the word my monkey took that paintbrush and then went into that vent Wayne vain see different words yeah there's also a polite less vain way to say thank you when someone compliments your film of course when you talk to a native speaker and they hear the whole context they're not gonna tell you like oh my God what did you mean there I didn't understand this word of course they're gonna understand it's just the way you get over this is you start paying attention ideally you start recording yourself and re-watching your videos because when we're talking we sometimes miss things so what really helps me is we're watching my older videos but anyways let's practice together water do you want some some water or some tea without warning no but event ventilator very egg I am sure you are a very vibrant and dynamic lover when you want to be so the way to do it exaggerate it whenever you are doing something for yourself talking to yourself talking to your phone talking to your camera exaggerate this way you will activate your muscle memory and it's going to be easier for you now I started singing and uh when we sing my vocal coach asks me to exaggerate things all the time because this way this is how we work on my rhythm he asks me to sing a song 2x faster so that it's easier for me to catch the beat when we switch the normal speed on right so my tip here exaggerate very weight water will vary wait and like practice and practice and practice practice makes perfect pronunciation really depends on your mother tongue and your teacher one of my key teachers was my friend venipak he still teaches me all the time he still helps me with my pronunciation and I can say that he's one of the most inspiring teachers in the world because he came to the us at the age of 20 and now he's on American radio he's singing in English his accent for me like I can't even tell that he's a non-native speaker he might have a slight accent but I can't even tell right and for me he's a huge inspiration and he makes me believe that everything is possible my company lingua trip partnered with benia and several native speakers to help you improve your pronunciation as we know the best way to improve your English and pronunciation is to immerse yourself in an English-speaking environment which is not always possible right but we tried to create a similar experience for you at lingua school which is our new product so when you start studying there we assess your pronunciation and based on that we create a study plan for you where you're in a act with a native speaking teacher twice a week and get feedback on your accent and pronunciation in these classes you get your homework and you get feedback from your Mentor regarding how your pronunciation is improving and what's happening to it also there is a speaking club that you can attend to immerse yourself in the English-speaking environment and surround yourself by like-minded people who are learning how to sound more American and of course you can choose whatever accent you want to choose and uh an America is a country of immigrants there is so many accents here and so many dialect which is amazing and I want you to choose who you want to sound like what you want to sound like and start that Journey now check out the link down below join our International Community of students surround yourself by like-minded people meet people from all over the world practice English with fellow students and native speaking teachers join lingua school and surround yourself with English the link is in the description okay the next sound that is super confusing because like double O okay I know the word food and we pronounce it as Ooh food so why not pronounce it the same way in every single word well no no no this is not how English works and let me tell you a story I'm all about storytelling so 2015 uh I am pitching lingua trip to investors our company and my presentation starts with a phrase where I communicate that you do not learn a language just by reading a book A book but by traveling right by immersing yourself into it but I said a book book the way I would say food longer ooh and uh one of the guys who was helping me with the pitch he never corrected me but he started saying this phrase over and over again just to um help me with pacing Etc and I started noticing that he pronounced book in a completely different way he said book and he had this I think he's from California so he said it really distinctively and I started thinking okay now how do I know when it's a book and not a book well you just learn it so this is what I'm gonna tell you um double O can be pronounced in several ways food Moon you say ooh right or grooming Loop boom now just Loop it around but instead of pulling it tight thread the needle through the loop and then you're done because there's no actual food on this menu let's go these words you say and I like I always ask quora quora is by the way one of the best websites if you have any questions regarding pronunciation you just go there there's a question why do we say food but we say foot like a completely different sound why is it that way and basically the answer is because because this is the way English language works so now let's look at another set of words book cook look so it's not look it's look exaggerated again that's the only way I started saying buck buck to learn it because I wanted to sound more American during my presentation so I was exaggerating it all the time my husband was laughing at me look not book book what children's books no not children's books real books Good Foot listen I took care of the docket but I'd appreciate it if you keep me in the loop when you have outside commitments now of course that's not it English has more surprises for you there is uh there is a word flood where a double O is suddenly a flood and it can go on and on with double o's because there are also words like door and floor Etc but what I really wanted you to catch here is what I caught back in 2015 that it's not a book it's a book if you have any questions about how to pronounce a word my go-to strategies I Google it flood pronunciation and I repeat after Google or I watch a YouTube video welcome to learning English alright thank you guys so much for watching this video up to the very end I have a question for you what are you struggling to pronounce which words are the hardest for you to pronounce comment down below I am looking forward to reading your comments and of course share this video subscribe this Channel and I'll see you very soon in my next videos thank you so";
