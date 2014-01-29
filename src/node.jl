import Base.show

type NullKey end
 
type Node
    depth :: Int
    key :: Any
    children :: Dict{Char, Node}
    fail :: Node

    Node(depth :: Int = 0) = (
        n = new(); 
        n.children = Dict{Char,Node}();
        n.depth = depth;
        n.key = NullKey;
        n
    )
end

function Base.show(io :: IO, node :: Node)
    write(io, "Node(depth=$(node.depth))")
end 

function add(node :: Node, word :: UTF8String, key :: Any)
    if length (word) == 0
        node.key = key
    else
        c = word[1]
        if !haskey(node.children, c)
            node.children[c] = Node(node.depth + 1)
        end
        add(node.children[c], word[2:end], key)
    end
end

function search_without_fail_transition(node :: Node, c :: Char)
    if haskey (node.children, c)
        node.children[c]
    else
        node
    end
end

function search (node :: Node, c :: Char)
    if haskey (node.children, c)
        node.children[c]
    elseif node.depth == 0
        node
    else
        search(node.fail, c)
    end
end

function add_fail_transition!(node :: Node)
    for (c,child) in node.children
        child.fail = search_without_fail_transition(node.fail, c)
    end
    for child in values(node.children)
        add_fail_transition!(child)
    end
end

function is_terminal(node :: Node)
    node.key != NullKey
end
