type vertex
    layer::Int #index of the layer in the graph
    i::Int  #index of the variable
    w::Int  #accumulated weight
    zλ::Int #best profit possible for zλ
    z1::Int #best profit possible for z1
    z2::Int #best profit possible for z2
    parent_0::Nullable{vertex} #parent node, with an edge having a profit == 0
    parent_1::Nullable{vertex} #parent node, with an edge having a profit > 0
    pb::problem
    mono_pb::mono_problem
end

# Base.show(io::IO, v::vertex) = print(io, "v_",v.i,"_",v.w,"(",v.zλ,")(",v.layer,")")
Base.show(io::IO, v::vertex) = print(io, "v_",v.i,"_",v.w,"(",v.z1,",",v.z2,")(",v.layer,")")

#v_i_0
source(pb::problem,mono_pb::mono_problem) = vertex(1,mono_pb.variables[1],mono_pb.ω,mono_pb.min_profit_λ,mono_pb.min_profit_1,mono_pb.min_profit_2,nothing,nothing,pb,mono_pb)

#inner degree of a vertex
inner_degree(v::vertex) = 2 - isnull(v.parent_0) - isnull(v.parent_1)

#Creates a vertex v_i+1_w from a vertex v_i_w assuming we decided not to pick item i
function vertex_skip(v::vertex)
    varplus1 = v.layer == size(v.mono_pb) ? v.layer + 1 : v.mono_pb.variables[v.layer+1]
    return vertex(v.layer+1, varplus1, v.w, v.zλ, v.z1, v.z2, v, nothing, v.pb, v.mono_pb)
end

#Creates a vertex v_i+1_w' from a vertex v_i_w assuming we decided to pick item i
function vertex_keep(v::vertex)
    #@assert v.mono_pb.variables[v.layer] == v.i
    var = v.i
    varplus1 = v.layer == size(v.mono_pb) ? v.layer + 1 : v.mono_pb.variables[v.layer+1]
    return vertex(v.layer+1,
            varplus1,
            v.w+v.mono_pb.w[var],
            v.zλ+v.mono_pb.p[var],
            v.z1+v.pb.p1[var],
            v.z2+v.pb.p2[var],
            nothing, v,
            v.pb,
            v.mono_pb)
end

#merge two vertices
function merge!(a::vertex, b::vertex)

    if b.zλ >= a.zλ
        a.zλ = b.zλ
        a.z1 = b.z1
        a.z2 = b.z2
    end

    a.parent_1 = b.parent_1
end

#Comparison functions for searchsorted()
weight_lt(v::vertex, w::Int) = v.w < w
weight_lt(w::Int, v::vertex) = w < v.w

#Returns the unique parent of a vertex
function parent(v::vertex)
    return isnull(v.parent_0) ? unsafe_get(v.parent_1) : unsafe_get(v.parent_0)
end

#Returns both parents of a vertex
function parents(v::vertex)
    return unsafe_get(v.parent_0), unsafe_get(v.parent_1)
end

zλ(v::vertex) = v.zλ
z1(v::vertex) = v.z1
z2(v::vertex) = v.z2
mono_pb(v::vertex)= v.mono_pb
pb(v::vertex) = v.pb