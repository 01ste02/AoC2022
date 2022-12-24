
# AoC2022
I am doing AdventOfCode 2022, and trying to stick with bash for as long as possible. ~~As of writing this (Day 4), I have not had any days have a runtime of over 30ms - if you exclude time for debug printing to stdin.~~ This was true until day 8 where I got execution times of 30 to 50 seconds. While they could have been reduced to probably 15 and 30, I think I might have found a limitation of single-threaded bash..

As a backup-language I am thinking python. But I will probably stick to bash.

I realized that my commit-messages are a bit of a comedy show around day 6, so they will be appended below every day for your entertainment (although I do not know who would really care enough to look at this repo except for fnurkla and Bäcker so far..):

 * AOC day one, sorted stars. Will Advent of Bash be a thing? ~ *Oh, how naive I was.. It will definetly be a thing. A slow and torturous thing.*
 * Day 2. Still advent of bash - and apparantly there is a difference between the win-order of Sten Sax Påse and Rock Paper Scissors... Who knew..? ~ *Still adjusting to the 5:45 wakeup-time.. Languages and translations of things that are automatic are not so simple at 6AM apparently..*
 * Advent of bash going strong. Not much to say today other than garbage in = garbage out ~ *Ah, the first REAL round of parsing...*
 * Day 4: Still Advent of Bash, went smoothly. Interesting to create ranges from limits and then try to iterate over arrays and find matches - easier in bash than I imagined ~ *Not much to say, but iterating over arrays is still interesting. And SLOW.*
 * Day5: Advent of Bash is getting hard. This problem could have been solved MUCH quicker by any list class, but the lists in bash lack methods for operations on elements. So I basically made it. First with sed - which was buggy since crates were not unique and sed removed all crates with a specific insignia. Then I made it with bash comprehensions - MUCH faster and easier to understand. Also solves the bugs with sed. ~ *Another visit from naive me.. That was not really hard. Although a list with take-operations would be nice. Also, I hate sed. Hate it, and the people who can write it from memory. But I can write most sed-queries from memory due to using it so much at work - this day I did not have to look up the correct syntax even. So I might hate myself (?)...*
 * Day 6. Advent of Bash much easier than yesterday... Turns out that bash is really good at sliding-window iterations and comparisons. Quite quick and effective still... ~ *Ah, how happy I was. The sliding-windows were fun and fast though*
 * Day 7. Advent of Bash going strong - but I will start slipping down from place 12 now. It took me 20 minutes to sort and find the smallest directory needed. Bash has limitations in places I do not like to admit, but it works. I'll be damned if it doesn't work. It still feels like a good idea and experience to write these challenges in bash - even though the language is not really made for it - but the portability of it is amazing. No compiler to install, and can run on most systems by default. I believe that all my solutions so far would be sh-compatible as well.. ~ *Starting to get stubborn. Stupid, but quite good sometimes IMO. Had an argument with people over why bash is the best. I **definitely** won that fight.*
 * Day 8. This day took a while. Not to code, but to execute. Part one took about 30 seconds, with 5 or 10 of them to print progress to stdout. Part 2 took about 50 seconds with the same print times. This sollution was probably horribly inefficient, but was the best I could come up with given the limitations of bash. It would probably be more efficient to build anouther array with the forest rotated 90 degrees for doing top and bottom lookups. This could at least save a lot of time in part 2. ~ ~~*Will update this comment tomorrow, I am currently too mad that I did not think of rotating the forest 90 degrees instead of basically doing it lots of times for every tree I wanted to check visibility for*~~ *Day 8 was intersting. I could improve upon my solutions a lot. And the lack of sleep is getting to me (do not stay up until 2 AM and then try to do AoC at 5:45 every day for 8 days, kids..), but as long as I learned something it is OK. (right?) Right?! RIGHT?!?! Totally worth it...*
 * Day 9. Bash. No sleep. Fell asleep between the parts... ~ *Interesting day. Since I do not modify my code AT ALL after getting the star, the first code is a miracle that it works. Stupid me missunderstood how the tail moves relative the body - and set it to move to the coords that the head last had before the distance between the two grew too large. This works for part one, but not part two. In part two, I spent a lot of time on debugging this. And fell asleep - I was working on a backup mailserver all night long for a critical system that might go down as my part of Sweden faces the risk of rolling blackouts right now. When I woke up, I made a new method that moved correctly - but it is UGLY. As a part of my debugging, I rendered each updated frame of the movement process. This is SLOW. Whilst being really late for work, I let the script run for 20 minutes and did not get a complete answer. Then I stopped it and remembered to remove my rendering, after which I got a sollution in 5 seconds (with some debug printing, but no rendering). I should really just never print anything. I hate printing delays. This was the worst day in a LONG time for me......*
 * Day 10. Advent of Bash STRONK!! I made it! This day was quite quick and easy, but still fun. I dabbled in a better way of drawing in the terminal - one where I can actually replace characters instead of redrawing everything for every frame. ~ *Really, really happy right now. I made a bet with some people that I would last until at least day 10 with Bash - and I completed that now. It has been significantly easier than I thought, and a lot more fun than I could have imagined. Amazing day to complete my Bash bet on, and now I am publicly vowing to do at least day 20 in Bash. No force pushes here... No... No... I also climbed to 7th place at Dsek AoC :)*
 * Day 11. Advent of bash is working, but slow. Interesting to handle such large numbers, and modulo might be the way to go. The slowness of bash loops and array access is getting to me. But the worst part it the time it takes to spawn subprocesses, for example sed. ~ *Really fun day, but I had to sit and wait a whole lot. Slowly starting to regret my promise yesterday, because if the rest is going to be this hard to complete quickly.. It took about 5 minutes for part 2 to run, and that is after I optimized it as far as I could think of. Seems like I will be spending a lot of time just staring at the console...*
 * Day 12. Advent of bash is getting slow - if you are stupid. My first solution managed to solve part 1, but was horribly slow for part 2. I basically made my own algorithm. Then I implemented BFS since that is apparantly good (haha).. BFS took 20 seconds for part 1, and then for part 2 I created a nice little bug. I did a BFS for each starting point. 20 seconds times about 688 starting points quickly becomes 3 hours of execution time. Then I did a BFS with multiple starting points and solved it in 24 seconds. ~ *The first real algorithm was fun, but bash really shows how slow it is to allocate memory. When doing BFS, the debug printouts really slowed down when I reached a point that had not visited before. But when I found a point I had already visited, and the parent array was allocated, it REALLY sped up. For future days I will have to remember to use actual algorithms, and look up how to malloc in bash...... Otherwise I might slip from 6th place and have to wait for hours for my scripts to run... Hope it is possible to malloc...*
 * Day 13. Advent of bash failed today. Multi-dimensional arrays in bash are possible. The best solution that I came up with made a 2-dimensional array. This needs more (or at least more levels of nesting). 3 hours spent trying (I left my failed attempts in here). Python was used, and took about 30 minutes. ~ *Spent about 5 hours on building arrays and trying to make it fit with bash, but nested arrays to an infinite level is just not practical nor is it possible in bash without building extra packages. Advent of bash has been broken after 12 days - and I am incredibly sad about it. I will try with bash tomorrow again, but after that it is python again - and I will give up easier now. It was fun while it lasted at least. :(*
 * Day 14. Advent of bash is back, but I highly suspect it will last until tomorrow. Tried a crude malloc today, and it seemed to speed up execution. This could be optimized a bit if we skipped the malloc and rendering if-statements. Fun day, I liked this sim. ~ *A false sense of security instills itself upon the ash-covered landscape of Advent of Bash. Now it seems that the hellfire in the sky, that started yesterday, has gone out completely. Or is it just covered by the black smoke? This day seems like it was easier than the last for a reason, a pattern that I have seen before in AoC. Tomorrow might just be hellish, and the dear Eric Wastl might just be trying to keep users here by having us ride this emotional rollercoaster instead of having us riding a emotional freefall and walking off after...*
 * Day 15. Rewritten solution, I have a few files in here.. Tried in bash first, then once in python that was horribly slow. The next try was a better one in python. ~ *AdventOfCode is really fun.. When you can remember it. I was sick here, and had trouble understanding the problem and how to solve it. Starting to get a fever..*
 * Day 16. Same
 * Day 17. Same tbh
 * Day 18. Embarrassing, but same
 * Day 19. Python only, RIP Advent of Bash. Being sick delays you, and my solutions for the uncommitted days are too trashy to commit. They are basically hard-coded bruteforces. Will fix and push later. ~*This day was not too hard, but it was a bit difficult to get back into not just throwing the problems at lots of cores after being sick and doing just that. Advent of Code is really fun, and offers so many different ways of creating solutions as I've just shown through messing up big time with day 15-18...*
 * Day 20. Python is better than I thought. I did go through 8 iterations of code, but it works! No more building around limitations of my language - Python has it all! ~ *Oh, how wonderful it is to work in a language that actually is made for what I am doing. No more loops that take 2s in Python and 30+ in bash... How I loved doing things in bash, because of the novelty of it, but now it is fun on a whole different level. Today could have been solved in bash though... Hmmmmm..... Is The Return of Bash imminent?*
 * Day 21. Could have been quicker, but used an interesting package for solving symbolic equations. Could probably have written an interpreter to inverse the expression and calculate it myself, but oh well.. I am really happy that I have stuck with AoC for so long, these challenges are quite fun. I may not be the quickest, but I sure do learn a lot. I did 13 days in bash, and that is quite something. The rest (especially today) could have been solved with bash, but once it is dead, it is dead. ~ *I cannot believe that it is almost over. Just a few more days left before I no longer have a code-challenge every morning. No more alarm at 5:45. I can sleep! Yay! Or, I should really be sad. Am I? Or am I just tired?*
