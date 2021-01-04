using Pkg


Pkg.add("Word2Vec")
Pkg.add("Gadfly")

using Word2Vec, Gadfly

?word2vec


word2vec("Downloads/text8", "text8-vec.txt",verbose=true)

model = wordvectors("text8-vec.txt")

cosine_similar_words(model, "door")

analogy_words(model, ["women"], ["man"], 10)

word2clusters("Downloads/text8", "text8-class.txt",500)

wordcluster = wordclusters("text8-class.txt")

clusters(wordcluster)

similarity(model,"one","two")

get_cluster(wordcluster,"max")

function chart_similarity(word,model)
    idxs, dists = cosine(model,word)
    vocab = vocabulary(model)
    plot(x=vocab[idxs],y=dists)
end

chart_similarity("petrol",model)

function search_dissimilarity(word,model)
    vocab= vocabulary(model)
    values= map((x)-> similarity(model,x,word),vocab)
    dict= Dict(zip(vocab,values))
    disimalardict=filter(p->(last(p)<0),dict)
    disimilardictsort= sort(collect(disimilardict),by=x->x[2])
    dissimilarwords=map((x)-> first(x), disimilardictsort)
    println("dissimilar words to $(word) are : - ")
    for i in dissimilarwords[1:10] print(i,",")end
    
end

search_dissimilarity("bat",model)

function search_similar(word,model)
    similarwords= cosine_similar_words(model,word)
    println("Same words to $(word) are: - ")
    for i in similarwords print(i,",") end
end

search_similar("apple", model)

cosine_simiiliar

function vec_search_similar(vec,model)
vocab=vocabulary(model)
values=map((x)->dot(get_vector(model,x),vec)/(norm(get_vector(model,x))*norm(vec)),vocab)
dict=Dict(zip(vocab,values))
similardict= filter(p->(last(p)>0),dict)
similardictsort=sort(collect(similardict), by=x->x[2], rev=true)
similarwords= map((x)-> first(x), similardictsort)[1:10]
println("Same words to $(similarwords[1]) are:")
for i in similarwords print(i,",") end
print("....")
end

y = get_vector(model,"anniversary")
#vec_search_similar(y,model)

?analogy

?analogy_words

analogy_words(model, ["paris", "germany"], ["france"], 10)

analogy_words(model, ["man", "woman","king"], ["queen","child"], 10)

model3 = wordclusters("text8-class.txt")

clusters(model3)





function output_w(wpos,wneg,size)
    pos = split(wpos, "+")
    neg = split(wneg, "-")
    print(wpos)
    print(" - ")
    print(wneg)
    print(" = ")
    print(analog_words(model, pos, neg, size ))
end

output_w("man+woman+child","king-queen",5)


