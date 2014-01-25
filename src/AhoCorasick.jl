module AhoCorasick
    include("node.jl")
    include("automaton.jl")
    export Automaton, build, add, search
end 
