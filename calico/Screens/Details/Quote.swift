//
//  Quote.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation

struct Quote {
    let title: String
    let author: String
    
    static var randomQuote: Quote? {
        let quotes: [Quote] = [
            Quote(
                title: "In ancient times cats were worshipped as gods; they have not forgotten this.",
                author: "Terry Pratchett"
            ),
            Quote(
                title: "I had been told that the training procedure with cats was difficult. It’s not. Mine had me trained in two days.",
                author: "Bill Dana"
            ),
            Quote(
                title: "Cats are inquisitive, but hate to admit it.",
                author: "Mason Cooley"
            ),
            Quote(
                title: "As anyone who has ever been around a cat for any length of time well knows, cats have enormous patience with the limitations of the humankind.",
                author: "Cleveland Amory"
            ),
            Quote(
                title: "I have studied many philosophers and many cats. The wisdom of cats is infinitely superior.",
                author: "Hippolyte Taine"
            ),
            Quote(
                title: "There are two means of refuge from the miseries of life: music and cats.",
                author: "Albert Schweitzer"
            ),
            Quote(
                title: "A happy arrangement: many people prefer cats to other people, and many cats prefer people to other cats.",
                author: "Mason Cooley"
            ),
            Quote(
                title: "It is impossible for a lover of cats to banish these alert, gentle, and discriminating friends, who give us just enough of their regard and complaisance to make us hunger for more.",
                author: "Agnes Repplier"
            ),
            Quote(
                title: "I used to love dogs until I discovered cats.",
                author: "Nafisa Joseph"
            ),
            Quote(
                title: "Cats are connoisseurs of comfort.",
                author: "James Herriot"
            ),
            Quote(
                title: "Just watching my cats can make me happy.",
                author: "Paula Cole"
            ),
            Quote(
                title: "I’m not sure why I like cats so much. I mean, they’re really cute obviously. They are both wild and domestic at the same time.",
                author: "Michael Showalter"
            ),
            Quote(
                title: "You can not look at a sleeping cat and feel tense.",
                author: "Jane Pauley"
            ),
            Quote(
                title: "The phrase ‘domestic cat’ is an oxymoron.",
                author: "George Will"
            ),
            Quote(
                title: "One cat just leads to another.",
                author: "Ernest Hemingway"
            ),
            Quote(
                title: "I love cats because I enjoy my home; and little by little, they become its visible soul.",
                author: "Jean Cocteau"
            ),
            Quote(
                title: "I have felt cats rubbing their faces against mine and touching my cheek with claws carefully sheathed. These things, to me, are expressions of love.",
                author: "James Herriot"
            ),
            Quote(
                title: "I love my cats more than I love most people. Probably more than is healthy.",
                author: "Amy Lee"
            ),
            Quote(
                title: "Every cat is my best friend.",
                author: "Unknown"
            ),
            Quote(
                title: "All you need is love and a cat.",
                author: "Unknown"
            ),
            Quote(
                title: "What greater gift than the love of a cat?",
                author: "Unknown"
            ),
            Quote(
                title: "No matter how much cats fight, there always seem to be plenty of kittens.",
                author: "Abraham Lincoln"
            ),
            Quote(
                title: "The smallest feline is a masterpiece.",
                author: "Leonardo da Vinci"
            ),
            Quote(
                title: "Kittens are angels with whiskers.",
                author: "Alexis Flora Hope"
            ),
            Quote(
                title: "A kitten is in the animal world what a rosebud is in the garden.",
                author: "Robert Southey"
            ),
            Quote(
                title: "A kitten is the delight of a household. All day long a comedy is played out by an incomparable actor.",
                author: "Champfleury"
            ),
            Quote(
                title: "Time spent with cats is never wasted.",
                author: "Sigmund Freud"
            ),
            Quote(
                title: "Cats rule the world.",
                author: "Jim Davis"
            ),
            Quote(
                title: "Like all pure creatures, cats are practical.",
                author: "William S. Burroughs"
            ),
            Quote(
                title: "Cats choose us; we don’t own them.",
                author: "Kristin Cast"
            )
        ]
        
        return quotes.shuffled().randomElement()
    }
}
