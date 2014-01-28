type Automaton
    root :: Node
    case_sensitive :: Bool
    constructed :: Bool

    Automaton(case_sensitive :: Bool = true) = 
        new(Node(), case_sensitive, false)
end
 
function add (ac :: Automaton, word :: String, key :: Any = NoKey())
    if ac.constructed
        error("Can't add words to an automaton that has already been initialized.")
    end
    if !ac.case_sensitive
        word = lowercase(word)
    end
    add(ac.root, utf8(word), key)
end

function build(ac :: Automaton)
    if ac.constructed
        return
    end
    ac.root.fail = ac.root
    for child in values (ac.root.children)
        child.fail = ac.root
    end
    for child in values (ac.root.children)
        add_fail_transition!(child)
    end
    ac.constructed = true
end

type Match
    key :: Any
    start :: Int
    length :: Int
end
 
function search (ac :: Automaton, text :: String)
    if !ac.case_sensitive
        text = lowercase (text)
    end
    text = utf8(text)
    i = 0
    node = ac.root
    matches = Match[]
    while length (text) > 0
        i += 1
        node = search (node, text[1])
        if is_terminal(node)
            n = node
            while is_terminal(n)
                start = (1+i-n.depth)
                length = i - start
                push!(matches, Match(n.key, start, length))
                n = n.fail
            end
        end
        text = text[2:end]
    end
    matches
end
