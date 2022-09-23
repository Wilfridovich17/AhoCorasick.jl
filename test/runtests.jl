using AhoCorasick

function test()
    ac = Automaton()
    add(ac, "alpha")
    add(ac, "beta")
    build(ac)
    text = "the Alpha glycoprotein beta and alpha time"
    matches = search(ac, text)
end

test()