---
title: 'SQL vs NoSQL vs Search Engines'
description: "Which engine should you use for storing your data? If you're not 100% sure - this may point you in the right direction."
pubDate: 'Nov 05 2015'
category: 'Software Engineering'
tags: []
heroImage: '../../../assets/images/blog/software/sql-nosql-search.webp'
---

Which engine should you use to store your data?
Googling this question, brings up a few stackoverflows, the first few of the bunch say something like this:

> "There's no way to tell without knowing the specific problem you are trying to solve."

Or (exact quote):

> "Elasticsearch has *this* and *that* problem."

Or even:

> "Use OrientDB."

I will generally ignore implementation-specific features as evidence. Oracle may offer this feature, and MongoDB can offer another.
The way I see it -- all of these products are adding code where it doesn't belong, in order to help you become lazy.
Those features give you the option to only use *their* product, so you don't have to go spend your money anywhere else.
You get a jet to drive around the city.
Unfortunately when you're lazy, you can get pedestrians sucked into your engine.

## Relational database (SQL)

As this beautiful and large heading states, you should already know what this kind of database is designed for: relationships.

While structuring your problem with this data model is the most painful of the three, reminding you of coding before OOP, this is also the simplest structure.
You define the most basic entities in your product, and then you define their relationships.
There is no hierarchy.

Let me be clear: This is where you define *the entities and their relationships*.
If you have more than one entity (most likely) -- this is your primary data store.
It will maintain the relationship integrity (using foreign key constraints and transactions), and it will choose the primary keys for your basic entities (i.e. their unique identifiers).

You *can* use this database to store files, or to create awesome indices that will let you search quickly, and that's probably what most programmers do when it's the first database they learn to use.
Some implementations will even help you out, giving you the tools and the optimizations.
This is *not* what a relational database is for.
The indices are there for foreign key constraints, and the blobs are just a hack for the lazy (they even stand out in most implementations with the need to fetch them separately).

OK, you want evidence for why you shouldn't use it for non-relational purposes, so here it is:
This is the hardest data store to scale due to the inability to stretch related entities across multiple servers without compromising the performance of using said relationships.
\*inhale, exhale\*.

You should store in it as little as physically possible.

## Non relational database (NoSQL)

Well, this is where the data goes.
Like the name suggests, there are no relationships here.
This tool can be as simple as a filesystem, literally stating: "ask for a primary key, and get its contents".
Easy to scale, efficient to store.

Using MongoDB as an example, some implementations may offer you a key-value format, so instead of sending raw bytes, you send a map (or dictionary?).
Fine, still cool, data is data, and this gives you a nicer way to structure your problem into it -- instead of having more and more 1-dimensional collections (equivalent to different directories in a filesystem), each resource in the collection is a bunch of values under the same primary key.

Then you also get to index some of these values, to search a resource by a value other than the primary key.
I'll take that too if I want to avoid using multiple products for a *little bit* of lookup.
Not what I meant when I chose this data store type, but if there are no drawbacks on scale, sure.
When they offer you relations though -- they've gone too far.
Can't they read the heading?! It's even beautifully formatted and large.

## Search engine

To be honest, I'm not really sure it's called a "search engine", I think it doesn't have a name yet.
I also only know of one example implementation for this generic idea called Lucene (but you should really use one of its wrappers -- Solr or the more up to date Elasticsearch).

If you use custom indices for searching in SQL and NoSQL, you are going to love this.
Though what I really mean is: don't use custom indices for searching in SQL and NoSQL, use a search engine.
If it could talk like its NoSQL counterpart, it would be saying: "ask a complex question, and get the primary keys that answer that question".
It's also great for aggregations and analytics (as those are complex questions too!).

This engine gives you all the tools you need to search your data.
It can be scaled and optimized since it doesn't have relationships, and it can give you a lot of specialized indexing mechanisms such as full-text search, geolocation, or whatever the implementation supports.

You might be tempted to think: "*This* is an all-in-one solution, why should I use SQL/NoSQL?".
The downside here is that the documents you put in it need to be structured according the way you wish to search them.
This means duplications, which means a big mess.
This is not really a data-*base* -- it comes with too much business logic to be the "base".
Its usage might as well be defined directly by your product manager.
It will require rebuilding as you iterate on your product, so you should still keep the single source of truth in the data-*bases* (SQL and NoSQL).

## Conclusion

I recommend combining the 3 tools above.
All of them have free brands, and together they should solve most common storage and product requirements, no matter which implementation you choose.
You also get to learn new technologies and eventually age (your career) slower.

Got questions? Need help designing your architecture? Please <a href="https://linkedin.com/in/odedniv">reach out</a>!
