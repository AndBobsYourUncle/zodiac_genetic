## Zodiac z340 Genetic Algorithm

I mainly just made this for fun, as it is most definitely taking a more straightforward, naive approach to using a genetic algorithm to solve the cypher.

It first gathers the list of cypher characters, and the top words from all of the Zodiac letters.

The fitness for each organism is calculated by the number of words from that word list that are present when decoded using the organism's key. Words that are less frequent are given a higher fitness value. If the count of a particular word exceeds a threshold, then the threshold is used for the calculation. This is to prevent the genetic algorithm from breeding an organism that deciphers the code with just a ton of the same word.

Breeding pairs are selected by taking the one's that exceed the breeding fitness level, and randomly separating them into pairs.

Organisms then breed by combining half of each one's key, and then randomly mutating some values.

The population is culled if it exceeds the overpopulation threshold by removing the least fit.

Organisms that do not exceed the unfit level also die off.

It obviously doesn't work that well, but it was fun trying to implement something like this.

There is obviously some work that could be done in factoring in gramatical rules when determining the fitness level, etc.

## Running It

Just clone and run `ruby cypher.rb`. I coded this with Ruby 2.5.1. If you run `ruby -v` and get something lower, I'd recommend installing RVM and using it to install the latest Ruby version.
