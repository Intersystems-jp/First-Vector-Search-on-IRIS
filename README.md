# First-Vector-Search-on-IRIS
Play Vector Search with only one IRIS class file.

# Description:
If you've not tried vector search on IRIS, this sample code will encourage you to do it!
This has only one IRIS class "Usre.nakav.cls". You will see how vector search works and how you can use only with this.


# How to run

(1) Import nakav.cls into any namespace.

(2) Install the python library "SentenceTransformer" on IRIS server as below:

* Windows:
  
> \> cd C:\InterSystems\IRIS\bin\
> \> irispip install --target ..\mgr\python sentence_transformers

* Linux / Containers
  
> $ pip3 install --target /usr/irissys/mgr/python sentence_transformers`

(3) Run init method, and 5 rows are stored in the table including vector values.

`do ##class(User.nakav).init()`
 
Please note "Embedd" method will convert a given string to the vector value with Python logic. You can see the table includes vector values with 2 queries. 

`SELECT ID, feedback from nakav`

![Search result](https://github.com/seisuke24am/First-Vector-Search-on-IRIS/blob/main/table1a.png?raw=true)
  
`SELECT ID, feedback, feedbackv from nakav `

![Search result](https://github.com/seisuke24am/First-Vector-Search-on-IRIS/blob/main/table2a.png?raw=true)


(4) Run "search" method. This will check which feedback sentence is the closet to the given question "**better feedback**" with comparing **vector value in each row**.

`SELECT ID, feedback FROM nakav ORDER BY VECTOR_DOT_PRODUCT(feedbackv, TO_VECTOR(questionv, DOUBLE, 384)) `

![Search result](https://github.com/seisuke24am/First-Vector-Search-on-IRIS/blob/main/search.png?raw=true)
