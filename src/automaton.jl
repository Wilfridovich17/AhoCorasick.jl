type Automaton
    root :: Node
    case_sensitive :: Bool
    constructed :: Bool

    Automaton(case_sensitive :: Bool = true) = 
        new(Node(), case_sensitive, false)
end
 
function add (ac :: Automaton, word :: UTF8String, key :: Any = NoKey())
    if !ac.case_sensitive
        text = lowercase(word)
    end
    add (ac.root, word, key)
end

function add (ac :: Automaton, word :: String, key :: Any = NoKey())
    add (ac, utf8(word), key)
end
 
function build(ac :: Automaton)
    ac.root.fail = ac.root
    for child in values (ac.root.children)
        child.fail = ac.root
    end
    for child in values (ac.root.children)
        add_fail_transition!(child)
    end
end

type Match
    key :: Any
    start :: Int
    length :: Int
end
 
function search (ac :: Automaton, text :: UTF8String)
    if !ac.case_sensitive
        text = lowercase (text)
    end
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

function search (ac :: Automaton, text :: String)
    search(ac, utf8(text))
end
